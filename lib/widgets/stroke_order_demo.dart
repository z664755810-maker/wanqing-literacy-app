import 'dart:math' as math;
import 'dart:typed_data' show Float64List;

import 'package:flutter/material.dart';

import '../services/stroke_data.dart';
import '../theme/app_dimens.dart';
import '../theme/app_theme.dart';

/// 笔顺演示栏：点「演示一遍」，把汉字**像老师写字一样逐笔描画**在屏幕上（田字格 + 浅色范字底图 +
/// 黛青/墨色逐笔墨水 + 笔尖小点），下方步骤列表同步高亮「当前第几笔」。全程**无音频**。
///
/// 与设计稿的差别：老年用户听不懂笔画名朗读、且旧朗读偏快，故用「看笔画顺序」替代「朗读笔画顺序」。
///
/// 🔴 约束与坑（沿用旧版）：
/// - **绝不** import / 调用 TtsService、voice_player —— 本组件无任何声音。
/// - 内部滚动只包住步骤列表，**绝不包住手写板**：描红页竖向手势必须全部归手写板。
/// - 高度**有界**时用独立 [SingleChildScrollView] 滚动；高度**无界**（ExpansionTile/ListView）时
///   退化成不滚动的完整列表，避免 Expanded 报错。
/// - [dispose] 必须 dispose 掉 AnimationController，否则动画中途离开页面会 setState after dispose。
/// - 所有 parse 都包在 try 里，坏数据只降级（显示大字 + 「此字暂无笔顺演示」），绝不崩溃。
class StrokeOrderDemo extends StatefulWidget {
  /// 目标汉字（只用于查笔顺数据 + 展示标题，不参与判定）
  final String char;

  /// 期望笔画名，来自 `CharCard.strokeNames`
  final List<String> strokeNames;

  /// 固定宽度；null = 由父级约束决定（无界场景降级到 320 以内）
  final double? width;

  const StrokeOrderDemo({
    super.key,
    required this.char,
    required this.strokeNames,
    this.width,
  });

  @override
  State<StrokeOrderDemo> createState() => _StrokeOrderDemoState();
}

class _StrokeOrderDemoState extends State<StrokeOrderDemo> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  /// 数据是否已加载（加载完成前显示降级占位，避免空帧闪烁）
  bool _loaded = false;

  /// 是否正在播放
  bool _playing = false;

  /// 当前高亮到第几笔（0 起）；-1 = 静止
  int _current = -1;

  // ---- 尺寸无关、加载后即可算出的原始数据 ----
  List<List<Offset>> _rawMedians = const <List<Offset>>[];
  List<Path> _guidePaths = const <Path>[];
  double _minX = 0, _minY = 0, _maxX = 0, _maxY = 0;
  bool _bboxValid = false;

  // ---- 尺寸相关（build 里按画布边长计算并缓存，供动画监听映射笔序）----
  List<List<Offset>> _screenStrokes = const <List<Offset>>[];
  List<double> _cumStart = const <double>[];
  List<double> _cumEnd = const <double>[];
  double _totalLen = 0;
  Float64List? _guideMatrix;
  double _side = 0;

  bool get _hasData => _loaded && StrokeData.hasData(widget.char);

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 3));
    _ctrl.addListener(_onTick);
    _ctrl.addStatusListener(_onStatus);
    _load();
  }

  @override
  void didUpdateWidget(covariant StrokeOrderDemo old) {
    super.didUpdateWidget(old);
    // 换字：必须重建（否则上一字的高亮进度/播放会串到下一个字）
    if (old.char != widget.char) {
      _ctrl.stop();
      _playing = false;
      _current = -1;
      _resetGeometry();
      _load();
    }
  }

  void _resetGeometry() {
    _rawMedians = const <List<Offset>>[];
    _guidePaths = const <Path>[];
    _screenStrokes = const <List<Offset>>[];
    _cumStart = const <double>[];
    _cumEnd = const <double>[];
    _totalLen = 0;
    _guideMatrix = null;
    _bboxValid = false;
    _side = 0;
  }

  void _load() {
    StrokeData.load().then((_) {
      if (!mounted) return;
      _prepareRaw();
      setState(() => _loaded = true);
    });
  }

  /// 加载后算出尺寸无关的原始数据 + 包围盒（中线点 ∪ 轮廓点）。
  void _prepareRaw() {
    if (!StrokeData.hasData(widget.char)) return;
    _rawMedians = StrokeData.mediansOf(widget.char);
    _guidePaths = StrokeData.outlinePathsOf(widget.char);

    double minX = double.infinity;
    double minY = double.infinity;
    double maxX = double.negativeInfinity;
    double maxY = double.negativeInfinity;
    void eat(Offset p) {
      if (p.dx < minX) minX = p.dx;
      if (p.dy < minY) minY = p.dy;
      if (p.dx > maxX) maxX = p.dx;
      if (p.dy > maxY) maxY = p.dy;
    }

    for (final List<Offset> stroke in _rawMedians) {
      for (final Offset p in stroke) {
        eat(p);
      }
    }
    for (final Offset p in StrokeData.outlinePointsOf(widget.char)) {
      eat(p);
    }

    if (minX.isFinite && maxX.isFinite && maxX > minX && maxY > minY) {
      _minX = minX;
      _minY = minY;
      _maxX = maxX;
      _maxY = maxY;
      _bboxValid = true;
    }
  }

  /// 按画布边长算出屏幕坐标中线、累计长度、以及轮廓底图的变换矩阵。
  void _computeGeometry(double side) {
    _side = side;
    if (!_bboxValid || _rawMedians.isEmpty) return;
    final double pad = side * 0.06;
    final double bw = _maxX - _minX;
    final double bh = _maxY - _minY;
    final double scale = (side - 2 * pad) / math.max(bw, bh);
    final double tx = pad - scale * _minX;
    final double ty = pad + scale * _maxY; // 翻转 y → 正立

    // 轮廓底图：用 canvas.transform 直接画原始坐标 path（列主序 Float64List）
    final Float64List m = Float64List(16);
    m[0] = scale;
    m[5] = -scale;
    m[10] = 1;
    m[12] = tx;
    m[13] = ty;
    m[15] = 1;
    _guideMatrix = m;

    // 中线 → 屏幕坐标（手动翻转，便于逐笔揭示与笔尖定位）
    _screenStrokes = _rawMedians.map((List<Offset> pts) {
      return pts.map((Offset p) {
        return Offset(pad + (p.dx - _minX) * scale, pad + (_maxY - p.dy) * scale);
      }).toList();
    }).toList();

    _cumStart = <double>[];
    _cumEnd = <double>[];
    _totalLen = 0;
    for (final List<Offset> pts in _screenStrokes) {
      double len = 0;
      for (int j = 1; j < pts.length; j++) {
        len += (pts[j] - pts[j - 1]).distance;
      }
      _cumStart.add(_totalLen);
      _totalLen += len;
      _cumEnd.add(_totalLen);
    }
  }

  /// 进度(0..1) → 当前正在写的第几笔
  int _indexFor(double progress) {
    if (_screenStrokes.isEmpty || _totalLen <= 0) return -1;
    final double drawn = progress * _totalLen;
    for (int k = 0; k < _screenStrokes.length; k++) {
      if (drawn <= _cumEnd[k]) return k;
    }
    return _screenStrokes.length - 1;
  }

  void _onTick() {
    if (!mounted) return;
    final int idx = _indexFor(_ctrl.value);
    if (idx != _current) {
      setState(() => _current = idx);
    }
  }

  void _onStatus(AnimationStatus s) {
    if (s == AnimationStatus.completed) {
      if (mounted) setState(() => _playing = false);
    } else if (s == AnimationStatus.dismissed) {
      if (mounted) setState(() => _playing = false);
    }
  }

  void _toggle() {
    if (!_hasData) return;
    if (_playing) {
      _ctrl.stop();
      if (mounted) setState(() => _playing = false);
      return;
    }
    // 从 0 开始演示一遍：速度正比于总笔画长度，节奏自然
    final double pxPerSec = _side > 0 ? _side * 0.7 : 200.0;
    final double dur = _totalLen > 0 ? (_totalLen / pxPerSec) : 3.0;
    _ctrl.duration = Duration(milliseconds: (dur.clamp(1.2, 9.0) * 1000).round());
    _current = -1;
    _playing = true;
    if (mounted) setState(() {});
    _ctrl.forward(from: 0);
  }

  @override
  void dispose() {
    _ctrl.removeListener(_onTick);
    _ctrl.removeStatusListener(_onStatus);
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppDimens d = AppDimens.of(context);
    final List<String> names = widget.strokeNames;

    final Widget content = LayoutBuilder(
      builder: (BuildContext ctx, BoxConstraints c) {
        double side;
        if (widget.width != null) {
          side = widget.width!;
        } else {
          side = c.hasBoundedWidth ? c.maxWidth : 220.0;
          side = side.clamp(0.0, 320.0);
        }
        if (c.hasBoundedHeight) side = math.min(side, c.maxHeight);
        side = side > 0 ? side : 200.0;

        if (_hasData) _computeGeometry(side);

        final List<Widget> children = <Widget>[
          Text(
            '笔顺演示${names.isEmpty ? '' : '（${names.length}笔）'}',
            style: AppTheme.serif(size: d.fs(16), color: AppTheme.ink2, w: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: d.fs(AppDimens.gapS)),
        ];

        if (_hasData) {
          children.add(
              SizedBox(
              width: side,
              height: side,
              child: CustomPaint(
                painter: _StrokePainter(
                  ctrl: _ctrl,
                  side: side,
                  screenStrokes: _screenStrokes,
                  cumStart: _cumStart,
                  cumEnd: _cumEnd,
                  totalLen: _totalLen,
                  guidePaths: _guidePaths,
                  guideMatrix: _guideMatrix,
                ),
              ),
            ),
          );
        } else {
          // 优雅降级：放大字 + 提示，禁用按钮
          children.add(
            Container(
              width: side,
              height: side,
              alignment: Alignment.center,
              child: Text(
                widget.char,
                style: AppTheme.serif(size: side * 0.62, color: AppTheme.ink2, w: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
            ),
          );
          children.add(SizedBox(height: d.fs(AppDimens.gapXs)));
          children.add(
            Text(
              '此字暂无笔顺演示',
              style: AppTheme.sans(size: d.fs(14), color: AppTheme.ink2),
              textAlign: TextAlign.center,
            ),
          );
        }

        if (names.isNotEmpty) {
          final List<Widget> steps = <Widget>[
            for (int i = 0; i < names.length; i++)
              Padding(
                padding: EdgeInsets.only(bottom: d.fs(AppDimens.gapXs)),
                child: _StepTile(d: d, index: i, name: names[i], active: i == _current),
              ),
          ];
          final Widget list = c.hasBoundedHeight
              ? Expanded(
                  child: SingleChildScrollView(
                    child: Column(mainAxisSize: MainAxisSize.min, children: steps),
                  ),
                )
              : Column(mainAxisSize: MainAxisSize.min, children: steps);
          children.add(list);
        }

        children.add(SizedBox(height: d.fs(AppDimens.gapS)));
        children.add(_WatchButton(d: d, playing: _playing, onTap: _hasData ? _toggle : null));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: c.hasBoundedHeight ? MainAxisSize.max : MainAxisSize.min,
          children: children,
        );
      },
    );

    final Widget boxed = Container(
      padding: EdgeInsets.all(d.fs(AppDimens.gapS)),
      decoration: BoxDecoration(
        color: AppTheme.paper,
        borderRadius: BorderRadius.circular(AppDimens.radius),
        border: Border.all(color: AppTheme.line),
      ),
      child: content,
    );

    return widget.width == null ? boxed : SizedBox(width: widget.width, child: boxed);
  }
}

/// 一步：序号 + 笔画名。高亮态用黛青浅底（正向色，绝不用红/叉）。
class _StepTile extends StatelessWidget {
  final AppDimens d;
  final int index;
  final String name;
  final bool active;

  const _StepTile({required this.d, required this.index, required this.name, required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: d.fs(34),
      padding: EdgeInsets.symmetric(horizontal: d.fs(AppDimens.gapS)),
      decoration: BoxDecoration(
        color: active ? AppTheme.daiSoft : AppTheme.paper2,
        borderRadius: BorderRadius.circular(AppDimens.radiusSm),
        border: Border.all(
          color: active ? AppTheme.dai : AppTheme.line,
          width: active ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: d.fs(20),
            child: Text(
              '${index + 1}',
              style: AppTheme.sans(
                size: d.fs(14),
                color: active ? AppTheme.dai : AppTheme.ink2,
                w: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                name,
                style: AppTheme.serif(
                  size: d.fs(18),
                  color: AppTheme.ink,
                  w: active ? FontWeight.w700 : FontWeight.normal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 「演示一遍 / 停一下」按钮：无音频。窄栏里保证触控热区，文字过长自动缩放不换行。
class _WatchButton extends StatelessWidget {
  final AppDimens d;
  final bool playing;
  final VoidCallback? onTap;

  const _WatchButton({required this.d, required this.playing, this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool enabled = onTap != null;
    return Material(
      color: playing ? AppTheme.paper2 : AppTheme.dai,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusSm),
        side: BorderSide(color: AppTheme.dai, width: playing ? 1.5 : 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.radiusSm),
        child: Container(
          constraints: BoxConstraints(minHeight: d.touch * 0.75),
          padding: EdgeInsets.symmetric(horizontal: d.fs(AppDimens.gapS)),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  playing ? Icons.pause_outlined : Icons.play_arrow_outlined,
                  size: d.fs(20),
                  color: enabled ? (playing ? AppTheme.dai : Colors.white) : AppTheme.ink2,
                ),
                SizedBox(width: d.fs(AppDimens.gapXs)),
                Text(
                  playing ? '停一下' : '演示一遍',
                  style: AppTheme.serif(
                    size: d.fs(16),
                    color: enabled ? (playing ? AppTheme.dai : Colors.white) : AppTheme.ink2,
                    w: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 画布：田字格 + 浅色范字底图（轮廓填充）+ 逐笔墨水（中线粗圆头笔）+ 笔尖点。
class _StrokePainter extends CustomPainter {
  final Animation<double> ctrl;
  final double side;
  final List<List<Offset>> screenStrokes;
  final List<double> cumStart;
  final List<double> cumEnd;
  final double totalLen;
  final List<Path> guidePaths;
  final Float64List? guideMatrix;

  _StrokePainter({
    required this.ctrl,
    required this.side,
    required this.screenStrokes,
    required this.cumStart,
    required this.cumEnd,
    required this.totalLen,
    required this.guidePaths,
    required this.guideMatrix,
  }) : super(repaint: ctrl);

  @override
  void paint(Canvas canvas, Size size) {
    _paintGrid(canvas, side);

    // 浅色范字底图：直接画原始坐标轮廓，由 canvas.transform 翻转并缩放
    if (guidePaths.isNotEmpty && guideMatrix != null) {
      canvas.save();
      canvas.transform(guideMatrix!);
      final Paint gp = Paint()
        ..color = const Color(0x73D8CDB4) // 浅灰范字底图（≈ AppTheme.line 45% 不透明）
        ..style = PaintingStyle.fill;
      for (final Path p in guidePaths) {
        canvas.drawPath(p, gp);
      }
      canvas.restore();
    }

    _paintInk(canvas, ctrl.value);
  }

  void _paintGrid(Canvas canvas, double s) {
    final Paint paint = Paint()
      ..color = AppTheme.line
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1.0, s * 0.006);
    canvas.drawRect(Rect.fromLTWH(0, 0, s, s), paint);
    canvas.drawLine(Offset(s / 2, 0), Offset(s / 2, s), paint);
    canvas.drawLine(Offset(0, s / 2), Offset(s, s / 2), paint);
  }

  void _paintInk(Canvas canvas, double progress) {
    if (screenStrokes.isEmpty || totalLen <= 0) return;
    final double inkW = side * 0.07;
    final Paint ink = Paint()
      ..color = AppTheme.ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = inkW
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final double drawn = progress.clamp(0, 1) * totalLen;
    final bool showPen = drawn > 0 && drawn < totalLen;
    double remaining = drawn;
    Offset pen = screenStrokes.first.first;

    for (int k = 0; k < screenStrokes.length; k++) {
      final List<Offset> pts = screenStrokes[k];
      if (pts.isEmpty) continue;
      final double len = cumEnd[k] - cumStart[k];
      if (remaining <= 0) break;

      if (remaining >= len) {
          final Path path = Path()..moveTo(pts[0].dx, pts[0].dy);
        for (int j = 1; j < pts.length; j++) {
          path.lineTo(pts[j].dx, pts[j].dy);
        }
        canvas.drawPath(path, ink);
        pen = pts.last;
        remaining -= len;
      } else {
        final Path path = Path()..moveTo(pts[0].dx, pts[0].dy);
        double acc = 0;
        for (int j = 1; j < pts.length; j++) {
          final double seg = (pts[j] - pts[j - 1]).distance;
          if (acc + seg <= remaining) {
            path.lineTo(pts[j].dx, pts[j].dy);
            acc += seg;
          } else {
            final double t = seg > 0 ? (remaining - acc) / seg : 0;
            final Offset p = Offset(
              pts[j - 1].dx + (pts[j].dx - pts[j - 1].dx) * t,
              pts[j - 1].dy + (pts[j].dy - pts[j - 1].dy) * t,
            );
            path.lineTo(p.dx, p.dy);
            pen = p;
            canvas.drawPath(path, ink);
            remaining = 0;
            break;
          }
        }
        if (remaining > 0) {
          // 整条都在 remaining 内（极短笔），直接补全
          for (int j = 1; j < pts.length; j++) {
            path.lineTo(pts[j].dx, pts[j].dy);
          }
          pen = pts.last;
        }
        canvas.drawPath(path, ink);
        remaining = 0;
        break;
      }
    }

    if (showPen) {
      final Paint tip = Paint()..color = AppTheme.dai..style = PaintingStyle.fill;
      canvas.drawCircle(pen, inkW * 0.5, tip);
    }
  }

  @override
  bool shouldRepaint(covariant _StrokePainter old) =>
      old.ctrl != ctrl ||
      old.side != side ||
      old.totalLen != totalLen ||
      old.guideMatrix != guideMatrix ||
      old.screenStrokes != screenStrokes;
}

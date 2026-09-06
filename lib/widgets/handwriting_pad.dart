import 'package:flutter/material.dart';
import 'package:wanqing_shizi/services/stroke_check_service.dart';
import 'package:wanqing_shizi/services/tts_service.dart';
import 'package:wanqing_shizi/theme/app_dimens.dart';
import 'package:wanqing_shizi/theme/app_theme.dart';

/// 田字格手写板：记录手指轨迹，写完给反馈。
///
/// 反馈分两档：
/// - 传了 [strokeNames]（来自 `kCharLibrary[char]!.strokeNames`）→ 走 [StrokeCheckService]
///   做笔画数/笔形/顺序自检，用对话框给**最多 2 条**温和建议 + 「再写一遍」。
/// - 没传 → 保持旧行为：只给一句鼓励（纯临摹、不判定）。
///
/// 🔴 红线不变：**绝不打叉、不打分、不羞辱**，所有文案鼓励式。
class HandwritingPad extends StatefulWidget {
  final double size;
  final String guideChar;
  final ValueChanged<String> onSubmit;

  /// 期望笔画名；null / 空 = 不判定（退回纯鼓励）
  final List<String>? strokeNames;

  const HandwritingPad({
    super.key,
    required this.size,
    required this.guideChar,
    required this.onSubmit,
    this.strokeNames,
  });

  @override
  State<HandwritingPad> createState() => _HandwritingPadState();
}

class _HandwritingPadState extends State<HandwritingPad> {
  final List<List<Offset>> _strokes = [];
  List<Offset> _current = [];

  void _start(Offset p) {
    setState(() => _current = [p]);
  }

  void _move(Offset p) {
    if (_current.isEmpty) return;
    setState(() => _current.add(p));
  }

  void _end() {
    if (_current.length >= 2) {
      setState(() {
        _strokes.add(List.from(_current));
        _current = [];
      });
    } else {
      setState(() => _current = []);
    }
  }

  void _clear() {
    setState(() {
      _strokes.clear();
      _current = [];
    });
  }

  void _submit() {
    if (_strokes.isEmpty) {
      widget.onSubmit('还没有写呢，用手指在格子里写一遍吧。');
      TtsService.instance.speak('还没有写呢，用手指在格子里写一遍吧。');
      return;
    }

    final List<String>? expected = widget.strokeNames;
    if (expected == null || expected.isEmpty) {
      // 字库里没有笔顺数据 → 不瞎判，只给鼓励（老行为）。
      const String result = '写得真认真，多练几遍就熟了，慢慢来。';
      widget.onSubmit(result);
      TtsService.instance.speak(result);
      return;
    }

    final StrokeCheckResult r = StrokeCheckService.check(
      strokes: _strokes,
      expectedStrokeNames: expected,
      padSize: widget.size,
    );
    TtsService.instance.speak(r.summary);
    _showResult(r);
  }

  /// 结果卡片：通过=一句表扬；有问题=最多 2 条建议 + 「再写一遍」。
  /// 刻意不再走外层 SnackBar（同时弹两处提示太吵），只弹这一个对话框。
  void _showResult(StrokeCheckResult r) {
    final AppDimens d = AppDimens.of(context);
    showDialog<void>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        backgroundColor: AppTheme.paper,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.radius)),
        title: Row(
          children: <Widget>[
            Icon(
              r.pass ? Icons.emoji_emotions_outlined : Icons.spa_outlined,
              size: d.fs(28),
              color: AppTheme.dai,
            ),
            SizedBox(width: d.fs(AppDimens.gapS)),
            Expanded(
              child: Text(
                r.pass ? '写得很好' : '写得挺认真',
                style: AppTheme.serif(size: d.fs(22), w: FontWeight.w700),
              ),
            ),
          ],
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (r.pass)
              Text(
                '笔画和顺序都对上了，接着练下一个吧。',
                style: AppTheme.serif(size: d.fs(19), color: AppTheme.ink2, h: 1.5),
              )
            else
              for (final String a in r.advices)
                Padding(
                  padding: EdgeInsets.only(bottom: d.fs(AppDimens.gapS)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.brush_outlined, size: d.fs(20), color: AppTheme.zhe),
                      SizedBox(width: d.fs(AppDimens.gapS)),
                      Expanded(
                        child: Text(
                          a,
                          style: AppTheme.serif(size: d.fs(19), color: AppTheme.ink, h: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),
            if (!r.pass) ...<Widget>[
              SizedBox(height: d.fs(AppDimens.gapXs)),
              Text(
                '不着急，照着旁边的笔顺再写一遍就顺了。',
                style: AppTheme.serif(size: d.fs(17), color: AppTheme.ink2, h: 1.5),
              ),
            ],
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('知道了', style: AppTheme.serif(size: d.fs(18), color: AppTheme.ink2)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _clear();
            },
            child: Text(
              '再写一遍',
              style: AppTheme.serif(size: d.fs(18), color: AppTheme.dai, w: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.size;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: s,
          height: s,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFD8CDB4)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: GestureDetector(
              // 🔴 关键：CustomPaint 默认不接收命中测试；若不设 opaque，竖笔手势会被「穿透」到外层，
              //    表现为「手指一写整屏跟着滑」。opaque 让手写板独占这一格内的全部手势（断笔/多笔都归它）。
              behavior: HitTestBehavior.opaque,
              onPanStart: (d) => _start(d.localPosition),
              onPanUpdate: (d) => _move(d.localPosition),
              onPanEnd: (_) => _end(),
              child: CustomPaint(
                size: Size(s, s),
                painter: _HandwritingPainter(
                  strokes: _strokes,
                  current: _current,
                  guideChar: widget.guideChar,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton.icon(
              onPressed: _clear,
              icon: const Icon(Icons.clear, color: AppTheme.ink2),
              label: Text('重写', style: AppTheme.sans(size: 15, color: AppTheme.ink2)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFD8CDB4)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.check, color: AppTheme.paper),
              label: Text('看看写得怎样', style: AppTheme.sans(size: 15, color: AppTheme.paper)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.dai,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _HandwritingPainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final List<Offset> current;
  final String guideChar;

  _HandwritingPainter({required this.strokes, required this.current, required this.guideChar});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 田字格
    final gridPaint = Paint()
      ..color = const Color(0xFFE0D8C8)
      ..strokeWidth = 1.5;
    canvas.drawLine(Offset(w / 2, 0), Offset(w / 2, h), gridPaint);
    canvas.drawLine(Offset(0, h / 2), Offset(w, h / 2), gridPaint);
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), gridPaint..style = PaintingStyle.stroke);

    // 对角线
    final diagPaint = Paint()
      ..color = const Color(0xFFEFE8DA)
      ..strokeWidth = 1;
    canvas.drawLine(const Offset(0, 0), Offset(w, h), diagPaint);
    canvas.drawLine(Offset(w, 0), Offset(0, h), diagPaint);

    // 浅色范字
    final guideText = TextPainter(
      text: TextSpan(
        text: guideChar,
        style: TextStyle(
          fontSize: w * 0.65,
          color: const Color(0xFFE8E0D0),
          fontFamily: 'serif',
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    guideText.layout();
    guideText.paint(canvas, Offset((w - guideText.width) / 2, (h - guideText.height) / 2));

    // 用户笔迹
    final paint = Paint()
      ..color = AppTheme.dai
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    for (final stroke in [...strokes, if (current.isNotEmpty) current]) {
      if (stroke.length < 2) continue;
      final path = Path();
      path.moveTo(stroke.first.dx, stroke.first.dy);
      for (int i = 1; i < stroke.length; i++) {
        path.lineTo(stroke[i].dx, stroke[i].dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

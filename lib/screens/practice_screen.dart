import 'dart:math';

import 'package:flutter/material.dart';

import '../app_router.dart';
import '../data/char_library.dart';
import '../services/tts_service.dart';
import '../state/app_state.dart';
import '../theme/app_dimens.dart';
import '../theme/app_theme.dart';
import '../widgets/gentle_hint.dart';
import '../widgets/handwriting_pad.dart';
import '../widgets/stroke_order_demo.dart';

/// 当堂轻练习：三种模式
/// - audio = 听音认字
/// - image = 看意思认字（字库暂无配图，用释义作视觉提示）
/// - trace = 描红写一写（田字格描摹，纯临摹无判定）
///
/// 硬约束（认字模式）：**无倒计时、无分数、无错题惩罚**；答错只提示「再试一次哦」，可无限重试、不锁进度。
/// 选项生成：目标字 + 2 个干扰字（优先从已学字里取，不足则回退字库），打乱后展示。
/// 铁律：TTS 只传真实汉字（[TtsService.speakChar] 内部三段式），绝不碰拼音。
class PracticeScreen extends StatefulWidget {
  /// 本次练习的字集合（通常来自某课的全部字）
  final List<String> chars;

  /// 题型：audio = 听音认字；image = 看意思认字；trace = 描红写一写
  final String mode;

  const PracticeScreen({super.key, this.chars = const <String>[], this.mode = 'audio'});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  late final List<String> _queue;
  late final Map<String, List<String>> _options;
  int _idx = 0;
  String? _picked;
  bool _solved = false;
  final Random _rnd = Random();

  @override
  void initState() {
    super.initState();
    _queue = List<String>.from(widget.chars.where((String c) => kCharLibrary.containsKey(c)));
    _options = <String, List<String>>{};
    for (final String c in _queue) {
      _options[c] = _buildOptions(c);
    }
    if (_queue.isNotEmpty && widget.mode == 'audio') _play();
  }

  /// 取 2 个干扰字（排除目标），优先已学字，不足回退全字库。
  List<String> _buildOptions(String target) {
    final Set<String> pool = AppState.instance.progress.learnedChars;
    final List<String> cand = (pool.length >= 3 ? pool : kCharLibrary.keys.toSet())
        .where((String c) => c != target)
        .toList();
    cand.shuffle(_rnd);
    final List<String> opts = <String>[target, ...cand.take(2)];
    opts.shuffle(_rnd);
    return opts;
  }

  void _play() {
    if (_idx < _queue.length) TtsService.instance.speakChar(_queue[_idx]);
  }

  void _pick(String c) {
    if (_solved) return;
    setState(() {
      _picked = c;
      if (c == _queue[_idx]) _solved = true;
    });
  }

  void _next() {
    TtsService.instance.stop();
    setState(() {
      if (_idx < _queue.length - 1) {
        _idx++;
        _picked = null;
        _solved = false;
        if (widget.mode == 'audio') _play();
      } else {
        _idx = _queue.length; // 进入完成页
      }
    });
  }

  @override
  void dispose() {
    TtsService.instance.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppDimens d = AppDimens.of(context);
    final bool isImage = widget.mode == 'image';
    final bool isTrace = widget.mode == 'trace';

    if (_queue.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('练一练', style: AppTheme.serif(size: d.fs(26)))),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.school_outlined, size: d.fs(72), color: AppTheme.dai),
                SizedBox(height: d.fs(AppDimens.gapM)),
                Text('没有要练的字', style: AppTheme.serif(size: d.fs(24))),
                SizedBox(height: d.fs(AppDimens.gapL)),
                _BackBtn(d: d),
              ],
            ),
          ),
        ),
      );
    }

    // 完成页
    if (_idx >= _queue.length) {
      return Scaffold(
        appBar: AppBar(title: Text('练一练', style: AppTheme.serif(size: d.fs(26)))),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.emoji_emotions_outlined, size: d.fs(80), color: AppTheme.dai),
                SizedBox(height: d.fs(AppDimens.gapM)),
                Text('练完啦，真棒！', style: AppTheme.serif(size: d.fs(30), w: FontWeight.w600)),
                SizedBox(height: d.fs(AppDimens.gapL)),
                SizedBox(
                  width: d.fs(360),
                  child: _BigAction(
                    d: d,
                    label: '去复习',
                    icon: Icons.replay_outlined,
                    onTap: () => Navigator.pushReplacementNamed(context, AppRouter.review),
                  ),
                ),
                SizedBox(height: d.fs(AppDimens.gapM)),
                SizedBox(width: d.fs(360), child: _BackBtn(d: d)),
              ],
            ),
          ),
        ),
      );
    }

    final String target = _queue[_idx];
    final CharCard? targetCard = kCharLibrary[target];
    final List<String> opts = _options[target] ?? <String>[target];

    return Scaffold(
      appBar: AppBar(
        title: Text(isTrace ? '描红写一写' : (isImage ? '看意思认字' : '听音认字'), style: AppTheme.serif(size: d.fs(26))),
      ),
      body: SafeArea(
        child: isTrace
            // 🔴 描红模式刻意不放进滚动视图：田字格里的竖笔/断笔需要整段手势都归手写板，
            //    一旦外层 ListView 抢走纵向拖拽，汉字就「只能连笔写完」。所以这里用不滚动的
            //    固定布局，手写板独占手势（多笔/断笔天然支持，与输入法手写一致）。
            ? _TraceBody(
                d: d,
                target: target,
                play: _play,
                next: _next,
                idx: _idx,
                total: _queue.length,
              )
            : ListView(
                padding: EdgeInsets.all(d.pagePad),
                children: <Widget>[
                  Text('第 ${_idx + 1} / ${_queue.length} 个', style: AppTheme.sans(size: d.fs(18), color: AppTheme.ink2)),
                  SizedBox(height: d.fs(AppDimens.gapM)),
                  ..._recognitionChildren(d, target, targetCard, opts, isImage),
                ],
              ),
      ),
    );
  }

  /// 认字模式（听音 / 看意思）：选项 + 反馈。
  List<Widget> _recognitionChildren(AppDimens d, String target, CharCard? targetCard, List<String> opts, bool isImage) {
    return <Widget>[
      if (isImage) ...<Widget>[
        Text('下面是哪个字的意思？', style: AppTheme.serif(size: d.fs(22), color: AppTheme.ink2)),
        SizedBox(height: d.fs(AppDimens.gapS)),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(d.fs(AppDimens.gapM)),
          decoration: BoxDecoration(color: AppTheme.zheSoft, borderRadius: BorderRadius.circular(AppDimens.radius)),
          child: Text(targetCard?.meaning ?? '', style: AppTheme.serif(size: d.fs(34), w: FontWeight.w600), textAlign: TextAlign.center),
        ),
        SizedBox(height: d.fs(AppDimens.gapM)),
      ] else ...<Widget>[
        _BigAction(d: d, label: '听一听', icon: Icons.volume_up_outlined, onTap: _play),
        SizedBox(height: d.fs(AppDimens.gapM)),
      ],
      Text('点一个正确的字', style: AppTheme.serif(size: d.fs(22), color: AppTheme.ink2)),
      SizedBox(height: d.fs(AppDimens.gapM)),
      for (final String opt in opts) ...<Widget>[
        _OptionBtn(d: d, char: opt, state: _optState(opt, target), onTap: () => _pick(opt)),
        SizedBox(height: d.fs(AppDimens.gapM)),
      ],
      SizedBox(height: d.fs(AppDimens.gapS)),
      if (_solved)
        const GentleHint(message: GentleWords.correct)
      else if (_picked != null)
        const GentleHint(message: GentleWords.retry),
      SizedBox(height: d.fs(AppDimens.gapM)),
      if (_solved)
        _BigAction(d: d, label: _idx >= _queue.length - 1 ? '完成练习' : '下一个', icon: Icons.arrow_forward_outlined, onTap: _next)
      else
        _BigAction(d: d, label: '再听一遍', icon: Icons.volume_up_outlined, onTap: _play),
    ];
  }

  _OptState _optState(String opt, String target) {
    if (!_solved && _picked == null) return _OptState.normal;
    if (opt == target) return _OptState.correct;
    if (_picked == opt) return _OptState.wrong;
    return _OptState.dim;
  }
}

/// 描红全屏（不滚动）：示范字 + 听一听 + 左「笔顺示例」右田字格 + 下一个。
///
/// 关键：整个区域不是 [ListView]/[SingleChildScrollView]，竖笔与断笔手势全部归手写板，
/// 不会再被外层滚动抢走。手写板尺寸用 [LayoutBuilder] 取宽高较小值，确保一屏内不溢出。
/// 左侧笔顺栏虽自带滚动，但它是手写板的兄弟节点、不在手写板的命中路径上，不抢手势。
class _TraceBody extends StatelessWidget {
  final AppDimens d;
  final String target;
  final VoidCallback play;
  final VoidCallback next;
  final int idx;
  final int total;

  const _TraceBody({
    required this.d,
    required this.target,
    required this.play,
    required this.next,
    required this.idx,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> strokeNames = kCharLibrary[target]?.strokeNames ?? const <String>[];
    return LayoutBuilder(
      builder: (BuildContext ctx, BoxConstraints c) {
        // 左侧笔顺栏约占 28% 宽（夹在 92~180dp 之间，保证窄屏也放得下田字格）
        final double demoW = (c.maxWidth * 0.28).clamp(d.fs(92), d.fs(180));
        final double gap = d.fs(AppDimens.gapM);
        final double widthAvail = c.maxWidth - d.pagePad * 2 - demoW - gap;
        // 竖向固定开销必须**逐项累加**，不能拍一个魔法数字：
        // 原先只预留 d.fs(240)，而超大字号下光顶部示范字就有 140+，导致内容溢出、
        // 「下一个」等按钮被挤出屏幕。逐项累加后，任何字号档位都能保证一屏放得下。
        final double reserve = d.fs(AppDimens.fsHuge) // 顶部示范字
            +
            d.fs(AppDimens.fsBody) // 「第 x / y 个」
            +
            d.buttonH * 2 // 听一听 + 下一个
            +
            d.fs(AppDimens.gapM) * 3 + d.fs(AppDimens.gapS) // 各处间距
            +
            d.pagePad * 2 // 页面内边距
            +
            70; // 手写板自带的「重写 / 看看写得怎样」按钮行
        final double heightAvail = c.maxHeight - reserve;
        // 取宽高可用值的较小者；下限 120 是「还能写得下一个字」的底线（防极小屏溢出）
        final double padSize =
            (widthAvail < heightAvail ? widthAvail : heightAvail).clamp(120.0, d.fs(340));
        return Padding(
          padding: EdgeInsets.all(d.pagePad),
          child: Column(
            children: <Widget>[
              Text('第 ${idx + 1} / $total 个', style: AppTheme.sans(size: d.fs(18), color: AppTheme.ink2)),
              SizedBox(height: d.fs(AppDimens.gapM)),
              // 顶部示范字刻意不用「超大」档：田字格内部已有浅色范字（字号 = 格宽 × 0.65），
              // 顶部再放一个 140dp 的巨字会把田字格挤没，超大字号下还会把按钮挤出屏幕。
              Center(child: Text(target, style: AppTheme.serif(size: d.fs(AppDimens.fsHuge)))),
              SizedBox(height: d.fs(AppDimens.gapS)),
              _BigAction(d: d, label: '听一听', icon: Icons.volume_up_outlined, onTap: play),
              SizedBox(height: d.fs(AppDimens.gapM)),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    StrokeOrderDemo(
                      // 换字同样要重建：否则上一字的高亮进度/播放中的 Timer 会串到下一个字
                      key: ValueKey<String>('demo-$target-$idx'),
                      char: target,
                      strokeNames: strokeNames,
                      width: demoW,
                    ),
                    SizedBox(width: gap),
                    Expanded(
                      child: Center(
                        child: HandwritingPad(
                          // 🔴 修 bug：点「下一个」时必须换 Key，否则 Flutter 会复用同一个
                          //    _HandwritingPadState，上一个字的笔迹留在画板上（用户得手动点「重写」）。
                          key: ValueKey<String>('trace-$target-$idx'),
                          size: padSize,
                          guideChar: target,
                          strokeNames: strokeNames,
                          onSubmit: (String msg) {
                            ScaffoldMessenger.of(ctx).showSnackBar(
                              SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: d.fs(AppDimens.gapM)),
              _BigAction(
                d: d,
                label: idx >= total - 1 ? '完成练习' : '下一个',
                icon: Icons.arrow_forward_outlined,
                onTap: next,
              ),
            ],
          ),
        );
      },
    );
  }
}

enum _OptState { normal, correct, wrong, dim }

/// 超大选项按钮（汉字）。
class _OptionBtn extends StatelessWidget {
  final AppDimens d;
  final String char;
  final _OptState state;
  final VoidCallback onTap;

  const _OptionBtn({required this.d, required this.char, required this.state, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final Color border;
    final Color bg;
    const Color fg = AppTheme.ink;
    switch (state) {
      case _OptState.correct:
        border = AppTheme.dai;
        bg = AppTheme.daiSoft;
        break;
      case _OptState.wrong:
        border = AppTheme.zhe;
        bg = AppTheme.zheSoft;
        break;
      case _OptState.dim:
        border = AppTheme.line;
        bg = AppTheme.paper;
        break;
      case _OptState.normal:
        border = AppTheme.dai;
        bg = AppTheme.paper;
        break;
    }
    return Material(
      color: bg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.radius), side: BorderSide(color: border, width: 2)),
      child: InkWell(
        onTap: state == _OptState.dim ? null : onTap,
        borderRadius: BorderRadius.circular(AppDimens.radius),
        child: Container(
          constraints: BoxConstraints(minHeight: d.touch * 1.4),
          alignment: Alignment.center,
          child: Text(char, style: AppTheme.serif(size: d.fs(AppDimens.fsOptionChar), color: fg, w: FontWeight.w500)),
        ),
      ),
    );
  }
}

/// 通用大按钮（黛青填充）。
class _BigAction extends StatelessWidget {
  final AppDimens d;
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _BigAction({required this.d, required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.dai,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.radius)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.radius),
        child: Container(
          constraints: BoxConstraints(minHeight: d.buttonH),
          padding: EdgeInsets.symmetric(horizontal: d.fs(AppDimens.gapM)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, size: d.fs(30), color: Colors.white),
              SizedBox(width: d.fs(AppDimens.gapS)),
              Text(label, style: AppTheme.serif(size: d.fs(26), color: Colors.white, w: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

/// 返回首页按钮。
class _BackBtn extends StatelessWidget {
  final AppDimens d;
  const _BackBtn({required this.d});

  @override
  Widget build(BuildContext context) {
    return _BigAction(
      d: d,
      label: '返回',
      icon: Icons.home_outlined,
      onTap: () => Navigator.pushReplacementNamed(context, AppRouter.home),
    );
  }
}

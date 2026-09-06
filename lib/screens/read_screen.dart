import 'package:flutter/material.dart';

import '../app_router.dart';
import '../data/char_library.dart';
import '../data/sentences.dart';
import '../data/story_ruby.dart';
import '../data/xiehouyu.dart';
import '../services/tts_service.dart';
import '../state/app_state.dart';
import '../theme/app_dimens.dart';
import '../theme/app_theme.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/big_button.dart';
import '../widgets/gentle_hint.dart';
import '../widgets/marked_chars_panel.dart';
import '../widgets/ruby_text.dart';

/// 阅读模块：两个分页。
/// - 「短句」：只显示 **100% 由已学汉字组成** 的短句（铁律：绝不出现生字）。
/// - 「歇后语」：平民生活化的歇后语，文字标拼音、点击发音、解释含义、支持标记生字。
///   默认完整显示「上半句——下半句」+ 意思讲解，母亲一眼看全、看得懂；
///   另提供「考考我」按钮先藏答案自检（仿故事屋的揭晓玩法，但不再强制藏）。
class ReadScreen extends StatelessWidget {
  const ReadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppDimens d = AppDimens.of(context);
    final AppState app = AppState.instance;
    return Scaffold(
      appBar: AppBar(title: Text('读一读', style: AppTheme.serif(size: d.fs(26)))),
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: <Widget>[
              TabBar(
                labelStyle: AppTheme.serif(size: d.fs(18), w: FontWeight.w600),
                unselectedLabelStyle: AppTheme.serif(size: d.fs(18)),
                labelColor: AppTheme.dai,
                unselectedLabelColor: AppTheme.ink2,
                indicatorColor: AppTheme.dai,
                tabs: const <Widget>[
                  Tab(text: '短句'),
                  Tab(text: '歇后语'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: <Widget>[
                    _ShortSentenceTab(d: d, app: app),
                    _XiehouyuTab(d: d),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNav(AppBottomNav.indexOfRoute(AppRouter.read)),
    );
  }
}

/// 短句：随学习进度出现，0 进度时给温和引导。
class _ShortSentenceTab extends StatelessWidget {
  final AppDimens d;
  final AppState app;

  const _ShortSentenceTab({required this.d, required this.app});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: app,
      builder: (BuildContext context, _) {
        final List<Sentence> list = readableSentences(app.progress.learnedChars);
        if (list.isEmpty) {
          return Padding(
            padding: EdgeInsets.all(d.pagePad),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Center(child: GentleHint(message: GentleWords.noSentence)),
                SizedBox(height: d.fs(AppDimens.gapL)),
                BigButton(label: '去学几个字', icon: Icons.school_outlined, onTap: () => Navigator.pushReplacementNamed(context, AppRouter.home)),
              ],
            ),
          );
        }
        return ListView(
          padding: EdgeInsets.all(d.pagePad),
          children: <Widget>[
            for (final Sentence s in list) ...<Widget>[
              _SentenceCard(s: s, d: d, showPinyin: app.settings.showPinyin),
              SizedBox(height: d.fs(AppDimens.gapM)),
            ],
          ],
        );
      },
    );
  }
}

/// 歇后语：分类筛选 + 卡片列表 + 顶部常驻「我圈的字」汇总。
///
/// v1.16 关键修复：把 [MarkedCharsPanel] 从原来的 ListView 末尾提到**顶部常驻**——
/// 旧版用户必须滚到屏幕最底才能看见自己圈了哪些字，对老年用户极不友好。
/// 现在放在分类筛选正下方、卡片列表之上，进页面第一眼就看到；同时面板里的统计
/// 仍随 [AppState.markedChars] 实时刷新（圈了字立刻多一个）。
class _XiehouyuTab extends StatefulWidget {
  final AppDimens d;

  const _XiehouyuTab({required this.d});

  @override
  State<_XiehouyuTab> createState() => _XiehouyuTabState();
}

class _XiehouyuTabState extends State<_XiehouyuTab> {
  String? _cat; // null = 全部

  static const List<String> _cats = <String>['生活', '做事', '为人', '天气农事'];

  @override
  Widget build(BuildContext context) {
    final AppDimens d = widget.d;
    final List<Xiehouyu> list = _cat == null
        ? kXiehouyu
        : kXiehouyu.where((Xiehouyu x) => x.category == _cat).toList();
    return Column(
      children: <Widget>[
        // 分类筛选（横向滚动，不增加太多复杂度）
        Container(
          padding: EdgeInsets.fromLTRB(d.pagePad, d.fs(AppDimens.gapS), d.pagePad, 0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[
                _CatChip(label: '全部', active: _cat == null, onTap: () => setState(() => _cat = null)),
                for (final String c in _cats)
                  _CatChip(label: c, active: _cat == c, onTap: () => setState(() => _cat = c)),
              ],
            ),
          ),
        ),
        // v1.16: 「我圈的字」面板提到顶部常驻——一眼可见，不用滚到底
        MarkedCharsPanel(
          d: d,
          sourceRubies: kXiehouyu
              .expand((Xiehouyu x) => <String>[x.front, x.back, x.meaning])
              .toList(),
          title: '歇后语里我圈的字',
          emptyHint: '读歇后语时遇到不认识的字，点「圈生字」圈起来，这里会帮你记着。',
        ),
        // 卡片列表（占满剩余空间，自身滚动）
        Expanded(
          child: ListView(
            padding: EdgeInsets.all(d.pagePad),
            children: <Widget>[
              for (final Xiehouyu x in list) ...<Widget>[
                _XiehouyuCard(x: x, d: d),
                SizedBox(height: d.fs(AppDimens.gapM)),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// 单条歇后语卡片：分类标签 + 完整歇后语（上半句——下半句）+ 意思讲解 + 朗读 + 圈生字；
/// 默认就把整句和「意思」都亮出来（母亲看得全、看得懂），另给「考考我」按钮可先藏答案自检。
class _XiehouyuCard extends StatefulWidget {
  final Xiehouyu x;
  final AppDimens d;

  const _XiehouyuCard({required this.x, required this.d});

  @override
  State<_XiehouyuCard> createState() => _XiehouyuCardState();
}

class _XiehouyuCardState extends State<_XiehouyuCard> {
  /// 考考我模式：true=先藏起下半句与意思，让母亲自己想；false=完整显示。
  /// 默认 false —— 进来就看到「竹篮打水——一场空」+ 意思讲解，不藏不掖。
  bool _quizMode = false;
  bool _markMode = false;

  @override
  Widget build(BuildContext context) {
    final AppDimens d = widget.d;
    final Xiehouyu x = widget.x;
    return Card(
      child: Padding(
        padding: EdgeInsets.all(d.fs(AppDimens.gapM)),
        // 订阅全局「我圈的字」：在别处取消圈选后，本卡片的蓝色高亮也会同步消失。
        child: ListenableBuilder(
          listenable: AppState.instance,
          builder: (BuildContext context, _) {
            // 本卡片涉及的全部真实汉字
            final Set<String> present = <String>{};
            for (final String ruby in <String>[x.front, x.back, x.meaning]) {
              for (final RubyToken t in parseRuby(ruby)) {
                if (!t.isPunctuation) present.add(t.char);
              }
            }
            final Set<String> marked =
                Set<String>.from(AppState.instance.markedChars.where(present.contains));
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // 分类标签
                Container(
                  padding: EdgeInsets.symmetric(horizontal: d.fs(12), vertical: d.fs(4)),
                  decoration: BoxDecoration(
                    color: AppTheme.zheSoft,
                    borderRadius: BorderRadius.circular(AppDimens.radiusSm),
                  ),
                  child: Text(x.category,
                      style: AppTheme.serif(size: d.fs(16), color: AppTheme.zhe, w: FontWeight.w700)),
                ),
                SizedBox(height: d.fs(AppDimens.gapS)),
                // 圈生字模式提示条
                if (_markMode)
                  Container(
                    margin: EdgeInsets.only(bottom: d.fs(AppDimens.gapS)),
                    padding: EdgeInsets.symmetric(
                      horizontal: d.fs(AppDimens.gapM),
                      vertical: d.fs(AppDimens.gapS),
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.dai,
                      borderRadius: BorderRadius.circular(AppDimens.radius),
                    ),
                    child: Text('点不认识的字，就能圈出来',
                        style: AppTheme.serif(size: d.fs(18), color: Colors.white, w: FontWeight.w700)),
                  ),
                // 完整歇后语：上半句 + 破折号 + 下半句。默认完整显示，母亲一眼看全；
                // 「考考我」模式下先只显示上半句，点「揭晓」再补全。
                RubyText(
                  _quizMode ? x.front : '${x.front}——${x.back}',
                  fontSize: 32,
                  runSpacing: 12,
                  markMode: _markMode,
                  marked: marked,
                  onCharTap: _markMode ? (String c) => toggleMarkWithFeedback(context, c) : null,
                  speakOnTap: !_markMode,
                ),
                SizedBox(height: d.fs(AppDimens.gapS)),
                // 意思讲解：默认显示；考考我模式下先藏起来，揭晓后显示。
                if (!_quizMode)
                  Container(
                    padding: EdgeInsets.all(d.fs(AppDimens.gapS)),
                    decoration: BoxDecoration(
                      color: AppTheme.paper2.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(AppDimens.radiusSm),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('意思：',
                            style: AppTheme.serif(size: d.fs(18), color: AppTheme.ink2, w: FontWeight.w700)),
                        SizedBox(height: d.fs(4)),
                        RubyText(
                          x.meaning,
                          fontSize: 26,
                          runSpacing: 10,
                          markMode: _markMode,
                          marked: marked,
                          onCharTap: _markMode ? (String c) => toggleMarkWithFeedback(context, c) : null,
                          speakOnTap: !_markMode,
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: d.fs(AppDimens.gapM)),
                // 操作行：整条朗读 + 考考我/揭晓 + 圈生字
                Row(
                  children: <Widget>[
                    _PlayBtn(
                      d: d,
                      label: '整条朗读',
                      onTap: () => TtsService.instance.speak(
                        '${rubyToPlain(x.front)}，${rubyToPlain(x.back)}。${rubyToPlain(x.meaning)}',
                      ),
                    ),
                    const Spacer(),
                    if (_quizMode) ...<Widget>[
                      _ThinkButton(
                        d: d,
                        label: '揭晓',
                        onTap: () => setState(() => _quizMode = false),
                      ),
                      SizedBox(width: d.fs(AppDimens.gapS)),
                    ] else ...<Widget>[
                      _ThinkButton(
                        d: d,
                        label: '考考我',
                        onTap: () => setState(() => _quizMode = true),
                      ),
                      SizedBox(width: d.fs(AppDimens.gapS)),
                    ],
                    _XMarkButton(
                      d: d,
                      active: _markMode,
                      onTap: () => setState(() => _markMode = !_markMode),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// 短句卡片（已学字，自带字库拼音，0 生字）。
class _SentenceCard extends StatelessWidget {
  final Sentence s;
  final AppDimens d;
  final bool showPinyin;

  const _SentenceCard({required this.s, required this.d, required this.showPinyin});

  String _toRuby(String text) {
    final StringBuffer sb = StringBuffer();
    for (final int r in text.runes) {
      final String ch = String.fromCharCode(r);
      if (showPinyin) {
        final CharCard? card = kCharLibrary[ch];
        if (card != null && card.pinyin.isNotEmpty) {
          sb.write('$ch(${card.pinyin})');
          continue;
        }
      }
      sb.write(ch);
    }
    return sb.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(d.fs(AppDimens.gapM)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RubyText(_toRuby(s.text), fontSize: 40, speakOnTap: true),
            SizedBox(height: d.fs(AppDimens.gapM)),
            Align(
              alignment: Alignment.centerRight,
              child: _PlayBtn(d: d, onTap: () => TtsService.instance.speakSentence(s.text)),
            ),
          ],
        ),
      ),
    );
  }
}

/// 整句/整条朗读按钮（黛青填充），label 可定制。
class _PlayBtn extends StatelessWidget {
  final AppDimens d;
  final VoidCallback onTap;
  final String label;

  const _PlayBtn({required this.d, required this.onTap, this.label = '整篇朗读'});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.dai,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.radius)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.radius),
        child: Container(
          constraints: BoxConstraints(minHeight: d.touch),
          padding: EdgeInsets.symmetric(horizontal: d.fs(AppDimens.gapM)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.volume_up_outlined, size: d.fs(26), color: Colors.white),
              SizedBox(width: d.fs(AppDimens.gapS)),
              Text(label, style: AppTheme.serif(size: d.fs(20), color: Colors.white, w: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }
}

/// 「想一想 / 收起」按钮（赭石，呼应揭晓感）。
class _ThinkButton extends StatelessWidget {
  final AppDimens d;
  final String label;
  final VoidCallback onTap;

  const _ThinkButton({required this.d, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimens.radius),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: d.fs(AppDimens.gapM), vertical: d.fs(AppDimens.gapS)),
        decoration: BoxDecoration(
          color: AppTheme.zheSoft,
          borderRadius: BorderRadius.circular(AppDimens.radius),
          border: Border.all(color: AppTheme.zhe, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.lightbulb_outline, size: d.fs(22), color: AppTheme.zhe),
            SizedBox(width: d.fs(AppDimens.gapXs)),
            Text(label, style: AppTheme.serif(size: d.fs(17), color: AppTheme.zhe, w: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

/// 「圈生字」开关：进入/退出圈字模式（≥ 热区，黛青描边，与故事屋同款）。
class _XMarkButton extends StatelessWidget {
  final AppDimens d;
  final bool active;
  final VoidCallback onTap;

  const _XMarkButton({required this.d, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final Color bg = active ? AppTheme.dai : AppTheme.daiSoft;
    final Color fg = active ? Colors.white : AppTheme.dai;
    final IconData icon = active ? Icons.check_circle_outline : Icons.add_circle_outline;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimens.radius),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: d.fs(AppDimens.gapM), vertical: d.fs(AppDimens.gapS)),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppDimens.radius),
          border: Border.all(color: AppTheme.dai, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: d.fs(24), color: fg),
            SizedBox(width: d.fs(AppDimens.gapXs)),
            Text(active ? '完成' : '圈生字',
                style: AppTheme.serif(size: d.fs(17), color: fg, w: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

/// 分类筛选 Chip。
class _CatChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _CatChip({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final AppDimens d = AppDimens.of(context);
    return Padding(
      padding: EdgeInsets.only(right: d.fs(AppDimens.gapS)),
      child: ChoiceChip(
        label: Text(label,
            style: AppTheme.serif(
                size: d.fs(16), color: active ? Colors.white : AppTheme.ink2, w: FontWeight.w600)),
        selected: active,
        onSelected: (_) => onTap(),
        selectedColor: AppTheme.dai,
        backgroundColor: AppTheme.paper2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radius),
          side: const BorderSide(color: AppTheme.line, width: 1),
        ),
        padding: EdgeInsets.symmetric(horizontal: d.fs(AppDimens.gapS), vertical: d.fs(2)),
      ),
    );
  }
}

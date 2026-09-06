import 'package:flutter/material.dart';

import '../data/story_assets.dart';
import '../data/story_model.dart';
import '../data/story_ruby.dart';
import '../data/char_library.dart';
import '../state/app_state.dart';
import '../app_router.dart';
import '../services/tts_service.dart';
import '../widgets/char_pic.dart';
import '../theme/app_dimens.dart';
import '../theme/app_theme.dart';
import '../widgets/landscape_scope.dart';
import '../widgets/marked_chars_panel.dart';
import '../widgets/ruby_text.dart';
import '../widgets/story_image.dart';

/// 故事阅读器（横屏 · 逐章翻阅）。
///
/// ## 横屏布局
/// 进入故事屋即锁定横屏（见 [LandscapeScope]）。正文用 [AppDimens.maxReadWidth] 收住版心，
/// 每个段落做成「左侧插图 + 右侧注音正文」的左右结构：
/// - 文字走 [Expanded] + [Wrap]，宽度永远有界 → **不可能溢出屏幕**；
/// - 行距 [runSpacing]、字距 [charSpacing] 单独放宽，注音不会挤成一行。
///
/// ## 退出
/// - AppBar 左侧「‹ 返回」大按钮（图标 + 文字，热区 ≥ 64dp），随时退回书架；
/// - 系统返回键 / 手势返回同样生效（[PopScope] 显式声明可 pop）；
/// - 目录面板底部还有「返回书架」。
///
/// ## 内容切换
/// - 底部「上一章 / 下一章」大按钮逐章翻阅；
/// - AppBar「目录」打开章节列表，点任意一章直接跳转。
///
/// 与短句实战的区别：这里是注音泛读，允许出现未学过的字，拼音是读者的拐杖。
class StoryReaderScreen extends StatefulWidget {
  final StoryBook book;

  const StoryReaderScreen({super.key, required this.book});

  @override
  State<StoryReaderScreen> createState() => _StoryReaderScreenState();
}

class _StoryReaderScreenState extends State<StoryReaderScreen> {
  int _index = 0;
  bool _reading = false;

  StoryBook get _book => widget.book;
  int get _count => _book.chapters.length;
  StoryChapter get _chapter => _book.chapters[_index];

  @override
  void initState() {
    super.initState();
    // 幂等：书架已经锁过横屏，这里再调一次只是兜底（例如以后从别处直接打开阅读器）。
    // ⚠️ 这里**不要**在 dispose 里恢复竖屏，否则返回书架时书架会变竖屏，见 LandscapeScope 注释。
    LandscapeScope.enter();
  }

  /// 退出 / 销毁时务必停掉朗读，否则会「人走了还在念」。
  /// 系统返回键、底部导航切走都会触发 dispose，统一在这里收口。
  @override
  void dispose() {
    TtsService.instance.stop();
    super.dispose();
  }

  /// 翻到指定章节（越界自动夹紧），翻章先停朗读，避免串音。
  void _goto(int i) {
    final int target = i.clamp(0, _count - 1);
    if (target == _index) return;
    TtsService.instance.stop();
    setState(() => _index = target);
  }

  /// 朗读整章：点一次开始，朗读中再点一次即停止（切换）。章节标题 + 各段正文（只传真实汉字）。
  Future<void> _readChapter() async {
    if (_reading) {
      TtsService.instance.stop();
      setState(() => _reading = false);
      return;
    }
    setState(() => _reading = true);
    final StoryChapter ch = _chapter;
    final String text = <String>[
      rubyToPlain(ch.title),
      ...ch.paragraphs.map((StoryParagraph p) => rubyToPlain(p.ruby)),
    ].join('。');
    await TtsService.instance.speak(text);
    if (mounted) setState(() => _reading = false);
  }

  /// 退出本章，回到书架（上一级页面）
  void _exit() {
    _reading = false;
    TtsService.instance.stop();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final AppDimens d = AppDimens.of(context);
    final StoryChapter ch = _chapter;

    return PopScope(
      // 系统返回键 / 手势返回：直接退出本章回到书架
      canPop: true,
      child: Scaffold(
        backgroundColor: AppTheme.paper,
        appBar: AppBar(
          toolbarHeight: d.touch,
          leadingWidth: d.fs(130),
          leading: _BackButton(d: d, onTap: _exit),
          title: Text(
            rubyToPlain(_book.title),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTheme.serif(size: d.fs(26), w: FontWeight.w700),
          ),
          actions: <Widget>[
            _AppBarAction(
              d: d,
              icon: Icons.format_list_bulleted,
              label: '目录',
              onTap: () => _openToc(context),
            ),
            _AppBarAction(
              d: d,
              icon: Icons.volume_up_outlined,
              label: _reading ? '停止朗读' : '朗读本章',
              onTap: _readChapter,
            ),
            SizedBox(width: d.fs(AppDimens.gapS)),
          ],
        ),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: AppDimens.maxReadWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _ChapterHeader(d: d, chapter: ch, index: _index, total: _count),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.fromLTRB(
                        d.pagePad,
                        d.fs(AppDimens.gapM),
                        d.pagePad,
                        d.fs(AppDimens.gapL),
                      ),
                      itemCount: ch.paragraphs.length + 2,
                      itemBuilder: (BuildContext context, int i) {
                        if (i < ch.paragraphs.length) {
                          return _ParagraphRow(p: ch.paragraphs[i], d: d);
                        }
                        if (i == ch.paragraphs.length) {
                          final List<String> words = _chapterNewWords(ch);
                          if (words.isEmpty) return const SizedBox.shrink();
                          return _NewWordsCard(d: d, words: words);
                        }
                        // 章末汇总：本章所有段落正文中被圈中的字（与「本章生字」并存）
                        final List<String> source = <String>[
                          ch.title,
                          ...ch.paragraphs.map((StoryParagraph p) => p.ruby),
                        ];
                        return MarkedCharsPanel(
                          d: d,
                          sourceRubies: source,
                          title: '本章我圈的字',
                          emptyHint: '这一章还没圈字。读的时候遇到不认识的，点「圈生字」圈起来。',
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: _ChapterPager(
          d: d,
          index: _index,
          total: _count,
          chapterTitle: rubyToPlain(ch.title),
          onPrev: () => _goto(_index - 1),
          onNext: () => _goto(_index + 1),
        ),
      ),
    );
  }

  /// 目录：列出全部章节，点选即跳转；底部提供「返回书架」。
  void _openToc(BuildContext context) {
    final AppDimens d = AppDimens.of(context);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppTheme.paper,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimens.radius),
        ),
      ),
      builder: (BuildContext sheetCtx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(
                  d.fs(AppDimens.gapM),
                  d.fs(AppDimens.gapM),
                  d.fs(AppDimens.gapS),
                  d.fs(AppDimens.gapS),
                ),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.format_list_bulleted, color: AppTheme.dai, size: d.fs(28)),
                    SizedBox(width: d.fs(AppDimens.gapS)),
                    Expanded(
                      child: Text(
                        '目录 · ${rubyToPlain(_book.title)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTheme.serif(size: d.fs(24), w: FontWeight.w700),
                      ),
                    ),
                    IconButton(
                      iconSize: d.fs(32),
                      tooltip: '关闭',
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(sheetCtx),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: AppTheme.line),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: _count,
                  separatorBuilder: (_, __) => const Divider(height: 1, color: AppTheme.line),
                  itemBuilder: (BuildContext context, int i) {
                    final StoryChapter it = _book.chapters[i];
                    final bool cur = i == _index;
                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: d.fs(AppDimens.gapM),
                        vertical: d.fs(AppDimens.gapXs),
                      ),
                      leading: Container(
                        width: d.fs(48),
                        height: d.fs(48),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: cur ? AppTheme.dai : AppTheme.paper2,
                          borderRadius: BorderRadius.circular(d.fs(AppDimens.radiusSm)),
                          border: Border.all(
                            color: cur ? AppTheme.dai : AppTheme.line,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          '${i + 1}',
                          style: AppTheme.sans(
                            size: d.fs(20),
                            color: cur ? Colors.white : AppTheme.ink2,
                            w: FontWeight.w700,
                          ),
                        ),
                      ),
                      title: Text(
                        rubyToPlain(it.title),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTheme.serif(
                          size: d.fs(23),
                          color: cur ? AppTheme.dai : AppTheme.ink,
                          w: cur ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        '共 ${it.paragraphs.length} 段',
                        style: AppTheme.sans(size: d.fs(14), color: AppTheme.ink2),
                      ),
                      trailing: cur
                          ? Icon(Icons.play_arrow_rounded, color: AppTheme.dai, size: d.fs(30))
                          : null,
                      onTap: () {
                        Navigator.pop(sheetCtx);
                        _goto(i);
                      },
                    );
                  },
                ),
              ),
              const Divider(height: 1, color: AppTheme.line),
              Padding(
                padding: EdgeInsets.all(d.fs(AppDimens.gapM)),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size.fromHeight(d.buttonH * 0.8),
                      side: const BorderSide(color: AppTheme.line, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimens.radius),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(sheetCtx);
                      _exit();
                    },
                    icon: Icon(Icons.arrow_back_ios_new, size: d.fs(22), color: AppTheme.ink2),
                    label: Text(
                      '返回书架',
                      style: AppTheme.serif(size: d.fs(20), color: AppTheme.ink2),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// 本章「默认生字」：字库内、尚未学会、按出现频率降序取前 8。
List<String> _chapterNewWords(StoryChapter ch) {
  final Set<String> learned = AppState.instance.progress.learnedChars;
  final Map<String, int> freq = <String, int>{};
  void count(String ruby) {
    for (final RubyToken t in parseRuby(ruby)) {
      if (t.isPunctuation) continue;
      if (!kCharLibrary.containsKey(t.char)) continue;
      if (learned.contains(t.char)) continue;
      freq[t.char] = (freq[t.char] ?? 0) + 1;
    }
  }

  count(ch.title);
  for (final StoryParagraph p in ch.paragraphs) {
    count(p.ruby);
  }
  final List<String> list = freq.keys.toList();
  list.sort((String a, String b) => freq[b]! - freq[a]!);
  return list.take(8).toList();
}

/// AppBar 左侧：图标 + 文字的醒目返回（中老年一眼能认出「退出」）。
class _BackButton extends StatelessWidget {
  final AppDimens d;
  final VoidCallback onTap;

  const _BackButton({required this.d, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: d.fs(AppDimens.gapS)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.radius),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: d.fs(AppDimens.gapS)),
          constraints: BoxConstraints(minHeight: d.touch),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.arrow_back_ios_new, size: d.fs(26), color: AppTheme.dai),
              SizedBox(width: d.fs(2)),
              Text(
                '返回',
                style: AppTheme.serif(size: d.fs(21), color: AppTheme.dai, w: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// AppBar 右侧动作：图标在上、文字在下，比纯图标更好认。
class _AppBarAction extends StatelessWidget {
  final AppDimens d;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _AppBarAction({
    required this.d,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimens.radius),
      child: Container(
        constraints: BoxConstraints(minHeight: d.touch, minWidth: d.fs(96)),
        padding: EdgeInsets.symmetric(horizontal: d.fs(AppDimens.gapS)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: d.fs(26), color: AppTheme.ink2),
            SizedBox(height: d.fs(2)),
            Text(
              label,
              style: AppTheme.serif(size: d.fs(14), color: AppTheme.ink2, w: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

/// 章节标题区：序号徽标 + 注音标题 + 分隔线。
class _ChapterHeader extends StatelessWidget {
  final AppDimens d;
  final StoryChapter chapter;
  final int index;
  final int total;

  const _ChapterHeader({
    required this.d,
    required this.chapter,
    required this.index,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        d.pagePad,
        d.fs(AppDimens.gapM),
        d.pagePad,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: d.fs(14),
                  vertical: d.fs(6),
                ),
                decoration: BoxDecoration(
                  color: AppTheme.dai,
                  borderRadius: BorderRadius.circular(d.fs(AppDimens.radiusSm)),
                ),
                child: Text(
                  '第 ${index + 1} / $total 章',
                  style: AppTheme.sans(
                    size: d.fs(16),
                    color: Colors.white,
                    w: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: d.fs(AppDimens.gapM)),
              Expanded(
                child: RubyText(
                  chapter.title,
                  fontSize: 32,
                  speakOnTap: false,
                  runSpacing: 12,
                ),
              ),
            ],
          ),
          SizedBox(height: d.fs(AppDimens.gapS)),
          const Divider(height: 1, thickness: 1.5, color: AppTheme.line),
        ],
      ),
    );
  }
}

/// 单个段落：左侧插图 + 右侧注音正文 + 「听这一段」+「圈生字」。
///
/// 文字侧一律 [Expanded] + [RubyText]（内部 [Wrap]），宽度有界，横屏再宽也不会溢出。
/// 进入「圈生字」模式后，正文背景变蓝、顶部出现提示条，点字即朗读并切换圈注（本地 [_marked]
/// 驱动视觉，[AppState.toggleMark] 负责持久化到「我圈的字」）。
class _ParagraphRow extends StatefulWidget {
  final StoryParagraph p;
  final AppDimens d;

  const _ParagraphRow({required this.p, required this.d});

  @override
  State<_ParagraphRow> createState() => _ParagraphRowState();
}

class _ParagraphRowState extends State<_ParagraphRow> {
  bool _markMode = false;

  @override
  Widget build(BuildContext context) {
    final AppDimens d = widget.d;
    final StoryParagraph p = widget.p;
    // 🔴 只保留「真打包进 APK」的插图：故事数据里写了图、但包里没图，会渲染成空占位框。
    //    过滤后，没图的段落就是纯文字、不再留空图位（见 StoryAssets）。
    final List<String> imgs = p.images.where((String i) => StoryAssets.contains(i)).toList();
    // 订阅全局「我圈的字」：在章末汇总面板里取消圈选，本段蓝色高亮也会同步消失（单一数据源）。
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (BuildContext context, _) {
        final Set<String> para = <String>{};
        for (final RubyToken t in parseRuby(p.ruby)) {
          if (!t.isPunctuation) {
            para.add(t.char);
          }
        }
        final Set<String> marked =
            Set<String>.from(AppState.instance.markedChars.where(para.contains));
        return Container(
          margin: EdgeInsets.only(bottom: d.fs(AppDimens.gapL)),
          padding: EdgeInsets.all(d.fs(AppDimens.gapM)),
          decoration: BoxDecoration(
            color: _markMode
                ? Colors.blue.withValues(alpha: 0.06)
                : AppTheme.paper2.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(AppDimens.radius),
            border: Border.all(color: AppTheme.line, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
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
                  child: Text(
                    '点不认识的字，就能圈出来',
                    style: AppTheme.serif(size: d.fs(18), color: Colors.white, w: FontWeight.w700),
                  ),
                ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (imgs.isNotEmpty) ...<Widget>[
                    Expanded(
                      flex: 3,
                      child: _ParagraphImages(imgs: imgs, d: d),
                    ),
                    SizedBox(width: d.fs(AppDimens.gapM)),
                  ],
                  Expanded(
                    flex: 7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        RubyText(
                          p.ruby,
                          fontSize: 30,
                          runSpacing: 16,
                          charSpacing: 4,
                          markMode: _markMode,
                          marked: marked,
                          onCharTap: _markMode
                              ? (String c) => toggleMarkWithFeedback(context, c)
                              : null,
                          speakOnTap: !_markMode,
                        ),
                        SizedBox(height: d.fs(AppDimens.gapS)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            _ListenButton(d: d, text: rubyToPlain(p.ruby)),
                            SizedBox(width: d.fs(AppDimens.gapS)),
                            _MarkButton(
                              d: d,
                              active: _markMode,
                              onTap: () => setState(() => _markMode = !_markMode),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

/// 段落插图：1 张独占面板；2~3 张横向等分。
class _ParagraphImages extends StatelessWidget {
  final List<String> imgs;
  final AppDimens d;

  const _ParagraphImages({required this.imgs, required this.d});

  @override
  Widget build(BuildContext context) {
    if (imgs.length == 1) {
      return StoryImage(imgs.first, height: d.fs(160), caption: '插图');
    }
    return Row(
      children: <Widget>[
        for (int i = 0; i < imgs.length; i++) ...<Widget>[
          Expanded(child: StoryImage(imgs[i], height: d.fs(150))),
          if (i < imgs.length - 1) SizedBox(width: d.fs(AppDimens.gapS)),
        ],
      ],
    );
  }
}

/// 「听这一段」：只传真实汉字给 TTS。
class _ListenButton extends StatelessWidget {
  final AppDimens d;
  final String text;

  const _ListenButton({required this.d, required this.text});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => TtsService.instance.speak(text),
      borderRadius: BorderRadius.circular(AppDimens.radius),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: d.fs(AppDimens.gapM),
          vertical: d.fs(AppDimens.gapS),
        ),
        decoration: BoxDecoration(
          color: AppTheme.daiSoft,
          borderRadius: BorderRadius.circular(AppDimens.radius),
          border: Border.all(color: AppTheme.dai, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.play_circle_outline, size: d.fs(24), color: AppTheme.dai),
            SizedBox(width: d.fs(AppDimens.gapXs)),
            Text(
              '听这一段',
              style: AppTheme.serif(size: d.fs(17), color: AppTheme.dai, w: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

/// 底部翻章条：上一章 ← 进度 → 下一章。
class _ChapterPager extends StatelessWidget {
  final AppDimens d;
  final int index;
  final int total;
  final String chapterTitle;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  const _ChapterPager({
    required this.d,
    required this.index,
    required this.total,
    required this.chapterTitle,
    required this.onPrev,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasPrev = index > 0;
    final bool hasNext = index < total - 1;
    return SafeArea(
      top: false,
      child: Container(
        decoration: const BoxDecoration(
          color: AppTheme.paper2,
          border: Border(top: BorderSide(color: AppTheme.line, width: 1)),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: d.fs(AppDimens.gapM),
          vertical: d.fs(AppDimens.gapS),
        ),
        child: Row(
          children: <Widget>[
            _PageButton(
              d: d,
              icon: Icons.chevron_left,
              label: '上一章',
              enabled: hasPrev,
              onTap: onPrev,
              iconFirst: true,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    '第 ${index + 1} / $total 章',
                    style: AppTheme.sans(size: d.fs(15), color: AppTheme.ink2),
                  ),
                  SizedBox(height: d.fs(2)),
                  Text(
                    chapterTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTheme.serif(size: d.fs(21), color: AppTheme.ink, w: FontWeight.w700),
                  ),
                ],
              ),
            ),
            _PageButton(
              d: d,
              icon: hasNext ? Icons.chevron_right : Icons.check_circle_outline,
              label: hasNext ? '下一章' : '读完了',
              enabled: hasNext,
              onTap: onNext,
              primary: hasNext,
              iconFirst: false,
            ),
          ],
        ),
      ),
    );
  }
}

/// 翻章按钮：热区 ≥ 64dp，「下一章」是主操作（黛青底）。
class _PageButton extends StatelessWidget {
  final AppDimens d;
  final IconData icon;
  final String label;
  final bool enabled;
  final VoidCallback onTap;
  final bool primary;
  final bool iconFirst;

  const _PageButton({
    required this.d,
    required this.icon,
    required this.label,
    required this.enabled,
    required this.onTap,
    this.primary = false,
    this.iconFirst = true,
  });

  @override
  Widget build(BuildContext context) {
    final bool strong = primary && enabled;
    final Color fg = enabled
        ? (strong ? AppTheme.dai : AppTheme.ink2)
        : AppTheme.ink2.withValues(alpha: 0.35);
    final Widget iconWidget = Icon(icon, size: d.fs(28), color: fg);
    final Widget labelWidget = Text(
      label,
      style: AppTheme.serif(size: d.fs(19), color: fg, w: FontWeight.w700),
    );
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(AppDimens.radius),
      child: Container(
        constraints: BoxConstraints(minHeight: d.touch, minWidth: d.fs(140)),
        padding: EdgeInsets.symmetric(horizontal: d.fs(AppDimens.gapM)),
        decoration: BoxDecoration(
          color: strong ? AppTheme.daiSoft : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimens.radius),
          border: Border.all(
            color: strong ? AppTheme.dai : AppTheme.line,
            width: strong ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: iconFirst
              ? <Widget>[iconWidget, SizedBox(width: d.fs(2)), labelWidget]
              : <Widget>[labelWidget, SizedBox(width: d.fs(2)), iconWidget],
        ),
      ),
    );
  }
}

/// 本章结尾「默认生字」卡片：字库内、未学会、按频降序前 8。点字进详情单独学。
class _NewWordsCard extends StatelessWidget {
  final AppDimens d;
  final List<String> words;

  const _NewWordsCard({required this.d, required this.words});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: d.fs(AppDimens.gapL)),
      padding: EdgeInsets.all(d.fs(AppDimens.gapM)),
      decoration: BoxDecoration(
        color: AppTheme.paper2,
        borderRadius: BorderRadius.circular(AppDimens.radius),
        border: Border.all(color: AppTheme.line, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.auto_stories, size: d.fs(26), color: AppTheme.dai),
              SizedBox(width: d.fs(AppDimens.gapS)),
              Text(
                '本章生字',
                style: AppTheme.serif(size: d.fs(22), color: AppTheme.dai, w: FontWeight.w700),
              ),
              SizedBox(width: d.fs(AppDimens.gapS)),
              Expanded(
                child: Text(
                  '点一下就能单独学这个字',
                  style: AppTheme.sans(size: d.fs(14), color: AppTheme.ink2),
                ),
              ),
            ],
          ),
          SizedBox(height: d.fs(AppDimens.gapM)),
          Wrap(
            spacing: d.fs(AppDimens.gapS),
            runSpacing: d.fs(AppDimens.gapS),
            children: <Widget>[
              for (final String w in words)
                InkWell(
                  onTap: () => Navigator.pushNamed(context, AppRouter.charDetail, arguments: w),
                  borderRadius: BorderRadius.circular(AppDimens.radius),
                  child: Container(
                    constraints: BoxConstraints(minHeight: d.touch),
                    padding: EdgeInsets.symmetric(
                      horizontal: d.fs(AppDimens.gapS),
                      vertical: d.fs(AppDimens.gapXs),
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.daiSoft,
                      borderRadius: BorderRadius.circular(AppDimens.radius),
                      border: Border.all(color: AppTheme.dai, width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        CharPic(card: kCharLibrary[w]!, height: d.fs(48), width: d.fs(48)),
                        SizedBox(width: d.fs(AppDimens.gapXs)),
                        Text(
                          w,
                          style: AppTheme.serif(size: d.fs(30), w: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 「圈生字」开关：进入/退出圈字模式（≥ 热区，黛青描边，与 [_ListenButton] 同款）。
class _MarkButton extends StatelessWidget {
  final AppDimens d;
  final bool active;
  final VoidCallback onTap;

  const _MarkButton({required this.d, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final Color bg = active ? AppTheme.dai : AppTheme.daiSoft;
    final Color fg = active ? Colors.white : AppTheme.dai;
    final IconData icon = active ? Icons.check_circle_outline : Icons.add_circle_outline;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimens.radius),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: d.fs(AppDimens.gapM),
          vertical: d.fs(AppDimens.gapS),
        ),
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
            Text(
              active ? '完成' : '圈生字',
              style: AppTheme.serif(size: d.fs(17), color: fg, w: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

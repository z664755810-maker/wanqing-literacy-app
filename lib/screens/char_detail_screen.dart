import 'package:flutter/material.dart';

import '../data/char_library.dart';
import '../data/lessons.dart';
import '../app_router.dart';
import '../services/tts_service.dart';
import '../state/app_state.dart';
import '../theme/app_dimens.dart';
import '../theme/app_theme.dart';
import '../widgets/big_button.dart';
import '../widgets/char_pic.dart';
import '../widgets/gentle_hint.dart';
import '../widgets/stroke_order_demo.dart';

/// 单字详情：超大汉字 + 弱拼音 + 语音播报 + 释义 + 可折叠笔顺示例。
///
/// 数据来自 [kCharLibrary]，语音只传真实汉字给 TTS。可在此「标记为学会」推进进度；
/// 一课的字全部标记学会后会**自动跳到下一课**（见 [_onMarkLearned]），不用退出重进。
class CharDetailScreen extends StatelessWidget {
  final String char;

  const CharDetailScreen({super.key, this.char = ''});

  @override
  Widget build(BuildContext context) {
    final AppDimens d = AppDimens.of(context);
    final CharCard? card = kCharLibrary[char];
    final AppState app = AppState.instance;
    final bool learned = app.progress.isLearned(char);

    if (card == null) {
      return Scaffold(
        appBar: AppBar(title: Text('字详情', style: AppTheme.serif(size: d.fs(26)))),
        body: const SafeArea(child: Center(child: Text('字库里没有这个字'))),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(card.char, style: AppTheme.serif(size: d.fs(26)))),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(d.pagePad),
          children: <Widget>[
            Center(
              child: Text(card.char, style: AppTheme.serif(size: d.fs(AppDimens.fsHeroChar))),
            ),
            SizedBox(height: d.fs(AppDimens.gapS)),
            Center(
              child: Text(card.pinyin, style: AppTheme.sans(size: d.fs(28), color: AppTheme.zhe)),
            ),
            SizedBox(height: d.fs(AppDimens.gapM)),
            CharPic(card: card, height: d.fs(240)),
            SizedBox(height: d.fs(AppDimens.gapM)),
            _Row(d: d, label: '意思', value: card.meaning),
            SizedBox(height: d.fs(AppDimens.gapM)),
            // 旧版把 strokeNames 铺成一排 Chip（干巴巴、看不出顺序），已移除。
            // 现在收进可折叠区，点开即可「看一遍」逐笔高亮 + 朗读笔画名；
            // 真正要边看边写的场景在描红页（笔顺示例常驻描红区左侧）。
            if (card.strokeNames.isNotEmpty)
              Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  childrenPadding: EdgeInsets.only(bottom: d.fs(AppDimens.gapS)),
                  iconColor: AppTheme.dai,
                  collapsedIconColor: AppTheme.dai,
                  title: Text(
                    '笔顺（点开看一遍）',
                    style: AppTheme.serif(size: d.fs(20), w: FontWeight.w600),
                  ),
                  children: <Widget>[
                    StrokeOrderDemo(char: card.char, strokeNames: card.strokeNames),
                  ],
                ),
              ),
            SizedBox(height: d.fs(AppDimens.gapL)),
            Row(
              children: <Widget>[
                Expanded(
                  child: _Action(
                    d: d,
                    icon: Icons.volume_up_outlined,
                    label: '听读音',
                    onTap: () => TtsService.instance.speak(card.char),
                  ),
                ),
                SizedBox(width: d.fs(AppDimens.gapM)),
                Expanded(
                  child: _Action(
                    d: d,
                    icon: learned ? Icons.check_circle_outline : Icons.add_circle_outline,
                    label: learned ? '已学会' : '标记为学会',
                    primary: !learned,
                    onTap: learned ? null : () => _onMarkLearned(context, card),
                  ),
                ),
              ],
            ),
            SizedBox(height: d.fs(AppDimens.gapM)),
            BigButton.secondary(
              label: '描红写一写',
              icon: Icons.gesture_outlined,
              onTap: () => Navigator.pushNamed(context, AppRouter.trace, arguments: card.char),
            ),
          ],
        ),
      ),
    );
  }

  /// 「标记为学会」：记进度 → 解锁下一课 → **本课全部学会时自动进入下一课**。
  ///
  /// 交互（用户反馈「三个字都标记学会后要退出重进才刷新」）：
  /// 1. 本课还没学完 → 只记进度、不跳转（返回上一页时列表已经是最新的：
  ///    `refreshDue()` 会 notifyListeners，课程页通过 ListenableBuilder 立即刷新）。
  /// 2. 本课全部学会 → 先给约 1.8 秒温和成就反馈，再 pushReplacement 到下一课。
  /// 3. 已是最后一课 → 回首页并提示去复习。
  ///
  /// 🔴 「有没有下一课」必须**显式比最大课号**：`lessonOf` 越界会静默返回第一课，
  ///    若依赖它判空，学完最后一课会被莫名送回第 1 课。
  /// 🔴 每个 await 之后都要 `context.mounted` 检查（用户可能中途返回）。
  Future<void> _onMarkLearned(BuildContext context, CharCard card) async {
    final AppState app = AppState.instance;
    await app.progress.markLearned(card.char);
    await app.progress.advanceLesson(card.lessonId + 1);
    app.refreshDue();
    if (!context.mounted) return;

    final Lesson current = lessonOf(card.lessonId);
    final bool lessonDone =
        current.chars.every((String c) => app.progress.isLearned(c));
    if (!lessonDone) return;

    final int nextId = card.lessonId + 1;
    final int maxLessonId =
        kLessons.fold<int>(0, (int m, Lesson l) => l.id > m ? l.id : m);
    final bool hasNext =
        nextId <= maxLessonId && kLessons.any((Lesson l) => l.id == nextId);

    final String msg =
        hasNext ? GentleWords.lessonAllLearned : GentleWords.allLessonsDone;
    // SnackBar 挂在 MaterialApp 的 ScaffoldMessenger 上，跳转后仍会显示完
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: GentleHint(message: msg, icon: Icons.emoji_emotions_outlined),
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 1800),
      ),
    );
    TtsService.instance.speak(msg);
    await Future<void>.delayed(const Duration(milliseconds: 1800));
    if (!context.mounted) return;
    if (hasNext) {
      Navigator.pushReplacementNamed(context, AppRouter.lesson, arguments: nextId);
    } else {
      Navigator.popUntil(context, ModalRoute.withName(AppRouter.home));
    }
  }
}

class _Row extends StatelessWidget {
  final AppDimens d;
  final String label;
  final String value;

  const _Row({required this.d, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: d.fs(AppDimens.gapS)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: d.fs(64),
            child: Text(label, style: AppTheme.sans(size: d.fs(16), color: AppTheme.ink2)),
          ),
          Expanded(child: Text(value, style: AppTheme.serif(size: d.fs(20)))),
        ],
      ),
    );
  }
}

class _Action extends StatelessWidget {
  final AppDimens d;
  final IconData icon;
  final String label;
  final bool primary;
  final VoidCallback? onTap;

  const _Action({required this.d, required this.icon, required this.label, this.primary = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    final Color fg = primary ? AppTheme.dai : AppTheme.ink2;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimens.radius),
      child: Container(
        constraints: BoxConstraints(minHeight: d.touch),
        padding: EdgeInsets.symmetric(horizontal: d.fs(AppDimens.gapM)),
        decoration: BoxDecoration(
          color: primary ? AppTheme.daiSoft : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimens.radius),
          border: Border.all(color: primary ? AppTheme.dai : AppTheme.line, width: primary ? 1.5 : 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: d.fs(26), color: onTap == null ? AppTheme.ink2.withValues(alpha: 0.4) : fg),
            SizedBox(width: d.fs(AppDimens.gapS)),
            Text(label, style: AppTheme.serif(size: d.fs(18), color: fg, w: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

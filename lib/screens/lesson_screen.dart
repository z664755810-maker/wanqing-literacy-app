import 'package:flutter/material.dart';

import '../app_router.dart';
import '../data/char_library.dart';
import '../data/lessons.dart';
import '../state/app_state.dart';
import '../theme/app_dimens.dart';
import '../theme/app_theme.dart';
import '../widgets/big_button.dart';

/// 新课学习：一课 3 个字，逐字卡片（听读音 → 看释义 → 看笔画），点字进详情。
///
/// 数据来自 [kCharLibrary] 按课号聚合；解锁顺序由 [AppState] 控制（见 T04）。
class LessonScreen extends StatelessWidget {
  final int lessonId;

  const LessonScreen({super.key, this.lessonId = 1});

  @override
  Widget build(BuildContext context) {
    final AppDimens d = AppDimens.of(context);
    final Lesson lesson = lessonOf(lessonId);
    return Scaffold(
      appBar: AppBar(title: Text(lesson.title, style: AppTheme.serif(size: d.fs(26)))),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(d.pagePad),
          children: <Widget>[
            Text('这一课学 ${lesson.chars.length} 个字', style: AppTheme.sans(size: d.fs(18), color: AppTheme.ink2)),
            SizedBox(height: d.fs(AppDimens.gapM)),
            for (final String c in lesson.chars) ...<Widget>[
              _LessonCharCard(char: c),
              SizedBox(height: d.fs(AppDimens.gapM)),
            ],
            SizedBox(height: d.fs(AppDimens.gapL)),
            BigButton(
              label: '去练习',
              icon: Icons.check_circle_outline,
              onTap: () => Navigator.pushNamed(
                context,
                AppRouter.practice,
                arguments: List<String>.from(lesson.chars),
              ),
            ),
            SizedBox(height: d.fs(AppDimens.gapM)),
            BigButton.secondary(
              label: '去描红',
              icon: Icons.gesture_outlined,
              onTap: () => Navigator.pushNamed(
                context,
                AppRouter.practice,
                arguments: <String, dynamic>{'chars': lesson.chars, 'mode': 'trace'},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 一课里的单字卡。
///
/// 🔴 必须用 [ListenableBuilder] 订阅 [AppState]：从单字详情页 pop 回来时，
/// 「已学会」标记要立刻出现，不能让用户退出课程页再进来才刷新（用户实测反馈的问题）。
class _LessonCharCard extends StatelessWidget {
  final String char;
  const _LessonCharCard({required this.char});

  @override
  Widget build(BuildContext context) {
    final AppDimens d = AppDimens.of(context);
    final CharCard? card = kCharLibrary[char];
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (BuildContext context, Widget? _) {
        final bool learned = AppState.instance.progress.isLearned(char);
        return Card(
          child: InkWell(
            borderRadius: BorderRadius.circular(AppDimens.radius),
            onTap: () => Navigator.pushNamed(context, AppRouter.charDetail, arguments: char),
            child: Padding(
              padding: EdgeInsets.all(d.fs(AppDimens.gapM)),
              child: Row(
                children: <Widget>[
                  Text(card?.char ?? char, style: AppTheme.serif(size: d.fs(56))),
                  SizedBox(width: d.fs(AppDimens.gapM)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (card != null)
                          Text(card.pinyin, style: AppTheme.sans(size: d.fs(20), color: AppTheme.zhe)),
                        if (card != null)
                          Text(card.meaning, style: AppTheme.serif(size: d.fs(18), color: AppTheme.ink2)),
                      ],
                    ),
                  ),
                  if (learned) _LearnedBadge(d: d) else const Icon(Icons.chevron_right, color: AppTheme.dai),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// 「已学会」标记：黛青浅底 + 对勾。正向色，不用红/叉。
class _LearnedBadge extends StatelessWidget {
  final AppDimens d;
  const _LearnedBadge({required this.d});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: d.fs(AppDimens.gapS),
        vertical: d.fs(AppDimens.gapXs),
      ),
      decoration: BoxDecoration(
        color: AppTheme.daiSoft,
        borderRadius: BorderRadius.circular(AppDimens.radiusSm),
        border: Border.all(color: AppTheme.dai.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.check_circle_outline, size: d.fs(18), color: AppTheme.dai),
          SizedBox(width: d.fs(AppDimens.gapXs)),
          Text('已学会', style: AppTheme.serif(size: d.fs(15), color: AppTheme.dai, w: FontWeight.w700)),
        ],
      ),
    );
  }
}

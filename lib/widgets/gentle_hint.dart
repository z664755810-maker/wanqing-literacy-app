import 'package:flutter/material.dart';

import '../theme/app_dimens.dart';
import '../theme/app_theme.dart';

/// 统一文案库：所有反馈语必须正向、温和，禁止分数/百分比/排名/倒计时/惩罚音效。
class GentleWords {
  GentleWords._();

  /// 练习答错
  static const String retry = '再试一次哦';

  /// 练习答对
  static const String correct = '对啦';

  /// 练习答对（备选）
  static const String correctAlt = '就是这个';

  /// 临摹为空提交
  static const String emptyTrace = '还没写呢，用手指在格子里写一遍吧';

  /// 无可用短句
  static const String noSentence = '再学几个字，就能读句子啦';

  /// 重置进度确认
  static const String resetConfirm = '确定要重新开始吗？之前的进度会清掉。';

  /// 本课已学完
  static const String lessonDone = '这一课学完啦，真棒';

  /// 一课的字全部标记学会 → 自动进入下一课
  static const String lessonAllLearned = '这一课的字都认下了，接着看下一课';

  /// 已经是最后一课 → 回首页去复习
  static const String allLessonsDone = '今天的课都学完了，去复习看看';
}

/// 温和提示条：黛青/赭石浅底 + 墨字，**无红色、无 ✗ 图标、无音效**。
///
/// 用法：把 [message] 传给 [GentleHint]，由页面控制显隐；
/// 也提供 [GentleHint.show] 以 Overlay 形式短暂浮出（同样不带任何惩罚观感）。
class GentleHint extends StatelessWidget {
  final String message;
  final IconData? icon;

  const GentleHint({super.key, required this.message, this.icon});

  @override
  Widget build(BuildContext context) {
    final AppDimens d = AppDimens.of(context);
    return Container(
      constraints: BoxConstraints(minHeight: d.touch),
      padding: EdgeInsets.symmetric(
        horizontal: d.fs(AppDimens.gapM),
        vertical: d.fs(AppDimens.gapS),
      ),
      decoration: BoxDecoration(
        color: AppTheme.daiSoft,
        borderRadius: BorderRadius.circular(AppDimens.radius),
        border: Border.all(color: AppTheme.dai.withValues(alpha: 0.35), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon ?? Icons.spa_outlined, size: d.fs(26), color: AppTheme.dai),
          SizedBox(width: d.fs(AppDimens.gapS)),
          Flexible(
            child: Text(
              message,
              style: AppTheme.serif(size: d.fs(22), color: AppTheme.ink),
            ),
          ),
        ],
      ),
    );
  }
}

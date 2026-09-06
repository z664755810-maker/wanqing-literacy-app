import 'package:flutter/material.dart';

import '../app_router.dart';
import '../data/char_library.dart';
import '../data/story_ruby.dart';
import '../state/app_state.dart';
import '../theme/app_dimens.dart';
import '../theme/app_theme.dart';
import '../widgets/char_pic.dart';

/// 切换「我圈的字」并弹出可见反馈（故事屋 / 歇后语共用）。
///
/// 判定（见 [AppState.toggleMark] 语义）：
/// - 调用前已圈（wasMarked） → 现在是取消，返回 false → 提示「已取消『X』」；
/// - 调用前未圈 → 看返回值：true=新增成功 → 提示「已圈出『X』…」；
///   false=达上限（60）或空串 → 提示「圈的字满了（60 个）…」。
/// ⚠️ 不能只看返回值：toggleMark 在「已圈取消」和「达上限」时都返回 false，
///    必须结合调用前的 isMarked 才能区分这两种情况。
Future<bool> toggleMarkWithFeedback(BuildContext context, String char) async {
  final bool wasMarked = AppState.instance.isMarked(char);
  final bool ok = await AppState.instance.toggleMark(char);
  final String label;
  if (wasMarked) {
    label = '已取消『$char』';
  } else if (ok) {
    label = '已圈出『$char』，可在 我的 → 我圈的字 里复习';
  } else {
    label = '圈的字满了（60 个），先去『我圈的字』里复习几个吧';
  }
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(label, style: AppTheme.serif(size: 18)),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  return ok;
}

/// 可复用「我圈的字」汇总面板（故事屋章末 / 歇后语页底部共用）。
///
/// [sourceRubies] 是待统计的注音原文（如某章全部段落 ruby / 某页全部歇后语正文）。
/// 面板实时统计这些原文里、被 [AppState.markedChars] 命中的字（同字多段只统计一次），
/// 每个字可点进 [AppRouter.charDetail]，右上角 × 取消圈选（零惩罚）。
class MarkedCharsPanel extends StatelessWidget {
  final AppDimens d;
  final List<String> sourceRubies;
  final String title;
  final String emptyHint;

  const MarkedCharsPanel({
    super.key,
    required this.d,
    required this.sourceRubies,
    required this.title,
    required this.emptyHint,
  });

  @override
  Widget build(BuildContext context) {
    final AppDimens d = this.d;
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (BuildContext context, _) {
        // 统计本来源里出现过的「真实汉字」（标点/未注音剔除），用于命中过滤。
        final Set<String> present = <String>{};
        for (final String ruby in sourceRubies) {
          for (final RubyToken t in parseRuby(ruby)) {
            if (!t.isPunctuation) present.add(t.char);
          }
        }
        // 与全局已圈字取交集，按 Unicode 升序稳定展示；同字只出现一次。
        final List<String> hits = AppState.instance.markedChars
            .where((String c) => present.contains(c))
            .toList()
          ..sort();
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
                  Icon(Icons.bookmark_outline, size: d.fs(26), color: AppTheme.dai),
                  SizedBox(width: d.fs(AppDimens.gapS)),
                  Text(title, style: AppTheme.serif(size: d.fs(22), color: AppTheme.dai, w: FontWeight.w700)),
                  SizedBox(width: d.fs(AppDimens.gapS)),
                  Text('(${hits.length})', style: AppTheme.serif(size: d.fs(20), color: AppTheme.ink2)),
                ],
              ),
              SizedBox(height: d.fs(AppDimens.gapM)),
              if (hits.isEmpty)
                Text(emptyHint, style: AppTheme.serif(size: d.fs(18), color: AppTheme.ink2))
              else
                Wrap(
                  spacing: d.fs(AppDimens.gapS),
                  runSpacing: d.fs(AppDimens.gapS),
                  children: <Widget>[
                    for (final String c in hits)
                      _MarkedChip(d: d, char: c, onRemove: () => AppState.instance.removeMark(c)),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}

/// 单个汇总字：大字 + 配图（字库内），点进详情；右上角 × 移除。
class _MarkedChip extends StatelessWidget {
  final AppDimens d;
  final String char;
  final VoidCallback onRemove;

  const _MarkedChip({required this.d, required this.char, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final bool inLib = kCharLibrary.containsKey(char);
    return Stack(
      children: <Widget>[
        Material(
          color: AppTheme.daiSoft,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radius),
            side: BorderSide(color: AppTheme.dai.withValues(alpha: 0.4), width: 1),
          ),
          child: InkWell(
            onTap: () => Navigator.pushNamed(context, AppRouter.charDetail, arguments: char),
            borderRadius: BorderRadius.circular(AppDimens.radius),
            child: Container(
              constraints: BoxConstraints(minHeight: d.touch * 0.8, minWidth: d.fs(60)),
              padding: EdgeInsets.symmetric(horizontal: d.fs(AppDimens.gapS), vertical: d.fs(AppDimens.gapXs)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (inLib) CharPic(card: kCharLibrary[char]!, height: d.fs(40), width: d.fs(40)),
                  if (inLib) SizedBox(width: d.fs(AppDimens.gapXs)),
                  Text(char, style: AppTheme.serif(size: d.fs(30), w: FontWeight.w500)),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: SizedBox(
            width: d.touch * 0.6,
            height: d.touch * 0.6,
            child: InkWell(
              onTap: onRemove,
              borderRadius: BorderRadius.circular(AppDimens.radius),
              child: Center(
                child: Icon(Icons.close, size: d.fs(20), color: AppTheme.ink2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

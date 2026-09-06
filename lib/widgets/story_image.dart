import 'package:flutter/material.dart';

import '../theme/app_dimens.dart';
import '../theme/app_theme.dart';

/// 故事插图：从 APK 资源加载漫画图。资源缺失时优雅降级为装饰占位（绝不崩、绝不显示裂图）。
///
/// 设计意图：图片是「锦上添花」，不是「加载失败就白屏」。缺图时给一个暖色占位框，
/// 让用户知道「这里原本该有图」，后续把图放进去即自动生效，无需改代码。
class StoryImage extends StatelessWidget {
  final String? asset;
  final double? height;
  final double? width;
  final String? caption;

  const StoryImage(this.asset, {super.key, this.height, this.width, this.caption});

  @override
  Widget build(BuildContext context) {
    final AppDimens d = AppDimens.of(context);
    final bool hasAsset = asset != null && asset!.isNotEmpty;
    return Container(
      width: width ?? double.infinity,
      height: height ?? d.fs(220),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(d.fs(AppDimens.radius)),
        border: Border.all(color: AppTheme.line, width: 1),
        color: AppTheme.paper2,
      ),
      clipBehavior: Clip.antiAlias,
      child: hasAsset
          ? Image.asset(
              asset!,
              fit: BoxFit.cover,
              errorBuilder: (BuildContext ctx, Object err, StackTrace? st) {
                return _Placeholder(caption: caption, d: d);
              },
            )
          : _Placeholder(caption: caption, d: d),
    );
  }
}

/// 资源缺失时的暖色占位（区别于系统裂图）。
class _Placeholder extends StatelessWidget {
  final String? caption;
  final AppDimens d;
  const _Placeholder({this.caption, required this.d});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.paper2,
      padding: EdgeInsets.all(d.fs(AppDimens.gapM)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.auto_stories_outlined, size: d.fs(48), color: AppTheme.zhe.withValues(alpha: 0.5)),
          if (caption != null) ...<Widget>[
            SizedBox(height: d.fs(AppDimens.gapS)),
            Text(
              caption!,
              textAlign: TextAlign.center,
              style: AppTheme.sans(size: d.fs(15), color: AppTheme.ink2.withValues(alpha: 0.7)),
            ),
          ],
        ],
      ),
    );
  }
}

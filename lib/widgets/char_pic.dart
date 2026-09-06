import 'package:flutter/material.dart';

import '../data/char_card.dart';
import '../theme/app_dimens.dart';
import '../theme/app_theme.dart';

/// 单字配图：按 [CharCard.picPath] 渲染该字的「生活化插图」。
///
/// 设计要点（对齐现有 StoryImage 的兜底哲学）：
/// - 该字没配图（[CharCard.hasPic] 为 false）→ 返回空，不占位置。
/// - 图文件缺失 / 解码失败 → `errorBuilder` 显示一个淡灰图标，绝不抛异常、绝不空白方块。
/// 这样即使某张图没生成或路径错，页面也只是少一张图，不会崩。
class CharPic extends StatelessWidget {
  final CharCard card;
  final double? height;
  final double? width;
  final BorderRadius? radius;

  const CharPic({
    super.key,
    required this.card,
    this.height,
    this.width,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    final String? path = card.picPath;
    if (path == null) return const SizedBox.shrink();

    final BorderRadius r = radius ?? BorderRadius.circular(AppDimens.radius);
    return ClipRRect(
      borderRadius: r,
      child: Container(
        height: height,
        width: width ?? double.infinity,
        color: AppTheme.paper2,
        child: Image.asset(
          path,
          height: height,
          width: width ?? double.infinity,
          fit: BoxFit.contain,
          errorBuilder: (BuildContext ctx, Object err, StackTrace? st) => Center(
            child: Icon(
              Icons.image_outlined,
              size: (height ?? 80) * 0.34,
              color: AppTheme.ink2.withValues(alpha: 0.32),
            ),
          ),
        ),
      ),
    );
  }
}

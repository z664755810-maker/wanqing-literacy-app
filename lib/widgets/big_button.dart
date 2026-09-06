import 'package:flutter/material.dart';

import '../theme/app_dimens.dart';
import '../theme/app_theme.dart';

/// 超大主按钮：最小高 72dp、热区 ≥64dp、圆角 16，支持图标 + 文字、选中态、禁用态。
///
/// 中老年适配：按钮够大、对比够强、状态变化明显（选中 = 黛青填充）。
class BigButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool selected;
  final bool primary;
  final bool expand;

  const BigButton({
    super.key,
    required this.label,
    this.icon,
    this.onTap,
    this.selected = false,
    this.primary = true,
    this.expand = true,
  });

  /// 次操作按钮（赭石描边，非填充）
  const BigButton.secondary({
    super.key,
    required this.label,
    this.icon,
    this.onTap,
    this.selected = false,
    this.primary = false,
    this.expand = true,
  });

  @override
  Widget build(BuildContext context) {
    final AppDimens d = AppDimens.of(context);
    final bool enabled = onTap != null;
    final Color accent = primary ? AppTheme.dai : AppTheme.zhe;
    final Color fill = !enabled
        ? AppTheme.paper2
        : (selected ? accent : (primary ? accent : AppTheme.paper));
    final Color fg = !enabled
        ? AppTheme.ink2.withValues(alpha: 0.45)
        : (selected || primary ? Colors.white : AppTheme.zhe);
    final BorderSide side = BorderSide(
      color: !enabled ? AppTheme.line : (selected ? accent : (primary ? accent : AppTheme.zhe)),
      width: 2,
    );

    final Widget content = Row(
      mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (icon != null) ...<Widget>[
          Icon(icon, size: d.fs(30), color: fg),
          SizedBox(width: d.fs(AppDimens.gapS)),
        ],
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTheme.serif(size: d.fs(26), color: fg, w: FontWeight.w600),
          ),
        ),
      ],
    );

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: d.buttonH, minWidth: d.touch),
      child: SizedBox(
        width: expand ? double.infinity : null,
        height: d.buttonH,
        child: Material(
          color: fill,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.radius), side: side),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppDimens.radius),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: d.fs(AppDimens.gapM)),
              child: Center(child: content),
            ),
          ),
        ),
      ),
    );
  }
}

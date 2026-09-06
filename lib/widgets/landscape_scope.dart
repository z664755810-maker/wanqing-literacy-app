import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 故事屋专用：进入时锁定横屏，离开时恢复应用默认方向。
///
/// 为什么要锁横屏：
/// - 平板横放时一行能排下更多字，注音不会挤成两行，读起来更接近「捧着一本图画书」；
/// - 插图与正文可以左右并排，图片不会被压扁。
///
/// ⚠️ **只挂在「故事屋·书架」（模块入口）上**，不要挂在阅读器上。
/// 原因：书架是模块根，它在时才该是横屏；阅读器压在书架之上，天然继承横屏。
/// 如果阅读器也「退出时恢复竖屏」，从阅读器返回书架时（阅读器 dispose）会把
/// 方向改成竖屏，而下层书架并不会重新申请横屏 —— 就会变成「读完一章回到书架变成竖屏」的怪现象。
/// 阅读器只在 [StoryReaderScreen.initState] 里调一次 [LandscapeScope.enter]（幂等，不改回）。
class LandscapeScope extends StatefulWidget {
  final Widget child;

  const LandscapeScope({super.key, required this.child});

  /// 应用默认方向（与 main.dart 保持一致：竖屏优先，允许横屏）
  static const List<DeviceOrientation> appDefault = <DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ];

  /// 锁定左右横屏（幂等，可重复调用）
  static Future<void> enter() {
    return SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  /// 恢复应用默认方向
  static Future<void> exit() => SystemChrome.setPreferredOrientations(appDefault);

  @override
  State<LandscapeScope> createState() => _LandscapeScopeState();
}

class _LandscapeScopeState extends State<LandscapeScope> {
  @override
  void initState() {
    super.initState();
    LandscapeScope.enter();
  }

  @override
  void dispose() {
    // 离开故事屋（返回 / 切底部 tab / 系统返回）时把方向还给应用
    LandscapeScope.exit();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

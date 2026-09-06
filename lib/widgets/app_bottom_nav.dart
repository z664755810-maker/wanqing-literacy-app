import 'package:flutter/material.dart';

import '../app_router.dart';
import '../theme/app_dimens.dart';
import '../theme/app_theme.dart';

/// 底部导航：学习 / 复习 / 阅读 / 拼音 / 故事 / 字典 / 我的。
///
/// 拼音作为独立入口（方案 A 呼读音代读），与汉字优先并不冲突——它是「学拼音」专区，
/// 平时阅读里拼音仍是汉字旁的弱化标注。
class AppBottomNav extends StatelessWidget {
  final int current;
  const AppBottomNav(this.current, {super.key});

  /// 导航项顺序即底部显示顺序，索引与 [current] 对应。
  static const List<NavItem> items = <NavItem>[
    NavItem(icon: Icons.school_outlined, label: '学习', route: AppRouter.home),
    NavItem(icon: Icons.replay_outlined, label: '复习', route: AppRouter.review),
    NavItem(icon: Icons.auto_stories_outlined, label: '阅读', route: AppRouter.read),
    NavItem(icon: Icons.spellcheck_outlined, label: '拼音', route: AppRouter.pinyin),
    NavItem(icon: Icons.menu_book_outlined, label: '故事', route: AppRouter.storyShelf),
    NavItem(icon: Icons.book_outlined, label: '字典', route: AppRouter.dictionary),
    NavItem(icon: Icons.grid_view_outlined, label: '我的', route: AppRouter.library),
  ];

  /// 页面自取索引：AppBottomNav.indexOfRoute(AppRouter.home)
  static int indexOfRoute(String route) => items.indexWhere((NavItem it) => it.route == route);

  @override
  Widget build(BuildContext context) {
    final AppDimens d = AppDimens.of(context);
    return BottomNavigationBar(
      currentIndex: current,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppTheme.paper2,
      selectedItemColor: AppTheme.dai,
      unselectedItemColor: AppTheme.ink2,
      selectedFontSize: d.fs(14),
      unselectedFontSize: d.fs(14),
      onTap: (int i) {
        if (i == current) return;
        Navigator.pushReplacementNamed(context, items[i].route);
      },
      items: <BottomNavigationBarItem>[
        for (final NavItem it in items)
          BottomNavigationBarItem(
            icon: Icon(it.icon, size: d.fs(30)),
            label: it.label,
          ),
      ],
    );
  }
}

/// 底部导航项（常量类，便于 [AppBottomNav.indexOfRoute] 反查索引）
class NavItem {
  final IconData icon;
  final String label;
  final String route;

  const NavItem({required this.icon, required this.label, required this.route});
}

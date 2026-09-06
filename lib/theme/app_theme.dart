import 'package:flutter/material.dart';

import 'app_dimens.dart';

/// 晚晴识字 · 视觉语言
///
/// 宣纸米底 + 墨黑字 + 黛青(主操作/已学) + 赭石(次操作/分类) + 朱印(仅破坏性操作)。
/// 汉字一律走 [AppTheme.serif]（宋体回退链），说明文字走 [AppTheme.sans]。
class AppTheme {
  // ---------- 色板 ----------
  /// 宣纸米（背景）
  static const Color paper = Color(0xFFF4EEDF);
  /// 宣纸米（次级背景：AppBar / 底栏 / 卡片头）
  static const Color paper2 = Color(0xFFEFE7D4);
  /// 墨黑（正文，对比度 ≈ 12:1）
  static const Color ink = Color(0xFF26221C);
  /// 墨灰（次要文字）
  static const Color ink2 = Color(0xFF4A4338);
  /// 黛青（主操作 / 已学状态 / 正向反馈）
  static const Color dai = Color(0xFF2F5D62);
  /// 赭石（次操作 / 分类标签）
  static const Color zhe = Color(0xFFA85E2E);
  /// 朱印（仅用于「重置进度」等破坏性操作）
  static const Color seal = Color(0xFF9E3B2E);
  /// 分隔线
  static const Color line = Color(0xFFD8CDB4);

  /// 黛青浅底（选中态 / 已学卡片）
  static const Color daiSoft = Color(0xFFDCE7E6);
  /// 赭石浅底（分类标签）
  static const Color zheSoft = Color(0xFFF2E2D3);

  /// 中文衬线（宋体）回退链，禁止让汉字落在 Roboto 上
  static const List<String> cjkFallback = <String>[
    'Songti SC',
    'SimSun',
    'STSong',
    'Noto Serif SC',
    'serif',
  ];

  /// 汉字 / 标题用：衬线（宋体）
  static TextStyle serif({
    double size = 24,
    Color? color,
    FontWeight w = FontWeight.normal,
    double? height,
    double? h,
  }) =>
      TextStyle(
        fontSize: size,
        color: color ?? ink,
        fontFamilyFallback: cjkFallback,
        fontWeight: w,
        height: h ?? height ?? 1.3,
      );

  /// 说明文字 / 提示用：无衬线
  static TextStyle sans({
    double size = 16,
    Color? color,
    FontWeight w = FontWeight.normal,
    double? height,
    double? h,
  }) =>
      TextStyle(
        fontSize: size,
        color: color ?? ink,
        fontWeight: w,
        height: h ?? height ?? 1.5,
      );

  static final ThemeData theme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: paper,
    primaryColor: dai,
    colorScheme: ColorScheme.fromSeed(seedColor: dai, surface: paper),
    appBarTheme: AppBarTheme(
      backgroundColor: paper2,
      foregroundColor: ink,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: serif(size: 22, color: ink, w: FontWeight.w600),
      iconTheme: const IconThemeData(color: ink),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: paper2,
      selectedItemColor: dai,
      unselectedItemColor: ink2,
      selectedLabelStyle: serif(size: 13, color: dai),
      unselectedLabelStyle: serif(size: 13, color: ink2),
    ),
    cardTheme: CardThemeData(
      color: paper,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radius),
        side: const BorderSide(color: line, width: 1),
      ),
    ),
    textTheme: TextTheme(
      bodyMedium: sans(size: 16, color: ink2),
      bodyLarge: sans(size: 18, color: ink),
      titleLarge: serif(size: 22, color: ink, w: FontWeight.w600),
    ),
    dividerColor: line,
  );
}

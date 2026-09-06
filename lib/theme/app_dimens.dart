import 'package:flutter/widgets.dart';

import '../state/app_state.dart';

/// 晚晴识字 · 尺寸规范：触控热区、按钮高度、字号档位、间距。
///
/// 中老年适配三原则：热区够大、字够大、节奏够慢。
/// 所有界面尺寸都应经过 [AppDimens.fs] / [AppDimens.btn] 相乘，禁止裸写常量。
class AppDimens {
  // ---------- 字号档位 ----------
  static const List<double> kFontScales = <double>[1.0, 1.15, 1.3, 1.5];
  static const List<String> kFontScaleLabels = <String>['小', '中', '大', '超大'];
  static const double kDefaultFontScale = 1.3;

  // ---------- 按钮尺寸档位 ----------
  static const List<double> kButtonScales = <double>[1.0, 1.12, 1.25];
  static const List<String> kButtonScaleLabels = <String>['标准', '大', '特大'];
  static const double kDefaultButtonScale = 1.0;

  // ---------- 触控与按钮 ----------
  /// 最小触控热区（dp）
  static const double minTouch = 64;
  /// 主按钮高度（dp）
  static const double buttonHeight = 72;
  /// 卡片/按钮圆角
  static const double radius = 16;
  static const double radiusSm = 12;

  // ---------- 间距 ----------
  static const double gapXs = 4;
  static const double gapS = 8;
  static const double gapM = 16;
  static const double gapL = 24;
  static const double gapXl = 32;
  static const double pagePadding = 20;

  // ---------- 阅读版心 ----------
  /// 横屏阅读时正文的最大宽度（dp）。
  /// 一行字太长眼睛会「跳行」，横屏下必须收住版心，两侧留白更舒服。
  static const double maxReadWidth = 1100;

  // ---------- 基准字号（实际字号 = 基准 × fontScale）----------
  static const double fsCaption = 14;
  static const double fsBody = 18;
  static const double fsTitle = 22;
  static const double fsBig = 28;
  static const double fsHuge = 40;
  /// 主页/字详情的超大汉字（平板上 ≥ 180dp）
  static const double fsHeroChar = 180;
  /// 练选项里的汉字
  static const double fsOptionChar = 88;
  /// 拼音标注（弱化处理，≤ 主字号的 1/4）
  static const double fsPinyin = 22;

  // ---------- 全局倍率（由 AppState 在设置变化时写入）----------
  static double globalFontScale = kDefaultFontScale;
  static double globalButtonScale = kDefaultButtonScale;

  final double fontScale;
  final double buttonScale;

  const AppDimens({
    this.fontScale = kDefaultFontScale,
    this.buttonScale = kDefaultButtonScale,
  });

  /// 读取当前生效的尺寸规格。
  ///
  /// 通过 [AppDimensScope]（包在 MaterialApp 外的 InheritedNotifier<AppState>）订阅设置变化：
  /// 任意页面调用 [of] 都会成为依赖，[AppState.notifyListeners] 时整树（含导航栈里的路由页）
  /// 自动重建，字号/按钮即时生效。这是 v1.8 修「设置点了没反应」的关键——原来只在 MaterialApp
  /// 外包 ListenableBuilder，而 Navigator 会保留路由 widget，路由页并不会因此重建。
  static AppDimens of(BuildContext context) {
    context.dependOnInheritedWidgetOfExactType<AppDimensScope>();
    return AppDimens(fontScale: globalFontScale, buttonScale: globalButtonScale);
  }

  /// 按字号倍率放大
  double fs(double base) => base * fontScale;

  /// 按按钮倍率放大
  double btn(double base) => base * buttonScale;

  /// 当前最小触控热区
  double get touch => minTouch * buttonScale;

  /// 当前主按钮高度
  double get buttonH => buttonHeight * buttonScale;

  /// 页面内边距
  double get pagePad => pagePadding * (0.7 + 0.3 * fontScale);

  /// 同步全局倍率（由 AppState 调用）
  static void apply({required double fontScale, required double buttonScale}) {
    globalFontScale = fontScale;
    globalButtonScale = buttonScale;
  }
}

/// 全局尺寸作用域：包裹 MaterialApp，监听 [AppState] 变化，让所有页面（含导航栈里的路由页）
/// 在设置改变时即时重建并读到新的 [AppDimens]。
class AppDimensScope extends InheritedNotifier<AppState> {
  const AppDimensScope({super.key, required AppState notifier, required super.child})
      : super(notifier: notifier);
}

import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_router.dart';
import 'services/tts_service.dart';
import 'state/app_state.dart';
import 'theme/app_dimens.dart';
import 'theme/app_theme.dart';
import 'widgets/voice_player_bar.dart';

/// 未捕获异常兜底：打印日志，绝不让 App 闪退到桌面。
///
/// 老年用户遇到整屏退出会不知所措，且本次「点朗读就闪退」的根因正是个别未被兜住的
/// native/Dart 异常。这里在三层都接住：Framework 内 → [FlutterError.onError]；
/// 事件回调 / Timer / 未 await 的 Future → [PlatformDispatcher.onError] + [runZonedGuarded]。
void _reportError(Object error, StackTrace? stack) {
  debugPrint('[Wanqing] 未捕获异常（已兜底，未闪退）: $error');
  if (stack != null) debugPrint(stack.toString());
}

/// 晚晴识字 · 入口
///
/// 初始化顺序：Flutter 绑定 → 全局异常兜底 → 屏幕方向 → AppState → TTS → runApp。
/// 纯离线应用：全程不发起任何网络请求。
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔴 全局异常兜底（防止单点异常导致整 App 闪退到桌面）
  FlutterError.onError = (FlutterErrorDetails details) {
    _reportError(details.exception, details.stack);
  };
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    _reportError(error, stack);
    return true; // 已处理，阻止原生崩溃
  };

  runZonedGuarded<void>(
    () async {
      // 竖屏优先（平板手持最自然），同时允许横屏切换
      await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

      // 全局状态：进度 + 设置（含字号倍率立即作用到 AppDimens）+ 到期数。
      // 必须在 runApp 之前完成，否则首屏读到的是空进度。
      await AppState.instance.init();
      // TTS 用「已保存的语速」初始化，避免首屏朗读与设置不符
      await TtsService.instance.init(speechRate: AppState.instance.settings.speechRate);

      runApp(const WanqingApp());
    },
    (Object error, StackTrace stack) {
      _reportError(error, stack);
    },
  );
}

/// 应用根组件
class WanqingApp extends StatelessWidget {
  const WanqingApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 订阅全局状态：字号 / 按钮 / 语速 / 拼音 设置变化时整树重建，
    // 各页面通过 `AppDimens.of(context)` 立即读到新倍率（实时生效，无需退出重开）。
    return AppDimensScope(
      notifier: AppState.instance,
      child: MaterialApp(
        title: '晚晴识字',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        initialRoute: AppRouter.initialRoute,
        routes: AppRouter.routes,
        onGenerateRoute: AppRouter.onGenerateRoute,
        // 字号由 AppDimens 统一管理，屏蔽系统字体缩放带来的布局溢出
        builder: (BuildContext context, Widget? child) {
          final Widget inner = child ?? const SizedBox.shrink();
          // 全局语音浮层：叠在 Navigator 之上，覆盖所有界面，且天然只有「一个」
          // （作为 builder 返回的树中常驻 widget，随 MaterialApp 重建而重建，不会重复插入）。
          return MediaQuery.withClampedTextScaling(
            minScaleFactor: 1.0,
            maxScaleFactor: 1.0,
            child: Stack(
              children: <Widget>[
                inner,
                const VoicePlayerBar(),
              ],
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/foundation.dart';

import '../data/story_assets.dart';
import '../services/progress_service.dart';
import '../services/review_service.dart';
import '../services/store.dart';
import '../services/tts_service.dart';
import '../theme/app_dimens.dart';

/// 应用全局设置（字号 / 语速 / 按钮大小 / 是否显示拼音）。
///
/// 持久化走 [Store] 的 wq_settings_v1。改设置会同步写回并作用到 [AppDimens]，
/// 让所有页面通过 `AppDimens.of(context)` 即时生效。
class AppSettings {
  final double fontScale;
  final double speechRate;
  final double buttonScale;
  final bool showPinyin;
  /// 朗读嗓音名称；null = 自动挑本机最优中文嗓音（「普通话/Chinese/中文」优先）。
  /// 设置页列出本机已装的中文嗓音供挑选，不依赖任何第三方 TTS App。
  final String? ttsVoice;

  const AppSettings({
    this.fontScale = 1.3,
    this.speechRate = 0.7,
    this.buttonScale = 1.0,
    this.showPinyin = true,
    this.ttsVoice,
  });

  Map<String, dynamic> toJson() => <String, dynamic>{
        'fontScale': fontScale,
        'speechRate': speechRate,
        'buttonScale': buttonScale,
        'showPinyin': showPinyin,
        'ttsVoice': ttsVoice,
      };

  AppSettings copyWith({
    double? fontScale,
    double? speechRate,
    double? buttonScale,
    bool? showPinyin,
    String? ttsVoice,
  }) =>
      AppSettings(
        fontScale: fontScale ?? this.fontScale,
        speechRate: speechRate ?? this.speechRate,
        buttonScale: buttonScale ?? this.buttonScale,
        showPinyin: showPinyin ?? this.showPinyin,
        ttsVoice: ttsVoice ?? this.ttsVoice,
      );

  static AppSettings fromJson(Map<String, dynamic>? j) {
    if (j == null) return const AppSettings();
    final double fontScale = (j['fontScale'] as num? ?? 1.3).toDouble();
    // 语速语义升级为「物理倍速」：0.7 / 0.85 / 1.0（慢速 / 正常 / 稍快，默认 0.7）。
    // 旧版三档（系统 TTS 时期 0.2 / 0.3 / 0.4）按「慢/中/快」近似映射：0.2→0.7、0.3→0.85、0.4→1.0。
    // 已是新值（0.7/0.85/1.0）则原样保留；其余意外值统一迁到默认 0.7。
    double speechRate = (j['speechRate'] as num? ?? 0.7).toDouble();
    if ((speechRate - 0.2).abs() < 1e-6) {
      speechRate = 0.7;
    } else if ((speechRate - 0.3).abs() < 1e-6) {
      speechRate = 0.85;
    } else if ((speechRate - 0.4).abs() < 1e-6) {
      speechRate = 1.0;
    } else if (speechRate != 0.7 && speechRate != 0.85 && speechRate != 1.0) {
      speechRate = 0.7;
    }
    final double buttonScale = (j['buttonScale'] as num? ?? 1.0).toDouble();
    final bool showPinyin = j['showPinyin'] as bool? ?? true;
    final String? ttsVoice = j['ttsVoice'] as String?;
    return AppSettings(
      fontScale: fontScale,
      speechRate: speechRate,
      buttonScale: buttonScale,
      showPinyin: showPinyin,
      ttsVoice: ttsVoice,
    );
  }

  Future<void> save() => Store.setJson(Store.kSettings, toJson());

  static AppSettings load() => AppSettings.fromJson(Store.getJson(Store.kSettings));
}

/// 全局状态内核：进度 + 设置 + 到期数。
///
/// 单一 [ChangeNotifier]，UI 用 `ListenableBuilder(listenable: AppState.instance, ...)` 订阅。
/// 不引入任何状态管理包（项目红线）。
class AppState extends ChangeNotifier {
  static final AppState instance = AppState._();
  AppState._();

  late final ProgressService progress;
  late AppSettings settings;
  int dueCount = 0;

  /// 自标生字（「我圈的字」）：含字库外的字。上限 60（心理护栏，见方案 2.2）。
  late Set<String> _markedChars;
  static const int _kMaxMarks = 60;

  Future<void> init() async {
    await Store.init();
    // 预加载 APK 资源清单，供故事屋过滤掉「数据里写了图、但包里没打包」的孤儿占位框
    await StoryAssets.load();
    progress = ProgressService()..load();
    settings = AppSettings.load();
    _markedChars = _loadMarksFromStore();
    // 让字号/按钮倍率立即作用到全局 AppDimens
    AppDimens.apply(fontScale: settings.fontScale, buttonScale: settings.buttonScale);
    // 应用已选朗读嗓音（null = 自动挑本机最优中文嗓音）
    try {
      await TtsService.instance.init(speechRate: settings.speechRate);
      await TtsService.instance.applyVoice(settings.ttsVoice);
    } catch (_) {
      // TTS 不可用时静默降级
    }
    refreshDue();
  }

  /// 重算到期数并通知订阅者。
  void refreshDue() {
    dueCount = ReviewService.dueToday(progress).length;
    notifyListeners();
  }

  Future<void> updateSettings(AppSettings s) async {
    final String? oldVoice = settings.ttsVoice;
    settings = s;
    // 🔴 先让界面立即刷新：之前先 await s.save() 再 notifyListeners()，
    //    一旦持久化在真机抛异常，整个设置页就「点了没反应」。现在反过来——
    //    状态先落地 + 通知订阅者，UI 立刻跟着变，落盘/TTS 设为尽力而为。
    AppDimens.apply(fontScale: s.fontScale, buttonScale: s.buttonScale);
    notifyListeners();
    // 持久化失败只回退到默认值，不应卡住界面
    try {
      await s.save();
    } catch (e) {
      // ignore: 落盘失败不影响已生效的设置
    }
    // 语速同步到 TTS 引擎（实时生效，无需重启）
    try {
      await TtsService.instance.setSpeechRate(s.speechRate);
    } catch (e) {
      // ignore: 语速设置失败不影响其它设置
    }
    // 朗读嗓音切换（实时生效，无需重启）
    if (s.ttsVoice != oldVoice) {
      try {
        await TtsService.instance.applyVoice(s.ttsVoice);
      } catch (e) {
        // ignore: 嗓音切换失败不影响其它设置
      }
    }
  }

  Future<void> resetProgress() async {
    await progress.resetAll();
    refreshDue();
  }

  // ---------------- 自标生字（「我圈的字」）----------------
  /// 对外只暴露拷贝，防止外部绕过 API 直接改内存集合。
  Set<String> get markedChars => Set<String>.from(_markedChars);

  /// 是否已标记（字库外字也可标记）
  bool isMarked(String c) => _markedChars.contains(c);

  /// 列出自标字（Unicode 升序，便于 UI 稳定展示）。
  List<String> getMarks() {
    final List<String> list = _markedChars.toList()..sort();
    return list;
  }

  /// 新增一个自标字。返回 true=实际新增；false=已存在或已达上限（静默忽略，不打扰）。
  Future<bool> addMark(String c) async {
    if (c.isEmpty) return false;
    if (_markedChars.contains(c)) return false;
    if (_markedChars.length >= _kMaxMarks) return false;
    _markedChars.add(c);
    notifyListeners();
    await _persistMarks();
    return true;
  }

  /// 移除一个自标字（零惩罚，可逆）。
  Future<void> removeMark(String c) async {
    if (!_markedChars.remove(c)) return;
    notifyListeners();
    await _persistMarks();
  }

  /// 切换：已圈→取消（返回 false），未圈→新增（返回 true=新增成功 / false=达上限）。
  Future<bool> toggleMark(String c) async {
    if (isMarked(c)) {
      await removeMark(c);
      return false;
    }
    return addMark(c);
  }

  /// 从存储重新载入自标字（备份恢复后调用，使内存与磁盘一致）。
  Future<void> reloadMarks() async {
    _markedChars = _loadMarksFromStore();
    notifyListeners();
  }

  Set<String> _loadMarksFromStore() {
    final Set<String> out = <String>{};
    final Map<String, dynamic>? snap = Store.getJson(Store.kMarks);
    if (snap != null) {
      final dynamic chars = snap['chars'];
      if (chars is List) {
        for (final dynamic e in chars) {
          if (e is String) out.add(e);
        }
      }
    }
    return out;
  }

  Future<void> _persistMarks() async {
    try {
      await Store.setJson(Store.kMarks, <String, dynamic>{
        'v': 1,
        'chars': _markedChars.toList(),
      });
    } catch (_) {
      // 落盘失败不影响已生效的内存态
    }
  }
}

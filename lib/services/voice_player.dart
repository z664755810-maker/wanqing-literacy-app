import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../data/voice_manifest.dart';
// v1.16: 双档 manifest——慢速（-30%）走 kVoiceManifest，原速（+0%）走 kVoiceManifestNorm。
// 两者字段名一致（均为 const Map<String, String>），故用 `show` 显式暴露后者。
import '../data/voice_manifest_norm.dart' show kVoiceManifestNorm;
import '../state/app_state.dart';
import 'tts_service.dart';

/// 晚晴识字 · 全局语音播放器（中央路由）。
///
/// 职责：
/// 1. 真正播放「打包进 APK 的预生成音频」（经 Kotlin `MethodChannel('wanqing/audio')`
///    + 原生 `MediaPlayer`，零新依赖、零联网）；
/// 2. 持有全局播放状态，供「全局浮层进度条」实时读取（[VoicePlayerBar] 用
///    `ListenableBuilder(listenable: VoicePlayer.instance, ...)` 订阅）；
/// 3. 当某条文本尚未生成音频（map 里查不到）时，回落到系统 TTS
///    （[TtsService.speakRaw]，已做净化+分块+每块超时，长文本不再闪退）。
///
/// v1.15 加固点：
/// - **看门狗**：预生成音频开播后若超过「时长+2.5s」还没收到完成回调，自动终止并复位，
///   进度条/浮层永远不会卡住不消失（旧版会因无完成回调而永久停在播放态）。
/// - **失败不盲目回落 TTS**：预生成音频如果 native 报错，直接静默复位——绝不把一条
///   必然失败的内容再丢给系统 TTS 撞一遍崩溃路径；只有 manifest 里没有的文本才走 TTS。
/// - **stop 递增代际号**：用户点终止后，任何迟到的完成回调/旧回落都作废。
///
/// 🔴 TTS 铁律：只有真汉字能进语音。本类所有公开方法接收的 [text] 都应是汉字，
///    拼音字母绝不经过本通道。
class VoicePlayer extends ChangeNotifier {
  VoicePlayer._();

  static final VoicePlayer instance = VoicePlayer._();

  static const MethodChannel _ch = MethodChannel('wanqing/audio');
  static const EventChannel _progressCh = EventChannel('wanqing/audio/progress');

  // ---------- 可监听的播放状态（浮层只读这些）----------
  bool _isPlaying = false;
  bool _isPaused = false;
  /// 是否处于「系统 TTS 回落」态：此时没有可拖动的音频进度，进度条显不确定态，只给终止。
  bool _usingFallback = false;
  double _progress = 0.0; // 0..1
  int _durationMs = 0;
  int _positionMs = 0;
  String? _currentLabel;

  bool get isPlaying => _isPlaying;
  bool get isPaused => _isPaused;
  bool get usingFallback => _usingFallback;
  double get progress => _progress;
  int get durationMs => _durationMs;
  int get positionMs => _positionMs;
  String? get currentLabel => _currentLabel;

  /// 是否正在「有进度的音频」播放（用于浮层判断是否显示可拖动进度条 + 暂停/继续）。
  bool get hasAudioProgress => _isPlaying && !_usingFallback && _durationMs > 0;

  StreamSubscription<dynamic>? _sub;
  int _gen = 0; // 防止「旧朗读还没结束就被新播放打断」后误复位状态
  /// 当前这一轮「音频播放」的代际号。原生播完回调 onComplete 到达时，
  /// 只有它等于 [_gen] 才说明是这一轮播完了（期间可能已开始新播放）。
  int? _playingGen;
  bool _handlerSet = false;
  Timer? _watchdog;

  /// 懒订阅进度事件流（只建一次）。
  void _ensureListening() {
    if (_sub != null) return;
    _sub = _progressCh.receiveBroadcastStream().listen(
      (dynamic e) {
        if (e is Map<dynamic, dynamic>) {
          final int pos = (e['position'] as int?) ?? 0;
          final int dur = (e['duration'] as int?) ?? 0;
          _positionMs = pos;
          if (dur > 0) _durationMs = dur;
          _progress = dur > 0 ? (pos / dur).clamp(0.0, 1.0) : 0.0;
          notifyListeners();
        }
      },
      onError: (_) {/* 通道异常不崩 UI */},
    );
  }

  /// 懒注册原生回调（只设一次）：原生音频播完会反调 `onComplete`，
  /// 让浮层进度条自动消失，不必用户手动点「终止」。
  void _ensureMethodHandler() {
    if (_handlerSet) return;
    _handlerSet = true;
    _ch.setMethodCallHandler((MethodCall call) async {
      if (call.method != 'onComplete') return null;
      _watchdog?.cancel();
      final int? g = _playingGen;
      if (g == null || g != _gen) return null; // 迟到的回调：已经有新播放了，忽略
      _playingGen = null;
      _resetPlayingState(playing: false, fallback: false, label: null);
      notifyListeners();
      return null;
    });
  }

  /// 当前倍速（播放倍速语义，0.7/0.85/1.0）。
  ///
  /// 预生成音频是「慢速母带」（edge-tts -30% ≈ 0.7x）。原生端把
  /// `speed = 档位/0.7` 交给 MediaPlayer（只允许 >=1.0，见坑3），因此：
  /// 慢速 0.7 → speed 1.0（不调变速，最稳）；正常 0.85 → 1.21x；稍快 1.0 → 1.43x。
  double get _currentRate => AppState.instance.settings.speechRate;

  // ---------------- 公开 API ----------------

  /// 经 MethodChannel 播放 assets 下的音频文件。
  ///
  /// [assetRelPath] 是**完整的 Flutter asset key**，必须带 `assets/` 前缀，
  /// 例如 `assets/audio/char_0.mp3`（与 [kVoiceManifest] 的 value、以及
  /// `assets/images/chars/...` 这类图片路径的写法一致）。
  ///
  /// 🔴 踩过的坑：早期误以为这里要"去掉 `assets/`"，结果原生
  /// `getLookupKeyForAsset` 拼出的路径在 APK 里不存在，`assets.open` 抛异常，
  /// 2295 条音频**全部静默回落系统 TTS**（新声音等于没生效）。
  /// 规则：pubspec 里怎么声明，这里就怎么写——带 `assets/`。
  Future<void> playAsset(
    String assetRelPath, {
    double rate = 1.0,
    String? label,
  }) async {
    _ensureListening();
    _ensureMethodHandler();
    _watchdog?.cancel();
    final int gen = ++_gen; // 打断任何正在进行的系统 TTS 回落，防止其结束后误复位
    _playingGen = gen; // 记住这一轮，供原生 onComplete 回调比对
    _resetPlayingState(playing: true, fallback: false, label: label);
    notifyListeners();

    final double speed = rate <= 0.7 ? 1.0 : (rate / 0.7).clamp(1.0, 1.6);
    try {
      final Object? dur = await _ch.invokeMethod<Object?>(
        'play',
        <String, dynamic>{'asset': assetRelPath, 'speed': speed},
      );
      if (gen != _gen) return; // 等待期间已被 stop / 新一轮播放取代
      // native 成功（已开播）：拿到总时长，供浮层进度与看门狗使用
      _durationMs = dur is int ? dur : 0;
      _progress = 0.0;
      notifyListeners();
      _armWatchdog(gen, _durationMs);
    } on PlatformException {
      if (gen != _gen) return;
      // 预生成音频 native 失败：**不回落系统 TTS**（避免把必然失败的内容再撞一遍崩溃路径）。
      // 直接复位，让浮层消失（宁可没声，也不能闪退/卡死）。
      debugPrint('[VoicePlayer] 音频播放失败，已静默复位: $assetRelPath');
      _playingGen = null;
      _resetPlayingState(playing: false, fallback: false, label: null);
      notifyListeners();
    } on Object {
      if (gen != _gen) return;
      _playingGen = null;
      _resetPlayingState(playing: false, fallback: false, label: null);
      notifyListeners();
    }
  }

  /// 朗读一段汉字文本。
  ///
  /// 先查 [kVoiceManifest]（慢速，-30% 烤的母带）或 [kVoiceManifestNorm]（原速，+0%）：
  /// - **慢速档 (rate == 0.7)**：走慢速母带（assets/audio/）；
  /// - **正常/稍快档 (rate >= 0.85)**：走原速版（assets/audio_norm/），**不再依赖
  ///   MediaPlayer.setPlaybackParams 运行时倍速**（荣耀等 ROM 上 setPlaybackParams
  ///   可能不生效，导致"三档听起来一模一样"，v1.15 修复遗留）。
  /// 三档在资产层面就已物理拉开 0.7 vs 1.0 差距，母亲一定能听出差别。
  /// 未命中（两套 manifest 都没有）→ 回落系统 TTS（[TtsService.speakRaw]，净化+分块+超时）。
  ///
  /// [label] 为浮层显示用文案（如「拼音·玻」），缺省用文本本身。
  Future<void> playText(String text, {String? label}) async {
    final String disp = label ?? text;
    final double rate = _currentRate;
    // v1.16 语速档 → 资产双档：慢速档走慢速烤好的音频；其余档走原速版
    final String? asset =
        rate >= 0.85 ? kVoiceManifestNorm[text] : kVoiceManifest[text];
    if (asset != null) {
      // manifest 命中即走预生成音频；native 失败内部已静默复位，不再二次回落 TTS
      await playAsset(asset, rate: rate, label: disp);
      return;
    }
    await _fallbackSpeak(text, label: disp);
  }

  /// 系统 TTS 回落：flutter_tts 无进度，浮层显示「正在朗读」不确定态 + 仅终止按钮。
  Future<void> _fallbackSpeak(String text, {required String label}) async {
    _resetPlayingState(playing: true, fallback: true, label: label);
    notifyListeners();
    final int gen = ++_gen;
    try {
      await TtsService.instance.speakRaw(text, shouldStop: () => _gen != gen);
    } on Object {
      // 忽略：TTS 不可用已静默降级
    }
    // 朗读自然结束且未被新播放打断 → 复位
    if (_gen == gen) {
      _resetPlayingState(playing: false, fallback: false, label: null);
      notifyListeners();
    }
  }

  /// 看门狗：native 若迟迟不报完成（极个别文件解码异常等），超过「时长+2.5s」自动终止复位，
  /// 保证浮层进度条永不卡死。完成回调 / stop / 新一轮播放都会 cancel 它。
  void _armWatchdog(int gen, int durationMs) {
    _watchdog?.cancel();
    final int waitMs = (durationMs > 0 ? durationMs : 8000) + 2500;
    _watchdog = Timer(Duration(milliseconds: waitMs), () {
      if (_playingGen != gen || gen != _gen) return;
      if (!_isPlaying && !_isPaused) return;
      debugPrint('[VoicePlayer] 看门狗触发：播放未收到完成回调，自动复位');
      _playingGen = null;
      _resetPlayingState(playing: false, fallback: false, label: null);
      notifyListeners();
      // 同时让原生停干净（忽略失败）
      unawaited(_ch.invokeMethod<void>('stop').catchError((Object _) {}));
    });
  }

  Future<void> pause() async {
    if (_usingFallback) return; // 系统 TTS 暂停不可靠，按需求用 stop 代替
    try {
      await _ch.invokeMethod<void>('pause');
    } on Object {
      // 忽略
    }
    _isPaused = true;
    notifyListeners();
  }

  /// v1.16 浮层 stop 按钮调 [stop] 后追加调用本方法做**乐观 UI 更新**：
  /// 在异步 stop 流程走完前先把状态复位、notifyListeners，让浮层**立刻**消失，
  /// 母亲体感更流畅（不必等原生通道异步返回）。
  /// [stop] 完成时本方法已经被调用过一次，重复复位是幂等的（写同样值 + 再 notify 一次）。
  void hideImmediately() {
    _watchdog?.cancel();
    _playingGen = null;
    _resetPlayingState(playing: false, fallback: false, label: null);
    notifyListeners();
  }

  Future<void> resume() async {
    if (_usingFallback) return;
    try {
      await _ch.invokeMethod<void>('resume');
    } on Object {
      // 忽略
    }
    _isPaused = false;
    notifyListeners();
  }

  /// 终止：同时停掉音频通道与原生 TTS，并复位状态、通知浮层消失。
  ///
  /// ⚠️ v1.16 关键修复：本方法以前调 `TtsService.instance.stop()`，而后者又反向
  /// 调 `VoicePlayer.stop()`——**双向无限递归**，`StackOverflowError` 被 `try/catch`
  /// 吞掉 → `_resetPlayingState` 永远走不到 → 进度条永远卡死。
  /// 改法：直接调 `TtsService.stopEngineOnly()`（**只停引擎、不回调**）。
  /// `TtsService.stop()`（对外接口）则反过来委托本方法，循环被切断。
  /// 同时 `_gen++` 让任何正在进行的 fallback TTS 块朗读自动退出（`shouldStop()` 返回 true）。
  Future<void> stop() async {
    _watchdog?.cancel();
    _gen++; // 令进行中的音频轮次 / 系统 TTS 回落全部作废（回落循环会逐块检查退出）
    try {
      await _ch.invokeMethod<void>('stop');
    } on Object {
      // 忽略
    }
    // 停 TTS 引擎：走 stopEngineOnly 而非 stop()，绝不再回调本类（破除双向递归）。
    await TtsService.instance.stopEngineOnly();
    _playingGen = null;
    _resetPlayingState(playing: false, fallback: false, label: null);
    notifyListeners();
  }

  // ---------------- 内部工具 ----------------

  void _resetPlayingState({
    required bool playing,
    required bool fallback,
    required String? label,
  }) {
    _isPlaying = playing;
    _isPaused = false;
    _usingFallback = fallback;
    _progress = 0.0;
    _positionMs = 0;
    _durationMs = 0;
    _currentLabel = label;
  }
}

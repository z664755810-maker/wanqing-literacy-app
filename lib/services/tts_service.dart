import 'package:flutter_tts/flutter_tts.dart';

import '../data/char_library.dart';
import 'voice_player.dart';

/// 晚晴识字 · 朗读服务（系统 TTS，zh-CN，慢速）。
///
/// 🔴🔴 **TTS 铁律（用户亲历的坑，最高优先级）**
/// 1. **只能传真实汉字/词/句**。绝对禁止传拼音字母 ——
///    `fàn`、`fan`、`bō` 会被系统 TTS 当英文念，用户原话「发音全错」。
/// 2. `CharCard.pinyin` **只能用于 `Text` 渲染**，禁止出现在任何 TTS 调用链上。
/// 3. 进 TTS 的文本统一先经 [_sanitizeForTts]（[speakRaw] 内）：剥掉拉丁字母与
///    可疑符号兜底（宁可少念，也不能念成英文），再按句分块、逐块超时朗读。
/// 4. 朗读单字用**三段式**：`speakChar('饭')` → 实际念「饭，米饭，饭」（字 → 词 → 字）。
/// 5. 语速现为**播放倍速语义**：默认 0.7，设置页三档 0.7 / 0.85 / 1.0（慢速 / 正常 / 稍快）。
///    预生成音频是慢速母带，原生端以 `speed=档位/0.7`（>=1.0）提速（坑3：<1.0 会崩，见 VoicePlayer）；
///    系统 TTS 回落路径以 [setSpeechRate] 内 `clamp(0.35, 0.9)` 近似生效。
/// 6. `speak` 经 [VoicePlayer] 全局路由：有预生成音频播音频，否则回落本类 `speakRaw`。
/// 7. 允许无限次重复朗读，但每次都要先 `stop()` 再 `speak`。
class TtsService {
  TtsService._();

  static final TtsService instance = TtsService._();

  final FlutterTts _tts = FlutterTts();

  double _speechRate = 0.3;

  /// 当前语速
  double get speechRate => _speechRate;

  /// 是否已初始化
  bool _inited = false;

  bool get isReady => _inited;

  /// 初始化：固定 zh-CN + 慢速 + 等待朗读完成。
  /// 失败不抛异常（部分设备无 TTS 引擎），只降级为「静音」，UI 不受影响。
  Future<void> init({double speechRate = 0.3}) async {
    // 回落倍速压慢一档（×0.7），与「预生成慢速音频」听感一致，避免回落句忽然变快听不清。
    _speechRate = (speechRate * 0.7).clamp(0.35, 0.9);
    try {
      await _tts.setLanguage('zh-CN');
      await _tts.setSpeechRate(_speechRate);
      await _tts.setPitch(1.0);
      await _tts.setVolume(1.0);
      await _tts.awaitSpeakCompletion(true);

      // 挑一个中文嗓音：先把本机嗓音去重、择优，取排序最优（普通话/zh-CN 优先）的那一条，
      // **只 setVoice 一次**。避免旧实现「边遍历边 setVoice」反复切换引擎、拖慢冷启动，
      // 并根除「无论点哪个嗓音、实际都播同一个」的观感。
      try {
        final List<_ZhVoice> vs = await _loadDedupedVoices();
        if (vs.isNotEmpty) await _tts.setVoice(vs.first.orig);
      } catch (_) {
        // 忽略：用默认嗓音
      }
      _inited = true;
    } catch (_) {
      _inited = false;
    }
  }

  /// 列出本机可用的**中文**嗓音（已去重、带人话标签），供设置页挑选。
  ///
  /// 返回每一项含 `key`（稳定标识，存进 `settings.ttsVoice`）、`label`（人话标签）、
  /// `name` / `locale`（原始值，仅供调试）。
  ///
  /// 🔴 `getVoices` 是 **getter**（非方法），必须 `(await _tts.getVoices) as List`，
  /// 否则会把 Future 当 List 强转抛异常（v1.7 的坑）。拿不到就返回空表。
  Future<List<Map<String, String>>> getZhVoices() async {
    final List<_ZhVoice> vs = await _loadDedupedVoices();
    return vs.map((_ZhVoice v) => <String, String>{
          'key': v.key,
          'label': v.label,
          'name': v.name,
          'locale': v.locale,
        }).toList();
  }

  /// 应用指定的中文嗓音。
  ///
  /// - [name] 为 null → 自动挑去重后排序最优的中文嗓音（回落系统默认，「自动（推荐）」态）。
  /// - [name] 非空 → 在**去重后的列表**里按 `key` 精确匹配并 `setVoice`。
  ///   匹配失败（系统升级 / 换引擎 / 语音包被清，存下的 key 失效）→ 回退到自动，绝不卡死。
  /// 失败静默降级，绝不抛异常（部分设备无 TTS 引擎）。
  Future<void> applyVoice(String? name) async {
    try {
      final List<_ZhVoice> list = await _loadDedupedVoices();
      _ZhVoice? chosen;
      if (name != null) {
        for (final _ZhVoice v in list) {
          if (v.key == name) {
            chosen = v;
            break;
          }
        }
      }
      // 匹配失败或选「自动」→ 回落去重后排序最优的那条（= 自动挑本机最优）
      chosen ??= list.isNotEmpty ? list.first : null;
      if (chosen != null) await _tts.setVoice(chosen.orig);
    } catch (_) {
      // 忽略：用默认嗓音
    }
  }

  /// 本机嗓音去重流水线：宽进过滤 → 归一化 key → 同 key 择优 → 排序输出。
  ///
  /// 解决「同一中文嗓音被 Android TTS 以多个 locale/name 变体重复上报，
  /// 列表看着 4 个选项、实则同一种声音」的无效重复。
  Future<List<_ZhVoice>> _loadDedupedVoices() async {
    try {
      final List<dynamic> voices = (await _tts.getVoices) as List<dynamic>;
      final Map<String, _ZhVoice> byKey = <String, _ZhVoice>{};
      int order = 0;
      for (final dynamic v in voices) {
        if (v is! Map) continue;
        final Map<String, String> m = Map<String, String>.from(v.cast<String, String>());
        final String localeRaw = (m['locale'] ?? '').toString().toLowerCase();
        final String firstSub = localeRaw.split(RegExp(r'[_-]')).first;
        // ① 宽进过滤：zh 或 cmn（普通话 ISO 639-3），或显式含 chinese 的写法
        if (firstSub != 'zh' && firstSub != 'cmn' && !localeRaw.contains('chinese')) {
          continue;
        }
        final String nameRaw = (m['name'] ?? '').toString();
        final String normName = nameRaw.trim().toLowerCase().replaceAll(RegExp(r'\s+'), '');
        final String normLocale = _normRegionLocale(localeRaw, nameRaw);
        // ② 归一化 key：name 等于 locale 似值（如 zh-cn / cmn-hans-cn）→ 记 #generic
        final bool isLocaleLike = RegExp(r'^(zh|cmn)[-_]').hasMatch(normName);
        final bool isGeneric = normName == normLocale || isLocaleLike;
        final String nameKey = isGeneric ? '#generic' : normName;
        final String key = '$nameKey|$normLocale';
        final int score = _voiceNameScore(nameRaw);
        final bool isCn = normLocale == 'zh-cn';
        final _ZhVoice cand = _ZhVoice(
          key: key,
          label: _voiceLabel(nameRaw, normLocale, isGeneric),
          name: nameRaw,
          locale: (m['locale'] ?? '').toString(),
          orig: m,
          isCn: isCn,
          isGeneric: isGeneric,
          score: score,
          order: order,
        );
        // ③ 同 key 择优：zh-CN 优先 > 名称含普通话/中文/Chinese > 上报靠前
        final _ZhVoice? prev = byKey[key];
        if (prev == null || _voiceIsBetter(cand, prev)) byKey[key] = cand;
        order++;
      }
      // ④ 排序输出：普通话(zh-CN) → 其它 zh 变体 → #generic
      final List<_ZhVoice> list = byKey.values.toList();
      list.sort((_ZhVoice a, _ZhVoice b) {
        final int pa = a.isCn ? 0 : (a.isGeneric ? 2 : 1);
        final int pb = b.isCn ? 0 : (b.isGeneric ? 2 : 1);
        if (pa != pb) return pa.compareTo(pb);
        if (a.score != b.score) return b.score.compareTo(a.score);
        return a.order.compareTo(b.order);
      });
      // 标签去重：去重后仍撞名（两个引擎都叫「中文」）→ 追加序号，绝不两个一模一样
      final Map<String, int> seen = <String, int>{};
      final List<_ZhVoice> out = <_ZhVoice>[];
      for (final _ZhVoice r in list) {
        String label = r.label;
        final int n = (seen[label] ?? 0) + 1;
        seen[label] = n;
        if (n > 1) label = '$label $n';
        out.add(_ZhVoice(
          key: r.key,
          label: label,
          name: r.name,
          locale: r.locale,
          orig: r.orig,
          isCn: r.isCn,
          isGeneric: r.isGeneric,
          score: r.score,
          order: r.order,
        ));
      }
      return out;
    } catch (_) {
      return <_ZhVoice>[];
    }
  }

  /// 调整语速（设置页倍速档：0.7 / 0.85 / 1.0）。
  ///
  /// 只作用于**系统 TTS 回落路径**（flutter_tts）：乘 0.7 并 `clamp(0.35, 0.9)`，
  /// 使回落内容与预生成慢速音频听感一致。预生成音频的变速在原生 MediaPlayer 端
  /// 用 `speed=档位/0.7`（>=1.0）实现（见 [VoicePlayer]）。
  Future<void> setSpeechRate(double rate) async {
    // 与 init 同步：回落倍速压慢一档（×0.7），上限 0.9 兜底，保证「慢得能听清」。
    _speechRate = (rate * 0.7).clamp(0.35, 0.9);
    try {
      await _tts.setSpeechRate(_speechRate);
    } catch (_) {
      // 忽略
    }
  }

  /// 朗读任意中文文本（词或句子）。
  ///
  /// 🔴 全局路由点：委托给 [VoicePlayer.instance.playText]，实现「换新声」全局覆盖
  /// ——有预生成音频播音频（带倍速），否则回落本类 [speakRaw]（系统 TTS）。
  /// 因此其它界面只要调 `TtsService.instance.speak(...)` 就自动走新通道，无需逐页改。
  Future<void> speak(String text) => VoicePlayer.instance.playText(text);

  /// 底层朗读（只走系统 TTS，不再二次路由，避免与 [VoicePlayer] 形成死循环）。
  ///
  /// 供 [VoicePlayer] 缺音频时回落使用。预生成音频已烤进慢速（≈0.7x），
  /// 这里把系统 TTS 回落倍速再压慢一档，使「没生成音频的少数文本」听起来和慢速音频一致。
  ///
  /// v1.15 起自带三层防护（解决「长文本/冷僻文本回落系统 TTS 时闪退/卡死」）：
  /// 1. **净化**：只保留汉字/数字/常用中文标点，剔除任何拉丁字母（TTS 铁律）与
  ///    可疑符号（部分引擎遇罕见字符会 native 崩溃）；
  /// 2. **分块**：按句末标点或 34 字上限切块逐块朗读——长文本（如故事整章）绝不
  ///    一次性整段塞给引擎（超长文本是 flutter_tts native 崩溃的高发诱因）；
  /// 3. **每块超时**：单块 12s 内必须返回，引擎"哑火"时不会让浮层永久卡在朗读态。
  ///
  /// [shouldStop]：朗读中途用户点了终止/切走时返回 true，逐块检查后立刻安静退出。
  Future<void> speakRaw(String text, {bool Function()? shouldStop}) async {
    final String cleaned = _sanitizeForTts(text);
    if (cleaned.isEmpty) return;
    final List<String> chunks = _chunkForTts(cleaned);
    for (final String chunk in chunks) {
      if (shouldStop != null && shouldStop()) return; // 用户已终止，立刻安静退出
      final String t = chunk.trim();
      if (t.isEmpty) continue;
      try {
        await _tts.stop();
        await _tts.speak('，$t。').timeout(const Duration(seconds: 12), onTimeout: () {
          // 引擎未在期限内返回：忽略本块继续（宁可少念，也不让调用方永久等待）
          return 1;
        });
      } catch (_) {
        // 单块失败也继续下一块，绝不抛出——TTS 不可用时静默降级，绝不让 UI 崩
      }
    }
  }

  /// TTS 净化：只留汉字/数字/常用中文标点/常见符号/空白。
  /// 拉丁字母一律剔除（拼音绝不进 TTS，这是项目铁律）。
  static final RegExp _ttsLatin = RegExp(r'[A-Za-z]');
  static final RegExp _ttsDisallowed = RegExp(
      r'[^\u4e00-\u9fff0-9，。！？、；：“”‘’《》（）…·—\s\-]');

  String _sanitizeForTts(String raw) {
    String s = raw;
    s = s.replaceAll(_ttsLatin, '');
    s = s.replaceAll(_ttsDisallowed, '');
    s = s.replaceAll(RegExp(r'\s+'), ' ');
    return s.trim();
  }

  /// 分块：句末标点（≥12 字）处优先断块；无标点则每 34 字强制切块。
  List<String> _chunkForTts(String cleaned) {
    final List<String> out = <String>[];
    final StringBuffer buf = StringBuffer();
    for (final String ch in cleaned.split('')) {
      buf.write(ch);
      final int len = buf.length;
      if (len >= 12 && '。！？；\n'.contains(ch)) {
        out.add(buf.toString().trim());
        buf.clear();
      } else if (len >= 34) {
        out.add(buf.toString().trim());
        buf.clear();
      }
    }
    if (buf.isNotEmpty) out.add(buf.toString().trim());
    return out.where((String s) => s.isNotEmpty).toList();
  }

  /// 朗读一个词
  Future<void> speakWord(String word) => VoicePlayer.instance.playText(word);

  /// 朗读一句话
  Future<void> speakSentence(String sentence) => VoicePlayer.instance.playText(sentence);

  /// 朗读单字（三段式：「饭，米饭，饭」）。
  ///
  /// [word] 不传时自动取字库里的首选常用词；字库里没有就只念单字。
  Future<void> speakChar(String char, {String? word}) async {
    final String w = word ?? cardOf(char)?.firstWord ?? char;
    final String text = w == char ? char : '$char，$w，$char';
    await VoicePlayer.instance.playText(text);
  }

  // 笔画名不再朗读（v1.14 起改为「笔顺演示」可视化，见 StrokeOrderDemo），此路由已移除。

  /// 公开 stop：单一入口，**全部走 [VoicePlayer.stop]** 协调（原生通道 + TTS 引擎一起停）。
  ///
  /// ⚠️ v1.16 关键修复：本方法以前是直接 `_tts.stop()` + 调 `VoicePlayer.stop()`，
  /// 而 `VoicePlayer.stop()` 又回调 `TtsService.stop()`——**双向无限递归**，
  /// `StackOverflowError` 被 `on Object` 默默吞掉 → `_resetPlayingState` 永远走不到
  /// → 进度条永远卡死。这是用户报告"红色终止键卡进度条"的真根因。
  /// 改法：把"对外"和"对内"严格分离——
  /// - [stop]（本方法）只做"路由"：转给 VoicePlayer.stop（单一权威入口）。
  /// - [stopEngineOnly] 仅停本机 TTS 引擎；由 VoicePlayer.stop 内部直接调用。
  /// 这样消除了循环：VoicePlayer.stop → stopEngineOnly（不回调）→ 完。
  Future<void> stop() => VoicePlayer.instance.stop();

  /// 内部停 TTS 引擎。**只**供 [VoicePlayer.stop] 调用，绝不反向回调。
  ///
  /// 这是拆解 `VoicePlayer.stop ↔ TtsService.stop` 双向递归的关键：
  /// 调用方拿到保证——本方法不会触发任何 [VoicePlayer] 的回调，永远同步返回（除引擎异步 stop）。
  Future<void> stopEngineOnly() async {
    try {
      await _tts.stop();
    } catch (_) {
      // 忽略：TTS 不可用已静默降级
    }
  }
}

/// 去重后的一条中文嗓音：携带稳定 key（存进设置）、人话 label、以及原始 voice 用于 setVoice。
class _ZhVoice {
  final String key;
  final String label;
  final String name;
  final String locale;
  final Map<String, String> orig;
  final bool isCn;
  final bool isGeneric;
  final int score;
  final int order;
  const _ZhVoice({
    required this.key,
    required this.label,
    required this.name,
    required this.locale,
    required this.orig,
    required this.isCn,
    required this.isGeneric,
    required this.score,
    required this.order,
  });
}

/// 把 locale 归一化为 zh-CN / zh-TW / zh-HK / zh-SG 四档之一（其它兜底 zh-CN）。
String _normRegionLocale(String localeRaw, String nameRaw) {
  final List<String> parts = localeRaw.split(RegExp(r'[_-]'));
  String lang = parts.first;
  if (lang == 'cmn') lang = 'zh';
  String region = parts.length > 1 ? parts[1].toUpperCase() : '';
  if (region.isEmpty) {
    if (nameRaw.contains('台灣') || nameRaw.contains('台湾') || nameRaw.contains('TW')) {
      region = 'TW';
    } else if (nameRaw.contains('HK') || nameRaw.contains('香港')) {
      region = 'HK';
    } else if (nameRaw.contains('SG') || nameRaw.contains('新加坡')) {
      region = 'SG';
    } else {
      region = 'CN';
    }
  }
  if (!const <String>['CN', 'TW', 'HK', 'SG'].contains(region)) region = 'CN';
  return 'zh-$region';
}

/// name 含关键词时的优先级分（越高越优先）。
int _voiceNameScore(String nameRaw) {
  if (nameRaw.contains('普通话')) return 4;
  if (nameRaw.contains('中文')) return 3;
  if (nameRaw.toLowerCase().contains('chinese')) return 2;
  return 1;
}

/// 两条同为同 key 候选时，返回 [a] 是否比 [b] 更优（zh-CN 优先 > 名称分高 > 上报靠前）。
bool _voiceIsBetter(_ZhVoice a, _ZhVoice b) {
  if (a.isCn != b.isCn) return a.isCn;
  if (a.score != b.score) return a.score > b.score;
  return a.order < b.order;
}

/// 把引擎机器名翻译成母亲看得懂的标签。
String _voiceLabel(String nameRaw, String normLocale, bool isGeneric) {
  final String lower = nameRaw.toLowerCase();
  if (nameRaw.contains('普通话') && normLocale == 'zh-cn') return '普通话';
  if (normLocale == 'zh-tw' ||
      nameRaw.contains('台灣') ||
      nameRaw.contains('台湾')) {
    return '中文（台湾腔）';
  }
  if (normLocale == 'zh-hk' ||
      nameRaw.contains('粵') ||
      nameRaw.contains('粤') ||
      nameRaw.contains('廣東') ||
      nameRaw.contains('广东')) {
    return '中文（粤语）';
  }
  if (nameRaw.contains('中文') || lower.contains('chinese')) return '中文';
  if (isGeneric) return '系统嗓音';
  // 兜底：原样显示引擎自定义名，超长截断 + 省略号（不臆造翻译）
  String s = nameRaw.trim();
  if (s.length > 12) s = '${s.substring(0, 12)}…';
  return s;
}

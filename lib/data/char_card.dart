/// 晚晴识字 · 数据模型：汉字卡 / 课程 / 生活短句。
///
/// 静态内容用 Dart `const` 字面量（编译期可校验），只有笔顺走 `assets/strokes.json`。
///
/// 🔴 铁律：[CharCard.pinyin] **只能进 `Text` 组件**，禁止出现在任何 TTS 调用链上
/// （`fàn` 这类拼音会被系统 TTS 当英文念，用户亲历的坑）。

library;

/// 汉字卡：学习的最小单元
class CharCard {
  /// 汉字本身，如 '饭'
  final String char;

  /// 拼音（带调号），如 'fàn' —— **仅展示**，永不送 TTS
  final String pinyin;

  /// 字义解释，如 '煮熟的谷类食物'
  final String meaning;

  /// 常用词（真实汉字），TTS 只念这个，如 ['米饭', '吃饭']
  final List<String> words;

  /// 生活例句，如 '我吃饭。'
  final String sentence;

  /// 配图文件名，如 'fan.webp'；null = 无图（UI 走文字卡兜底，绝不显示空图位）
  final String? picFile;

  /// 笔画名称，如 ['撇', '横撇', '竖提', ...]（笔顺数据缺失时的降级内容）
  final List<String> strokeNames;

  /// 所属课号（1 起）
  final int lessonId;

  /// 分类，如 '饮食'
  final String category;

  const CharCard({
    required this.char,
    required this.pinyin,
    required this.meaning,
    required this.words,
    required this.sentence,
    this.picFile,
    required this.strokeNames,
    required this.lessonId,
    required this.category,
  });

  /// 是否配了图（无图时 UI 显示「实物词 + 释义 + 例句」文字卡兜底）
  bool get hasPic => picFile != null && picFile!.isNotEmpty;

  /// 配图的 asset 路径（无图返回 null）
  String? get picPath => hasPic ? 'assets/images/chars/$picFile' : null;

  /// 首选常用词（TTS 三段式中间那一段）；无词库时退回单字
  String get firstWord => words.isEmpty ? char : words.first;

  /// 笔画数
  int get strokeCount => strokeNames.length;

  factory CharCard.fromJson(Map<String, dynamic> j) => CharCard(
        char: j['char'] as String,
        pinyin: j['pinyin'] as String? ?? '',
        meaning: j['meaning'] as String? ?? '',
        words: (j['words'] as List<dynamic>? ?? const <dynamic>[])
            .map((dynamic e) => e.toString())
            .toList(),
        sentence: j['sentence'] as String? ?? '',
        picFile: j['picFile'] as String?,
        strokeNames: (j['strokeNames'] as List<dynamic>? ?? const <dynamic>[])
            .map((dynamic e) => e.toString())
            .toList(),
        lessonId: j['lessonId'] as int? ?? 0,
        category: j['category'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'char': char,
        'pinyin': pinyin,
        'meaning': meaning,
        'words': words,
        'sentence': sentence,
        'picFile': picFile,
        'strokeNames': strokeNames,
        'lessonId': lessonId,
        'category': category,
      };

  @override
  String toString() => 'CharCard($char, L$lessonId)';
}

// 注：Lesson 的权威定义见 lib/data/lessons.dart，Sentence 见 lib/data/sentences.dart，
// 此处不再重复声明，避免同一包内「类名重复定义」导致编译失败。

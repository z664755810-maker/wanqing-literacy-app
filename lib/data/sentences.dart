import 'char_library.dart';

/// 生活短句：每条由字库里的 `sentence` 字段衍生，保证「只含已学字」天然成立
/// （短句里的字就是它自己那一课的字，已随该课解锁）。
class Sentence {
  final String text; // '我们回家。'
  final List<String> chars; // ['我','们','回','家']
  final int minLesson; // = 句中最大课号，运行时再校验一次

  const Sentence({required this.text, required this.chars, required this.minLesson});

  /// 是否全部由 [learned] 中的字组成（短句铁律：绝不出现生字）。
  bool coveredBy(Set<String> learned) => chars.every(learned.contains);
}

List<Sentence> _buildSentences() {
  final List<Sentence> out = <Sentence>[];
  for (final CharCard card in kCharLibrary.values) {
    if (card.sentence.isEmpty) continue;
    final List<String> chars = card.sentence.runes
        .map((int r) => String.fromCharCode(r))
        .where((String ch) => kCharLibrary.containsKey(ch))
        .toList();
    if (chars.isEmpty) continue;
    out.add(Sentence(text: card.sentence, chars: chars, minLesson: card.lessonId));
  }
  return out;
}

/// 全部短句（已按字库顺序）。
final List<Sentence> kSentences = _buildSentences();

/// 只返回「完全由已学字组成」的短句，按课号升序。
List<Sentence> readableSentences(Set<String> learned) =>
    kSentences.where((Sentence s) => s.coveredBy(learned)).toList();

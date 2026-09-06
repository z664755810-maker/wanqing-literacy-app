import 'char_library.dart';

/// 课程：按课号聚合字库里的字。顺序即解锁顺序（第 1 课最先学）。
///
/// 直接由 [kCharLibrary] 按 `lessonId` 分组生成，避免两份数据源不同步。
class Lesson {
  final int id; // 1 起
  final String title;
  final List<String> chars; // 2–3 个字

  const Lesson({required this.id, required this.title, required this.chars});
}

List<Lesson> _buildLessons() {
  final Map<int, List<String>> byLesson = <int, List<String>>{};
  for (final CharCard card in kCharLibrary.values) {
    byLesson.putIfAbsent(card.lessonId, () => <String>[]).add(card.char);
  }
  final List<int> ids = byLesson.keys.toList()..sort();
  return <Lesson>[
    for (final int id in ids)
      Lesson(id: id, title: '第 $id 课', chars: byLesson[id]!),
  ];
}

/// 全部课程（顺序即解锁顺序）。
final List<Lesson> kLessons = _buildLessons();

/// 取某一课；越界返回第 1 课。
Lesson lessonOf(int id) =>
    kLessons.firstWhere((Lesson l) => l.id == id, orElse: () => kLessons.first);

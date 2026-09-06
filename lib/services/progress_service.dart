import 'store.dart';

/// 单个字的学习进度。
///
/// `stage` 含义：0=当天新学，1/2/3/4 对应下次复习间隔 +1/+3/+7/+30 天；
/// `stage>=4` 即「毕业（熟字）」，不再进到期队列，只在复习专区可手动复盘。
class ProgressEntry {
  final String char;
  final String firstLearnedDay; // 'yyyy-MM-dd'
  final String lastReviewDay; // 'yyyy-MM-dd'
  final int stage;
  final int reviewCount;
  final int lapses; // 复习答错次数：只用于降 stage，不展示给用户

  const ProgressEntry({
    required this.char,
    required this.firstLearnedDay,
    required this.lastReviewDay,
    this.stage = 0,
    this.reviewCount = 0,
    this.lapses = 0,
  });

  bool get isGraduated => stage >= 4;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'char': char,
        'f': firstLearnedDay,
        'l': lastReviewDay,
        's': stage,
        'r': reviewCount,
        'p': lapses,
      };

  static ProgressEntry fromJson(Map<String, dynamic> j) => ProgressEntry(
        char: j['char'] as String,
        firstLearnedDay: j['f'] as String,
        lastReviewDay: j['l'] as String,
        stage: (j['s'] as num? ?? 0).toInt(),
        reviewCount: (j['r'] as num? ?? 0).toInt(),
        lapses: (j['p'] as num? ?? 0).toInt(),
      );
}

/// 学习进度：已学字集合、解锁课号、今日新学、重置、落盘。
///
/// 所有持久化都走 [Store]（SharedPreferences，wq_progress_v1）。
class ProgressService {
  final Map<String, ProgressEntry> _entries = <String, ProgressEntry>{};
  int _unlockedLesson = 1;

  int get unlockedLesson => _unlockedLesson;

  int get learnedCount => _entries.length;

  Set<String> get learnedChars => _entries.keys.toSet();

  Iterable<ProgressEntry> get entries => _entries.values;

  bool isLearned(String c) => _entries.containsKey(c);

  /// 今天首次学会的字数（用于首页「今日新学」）。
  int get todayNewCount {
    final String today = Store.today();
    int n = 0;
    for (final ProgressEntry e in _entries.values) {
      if (e.firstLearnedDay == today) n++;
    }
    return n;
  }

  /// 标记学会了某个字（幂等）。首次学会才写入 firstLearnedDay。
  Future<void> markLearned(String c) async {
    final String today = Store.today();
    _entries[c] = ProgressEntry(
      char: c,
      firstLearnedDay: _entries[c]?.firstLearnedDay ?? today,
      lastReviewDay: today,
      stage: _entries[c]?.stage ?? 0,
    );
    await persist();
  }

  /// 解锁到某课（只进不退）。
  Future<void> advanceLesson(int lessonId) async {
    if (lessonId > _unlockedLesson) _unlockedLesson = lessonId;
    await persist();
  }

  /// 复习结果回写：答对升一档（封顶 4），答错回到 1（不回 0、不惩罚）。
  Future<void> recordReview(String c, bool ok) async {
    final ProgressEntry? e = _entries[c];
    if (e == null) return;
    final int nextStage = ok
        ? (e.stage + 1).clamp(0, 4)
        : 1;
    _entries[c] = ProgressEntry(
      char: c,
      firstLearnedDay: e.firstLearnedDay,
      lastReviewDay: Store.today(),
      stage: nextStage,
      reviewCount: e.reviewCount + 1,
      lapses: ok ? e.lapses : e.lapses + 1,
    );
    await persist();
  }

  Future<void> resetAll() async {
    _entries.clear();
    _unlockedLesson = 1;
    await Store.clearProgress();
  }

  void load() {
    final Map<String, dynamic>? j = Store.getJson(Store.kProgress);
    if (j == null) return;
    _unlockedLesson = (j['unlockedLesson'] as num? ?? 1).toInt();
    final Map<String, dynamic>? entries = j['entries'] as Map<String, dynamic>?;
    if (entries != null) {
      entries.forEach((String k, dynamic v) {
        if (v is Map<String, dynamic>) _entries[k] = ProgressEntry.fromJson(v);
      });
    }
  }

  Future<void> persist() async {
    final Map<String, dynamic> payload = <String, dynamic>{
      'unlockedLesson': _unlockedLesson,
      'entries': <String, dynamic>{
        for (final ProgressEntry e in _entries.values) e.char: e.toJson(),
      },
    };
    await Store.setJson(Store.kProgress, payload);
  }
}

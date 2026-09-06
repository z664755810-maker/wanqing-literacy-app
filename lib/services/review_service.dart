import 'store.dart';
import 'progress_service.dart';

/// 智能复习调度：遗忘曲线 1 / 3 / 7 / 30 天四档。
///
/// - 到期队列：stage<4 且 (lastReviewDay + intervals[stage]) <= 今天。
/// - 排序：越生疏越前（stage 升）→ 越久没复习越前（lastReviewDay 升）。
/// - 全部静态方法，读写都通过 [ProgressService]，不直接碰 Store。
class ReviewService {
  static const List<int> intervals = <int>[1, 3, 7, 30]; // 对应 stage 0..3

  /// 今天该复习的字（不限数量，用于首页到期数）。
  static List<String> dueToday(ProgressService p) {
    final String today = Store.today();
    final List<String> out = <String>[];
    for (final ProgressEntry e in p.entries) {
      if (e.stage >= 4) continue;
      final int? gap = Store.daysBetween(today, e.lastReviewDay);
      if (gap == null) continue;
      if (gap >= intervals[e.stage]) out.add(e.char);
    }
    return out;
  }

  /// 今天要复习的队列（生疏优先，限 [limit] 个），供复习页展示。
  static List<String> buildQueue(ProgressService p, {int limit = 20}) {
    final List<ProgressEntry> due = <ProgressEntry>[
      for (final String c in dueToday(p)) p.entries.firstWhere((ProgressEntry e) => e.char == c),
    ];
    due.sort((ProgressEntry a, ProgressEntry b) {
      if (a.stage != b.stage) return a.stage.compareTo(b.stage);
      return a.lastReviewDay.compareTo(b.lastReviewDay);
    });
    return due.take(limit).map((ProgressEntry e) => e.char).toList();
  }

  /// 复习专区：全部已学字（含毕业熟字），供手动复盘。
  static List<String> manualPool(ProgressService p) {
    final List<ProgressEntry> all = p.entries.toList()
      ..sort((ProgressEntry a, ProgressEntry b) {
        if (a.stage != b.stage) return a.stage.compareTo(b.stage);
        return a.lastReviewDay.compareTo(b.lastReviewDay);
      });
    return all.map((ProgressEntry e) => e.char).toList();
  }

  /// 记录一次复习结果：答对升档、答错回 1。
  static Future<void> recordResult(String c, bool ok, ProgressService p) async {
    await p.recordReview(c, ok);
  }
}

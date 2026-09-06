import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// 晚晴识字 · 本地存储底层封装（只做读写，不含任何业务逻辑）。
///
/// 约定：
/// - key 统一前缀 `wq_` + 版本号（如 `wq_progress_v1`），便于重置与迁移；
/// - 日期一律存 `yyyy-MM-dd` **本地日期字符串**，不存 DateTime（避免时区/序列化歧义）；
/// - 全部数据只在平板本地，无后端、无网络上报。
class Store {
  Store._();

  static SharedPreferences? _sp;

  // ---------- 存储 key（版本化）----------
  /// 学习进度：{"unlockedLesson":3,"entries":{"饭":{...}}}
  static const String kProgress = 'wq_progress_v1';

  /// 应用设置：{"fontScale":1.3,"speechRate":0.3,...}
  static const String kSettings = 'wq_settings_v1';

  /// 日期统计：{"lastDay":"2026-08-31","streak":5,"todayNew":2}
  static const String kDay = 'wq_day_v1';

  /// 自标生字（「我圈的字」）：{"v":1,"chars":["悟","吒",...]}
  /// 与进度/设置/日期统计并列，独立 key 互不影响；重置进度不连坐清除。
  static const String kMarks = 'wq_marks_v1';

  /// 是否已初始化
  static bool get ready => _sp != null;

  static Future<void> init() async {
    _sp ??= await SharedPreferences.getInstance();
  }

  // ---------- 基础读写 ----------
  static String? getString(String k) => _sp?.getString(k);

  static Future<void> setString(String k, String v) => _sp!.setString(k, v);

  static int getInt(String k, [int def = 0]) => _sp?.getInt(k) ?? def;

  static Future<void> setInt(String k, int v) => _sp!.setInt(k, v);

  static bool getBool(String k, [bool def = false]) => _sp?.getBool(k) ?? def;

  static Future<void> setBool(String k, bool v) => _sp!.setBool(k, v);

  static Future<void> remove(String k) => _sp!.remove(k);

  /// 读取一个 JSON 对象；不存在或损坏时返回 null（绝不抛异常）
  static Map<String, dynamic>? getJson(String k) {
    final String? raw = getString(k);
    if (raw == null || raw.isEmpty) return null;
    try {
      final Object? decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) return decoded;
      return null;
    } catch (_) {
      return null;
    }
  }

  static Future<void> setJson(String k, Map<String, dynamic> v) =>
      setString(k, jsonEncode(v));

  /// 清空全部业务数据（保留设置）
  static Future<void> clearProgress() async {
    await remove(kProgress);
    await remove(kDay);
  }

  /// 清空所有（含设置），仅在调试时使用
  static Future<void> clearAll() async {
    await remove(kProgress);
    await remove(kSettings);
    await remove(kDay);
  }

  // ---------- 日期工具 ----------
  /// 今天的本地日期字符串 `yyyy-MM-dd`
  static String today() => dayStr(DateTime.now());

  /// 格式化为 `yyyy-MM-dd`（本地日期，不用 UTC）
  static String dayStr(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  /// 解析 `yyyy-MM-dd`；失败返回 null（绝不抛异常）
  static DateTime? parseDay(String? s) {
    if (s == null || s.length < 8) return null;
    final List<String> parts = s.split('-');
    if (parts.length < 3) return null;
    final int? y = int.tryParse(parts[0]);
    final int? m = int.tryParse(parts[1]);
    final int? d = int.tryParse(parts[2]);
    if (y == null || m == null || d == null) return null;
    return DateTime(y, m, d);
  }

  /// 两个日期字符串之间相差的天数（a - b）；解析失败返回 null
  static int? daysBetween(String a, String b) {
    final DateTime? da = parseDay(a);
    final DateTime? db = parseDay(b);
    if (da == null || db == null) return null;
    return da.difference(db).inDays;
  }
}

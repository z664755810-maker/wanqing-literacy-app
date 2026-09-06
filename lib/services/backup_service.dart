import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';

import 'store.dart';

/// 进度快照：把 3 个业务 key 汇总成一个可转移的 JSON 字符串，靠系统剪贴板搬移。
///
/// 设计取舍（重要）：
/// - 项目红线是「禁止新增任何 pub 依赖」，所以**不用** `path_provider` / `share_plus` / `archive`。
/// - 备份可二选一：① 复制到剪贴板（老方案，贴到微信/备忘录/文件里保存）；
///   ② **导出到手机文件**（新方案，写进应用外置目录，用文件管理/USB 找到后发微信）。
/// - 写文件用 `MethodChannel` 向原生要目录（`getExternalFilesDir`），**不加任何 pub 依赖**；
///   目录是应用私有的 `Android/data/com.wanqing.shizi/files/`，无需存储权限，用户用 USB/文件管理可取到。
/// - 纯离线，零网络。若以后要做「系统分享一键发」，才需要加 `share_plus` 破红线，届时需用户拍板。
class BackupService {
  static const String _envelopeVersion = '1';
  static const String kApp = 'app';
  static const String kVersion = 'version';
  static const String kExportedAt = 'exportedAt';

  /// 与原生约定的通道名（见 android/.../MainActivity.kt）。
  static const String _channelName = 'wanqing/backup';

  /// 汇总当前业务 key（进度 / 设置 / 日期统计 / 自标生字）成一段紧凑 JSON。
  /// 任何一个 key 为空也照样导出（对应字段为 null，恢复时跳过）。
  static String exportSnapshot() {
    final Map<String, dynamic> snap = <String, dynamic>{
      kApp: 'wanqing_shizi',
      kVersion: _envelopeVersion,
      kExportedAt: Store.today(),
      Store.kProgress: Store.getJson(Store.kProgress),
      Store.kSettings: Store.getJson(Store.kSettings),
      Store.kDay: Store.getJson(Store.kDay),
      Store.kMarks: Store.getJson(Store.kMarks),
    };
    return jsonEncode(snap);
  }

  /// 从快照字符串恢复。返回 null 表示成功；否则返回人类可读的错误原因。
  ///
  /// 注意：恢复会**覆盖**当前同名 key（进度最要紧，务必先确认）。
  /// 缺失的字段（null）不覆盖，保留现有值。
  static Future<String?> importSnapshot(String raw) async {
    final Object? decoded = _tryDecode(raw);
    if (decoded is! Map<String, dynamic>) return '这不是有效的备份内容';
    final Map<String, dynamic> snap = decoded;
    if (snap[kApp] != 'wanqing_shizi') return '这不是「晚晴识字」的备份';
    final dynamic p = snap[Store.kProgress];
    final dynamic s = snap[Store.kSettings];
    final dynamic day = snap[Store.kDay];
    final dynamic mk = snap[Store.kMarks];
    if (p is Map<String, dynamic>) await Store.setJson(Store.kProgress, p);
    if (s is Map<String, dynamic>) await Store.setJson(Store.kSettings, s);
    if (day is Map<String, dynamic>) await Store.setJson(Store.kDay, day);
    // 自标生字必须随备份恢复写回，否则恢复后「我圈的字」全丢（严重挫败点）。
    if (mk is Map<String, dynamic>) await Store.setJson(Store.kMarks, mk);
    return null;
  }

  /// 从快照读取导出日期（用于 UI 展示「这份备份是哪天的」），解析失败返回 null。
  static String? exportedAtOf(String raw) {
    final Object? decoded = _tryDecode(raw);
    if (decoded is! Map<String, dynamic>) return null;
    final dynamic v = decoded[kExportedAt];
    return v is String ? v : null;
  }

  /// 导出到手机文件：写到应用外置目录（Android/data/com.wanqing.shizi/files/Download），
  /// 用户可用文件管理 / USB 找到后发微信。零 pub 依赖（走 MethodChannel 拿目录）。
  /// 返回完整文件路径；失败时抛 [Exception]。
  static Future<String> exportToFile() async {
    final String? dir = await _exportDir();
    if (dir == null || dir.isEmpty) throw Exception('无法获取手机存储目录');
    final Directory d = Directory(dir);
    if (!await d.exists()) await d.create(recursive: true);
    final File f = File('$dir/晚晴识字备份-${_stamp()}.json');
    await f.writeAsString(exportSnapshot(), flush: true);
    return f.path;
  }

  /// 列出备份目录里的 json 文件名（含完整路径），按修改时间倒序（新→旧）。
  /// 没有目录或目录为空时返回空列表，不抛异常。
  static Future<List<String>> listBackups() async {
    final String? dir = await _exportDir();
    if (dir == null || dir.isEmpty) return const <String>[];
    final Directory d = Directory(dir);
    if (!await d.exists()) return const <String>[];
    final List<FileSystemEntity> ents = d
        .listSync()
        .where((FileSystemEntity e) => e is File && e.path.endsWith('.json'))
        .toList();
    ents.sort((FileSystemEntity a, FileSystemEntity b) =>
        b.statSync().modified.compareTo(a.statSync().modified));
    return ents.map((FileSystemEntity e) => e.path).toList();
  }

  /// 从指定路径的备份文件恢复。返回 null 表示成功，否则返回错误原因。
  static Future<String?> importFromFile(String path) async {
    final File f = File(path);
    if (!await f.exists()) return '找不到备份文件';
    final String raw = await f.readAsString();
    return importSnapshot(raw);
  }

  /// 向原生要应用外置文件目录（Download 子目录优先）。
  static Future<String?> _exportDir() async {
    try {
      return await const MethodChannel(_channelName).invokeMethod<String>('getExportDir');
    } on PlatformException {
      return null;
    }
  }

  static String _stamp() {
    final DateTime n = DateTime.now();
    String p(int v) => v.toString().padLeft(2, '0');
    return '${n.year}${p(n.month)}${p(n.day)}-${p(n.hour)}${p(n.minute)}${p(n.second)}';
  }

  static Object? _tryDecode(String raw) {
    try {
      return jsonDecode(raw);
    } catch (_) {
      return null;
    }
  }
}

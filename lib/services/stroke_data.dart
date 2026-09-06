import 'dart:async';
import 'dart:convert';
import 'dart:ui' show Offset, Path;

import 'package:flutter/services.dart' show rootBundle;

/// 笔顺数据加载器（hanzi-writer-data 格式）。
///
/// `assets/strokes.json` 是一个 JSON 对象：汉字 -> `{"s": [...], "m": [...]}`
/// - `s`：`List<String>`，每笔的 SVG 轮廓 path（绝对坐标，M/L/Q/C/Z）。
/// - `m`：`List<List<List<num>>>`，按笔顺排列的中线（centerline）点 `[x, y]`。
///
/// 坐标是 **y-up 数学坐标**（原点左下、y 向上），渲染时需翻转 y（见 stroke_order_demo.dart）。
///
/// 🔴 约束：只读一次、内存缓存；缺键 / 坏 JSON 一律返回空 / false，绝不抛异常。
/// 不引入任何新依赖，SVG/JSON 解析全部用 dart:convert + dart:ui 手写。
class StrokeData {
  static Map<String, dynamic>? _data;
  static bool _loading = false;

  /// 读取 assets/strokes.json 一次（并发调用安全：只真正加载一次）。
  static Future<void> load() async {
    if (_data != null || _loading) return;
    _loading = true;
    try {
      final String str = await rootBundle.loadString('assets/strokes.json');
      final dynamic decoded = jsonDecode(str);
      if (decoded is Map<String, dynamic>) {
        _data = decoded;
      } else {
        _data = null;
      }
    } catch (_) {
      // 任何失败都降级为「无数据」，绝不抛给调用方
      _data = null;
    } finally {
      _loading = false;
    }
  }

  /// 是否已有该字的笔顺数据（且 m 非空）。
  static bool hasData(String char) {
    final Map<String, dynamic>? d = _data;
    if (d == null) return false;
    final dynamic e = d[char];
    if (e is! Map<String, dynamic>) return false;
    final dynamic m = e['m'];
    return m is List && m.isNotEmpty;
  }

  /// 该字所有笔的 SVG 轮廓 path 字符串（原始坐标）。无则返回空列表。
  static List<String> strokesOf(String char) {
    final Map<String, dynamic>? e = _entry(char);
    if (e == null) return const <String>[];
    final dynamic s = e['s'];
    if (s is List) {
      return s.whereType<String>().toList();
    }
    return const <String>[];
  }

  /// 该字按笔顺的中线点（原始 y-up 坐标）。无则返回空列表。
  static List<List<Offset>> mediansOf(String char) {
    final Map<String, dynamic>? e = _entry(char);
    if (e == null) return const <List<Offset>>[];
    final dynamic m = e['m'];
    if (m is! List) return const <List<Offset>>[];
    final List<List<Offset>> out = <List<Offset>>[];
    for (final dynamic stroke in m) {
      if (stroke is! List) continue;
      final List<Offset> pts = <Offset>[];
      for (final dynamic pt in stroke) {
        if (pt is List && pt.length >= 2) {
          final double? x = _toDouble(pt[0]);
          final double? y = _toDouble(pt[1]);
          if (x != null && y != null) pts.add(Offset(x, y));
        }
      }
      if (pts.isNotEmpty) out.add(pts);
    }
    return out;
  }

  /// 该字所有笔的轮廓 path（已解析为 dart:ui Path，原始坐标）。
  /// 用于绘制浅色「范字」底图。解析失败返回空列表。
  static List<Path> outlinePathsOf(String char) {
    return strokesOf(char).map(parseSvgPath).toList();
  }

  /// 该字所有轮廓 path 中的坐标点（原始坐标），用于计算包围盒。
  static List<Offset> outlinePointsOf(String char) {
    final List<Offset> out = <Offset>[];
    for (final String s in strokesOf(char)) {
      out.addAll(svgPathPoints(s));
    }
    return out;
  }

  static Map<String, dynamic>? _entry(String char) {
    final Map<String, dynamic>? d = _data;
    if (d == null) return null;
    final dynamic e = d[char];
    return e is Map<String, dynamic> ? e : null;
  }

  static double? _toDouble(dynamic v) {
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v);
    return null;
  }

  // ---------- 极简 SVG path 解析（仅绝对/相对 M L H V Q C Z，以及 T S A 的端点近似）----------

  /// 把 path 字符串切成 token 列表：命令字母(String) 或 数字(double)。
  static List<dynamic> _tokenize(String d) {
    final RegExp re = RegExp(
      r'([MmLlHhVvCcSsQqTtAaZz])|(-?\d*\.?\d+(?:[eE][-+]?\d+)?)',
    );
    final List<dynamic> tokens = <dynamic>[];
    for (final RegExpMatch m in re.allMatches(d)) {
      if (m.group(1) != null) {
        tokens.add(m.group(1)!);
      } else if (m.group(2) != null) {
        tokens.add(double.tryParse(m.group(2)!) ?? 0.0);
      }
    }
    return tokens;
  }

  /// 解析单条 stroke 轮廓为 [Path]（原始坐标）。任何异常都返回空 Path，绝不抛。
  static Path parseSvgPath(String d) {
    try {
      final List<dynamic> tokens = _tokenize(d);
      final Path path = Path();
      int i = 0;
      double cx = 0, cy = 0, sx = 0, sy = 0;
      String cmd = '';
      double nextNum() {
        while (i < tokens.length && tokens[i] is String) {
          i++;
        }
        if (i >= tokens.length) return 0;
        final dynamic v = tokens[i];
        i++;
        return v is double ? v : 0;
      }

      while (i < tokens.length) {
        if (tokens[i] is String) {
          cmd = tokens[i] as String;
          i++;
          if (cmd.toUpperCase() == 'M') {
            // 每个新 M 都视为子路径起点
          }
        }
        final bool rel = cmd == cmd.toLowerCase();
        final String c = cmd.toUpperCase();
        if (c == 'Z') {
          path.close();
          cx = sx;
          cy = sy;
          continue;
        }
        if (c == 'M') {
          final double x = nextNum();
          final double y = nextNum();
          final double ax = rel ? cx + x : x;
          final double ay = rel ? cy + y : y;
          path.moveTo(ax, ay);
          sx = ax;
          sy = ay;
          cx = ax;
          cy = ay;
          cmd = rel ? 'l' : 'L'; // 后续隐式坐标按 lineTo 处理
          continue;
        }
        if (c == 'L') {
          final double x = nextNum();
          final double y = nextNum();
          final double ax = rel ? cx + x : x;
          final double ay = rel ? cy + y : y;
          path.lineTo(ax, ay);
          cx = ax;
          cy = ay;
          continue;
        }
        if (c == 'H') {
          final double x = nextNum();
          final double ax = rel ? cx + x : x;
          path.lineTo(ax, cy);
          cx = ax;
          continue;
        }
        if (c == 'V') {
          final double y = nextNum();
          final double ay = rel ? cy + y : y;
          path.lineTo(cx, ay);
          cy = ay;
          continue;
        }
        if (c == 'Q') {
          final double c1x = nextNum();
          final double c1y = nextNum();
          final double x = nextNum();
          final double y = nextNum();
          final double ax1 = rel ? cx + c1x : c1x;
          final double ay1 = rel ? cy + c1y : c1y;
          final double ax = rel ? cx + x : x;
          final double ay = rel ? cy + y : y;
          path.quadraticBezierTo(ax1, ay1, ax, ay);
          cx = ax;
          cy = ay;
          continue;
        }
        if (c == 'C') {
          final double a = nextNum();
          final double b = nextNum();
          final double cc = nextNum();
          final double dd = nextNum();
          final double x = nextNum();
          final double y = nextNum();
          final double x1 = rel ? cx + a : a;
          final double y1 = rel ? cy + b : b;
          final double x2 = rel ? cx + cc : cc;
          final double y2 = rel ? cy + dd : dd;
          final double ax = rel ? cx + x : x;
          final double ay = rel ? cy + y : y;
          path.cubicTo(x1, y1, x2, y2, ax, ay);
          cx = ax;
          cy = ay;
          continue;
        }
        if (c == 'T' || c == 'S') {
          // 平滑曲线：用端点近似为直线（仅影响底图，足够）
          final double x = nextNum();
          final double y = nextNum();
          final double ax = rel ? cx + x : x;
          final double ay = rel ? cy + y : y;
          path.lineTo(ax, ay);
          cx = ax;
          cy = ay;
          continue;
        }
        if (c == 'A') {
          // 圆弧：跳过前 5 个参数，按端点近似
          nextNum();
          nextNum();
          nextNum();
          nextNum();
          nextNum();
          final double x = nextNum();
          final double y = nextNum();
          final double ax = rel ? cx + x : x;
          final double ay = rel ? cy + y : y;
          path.lineTo(ax, ay);
          cx = ax;
          cy = ay;
          continue;
        }
        // 未知命令：跳过一个数字（若有），避免死循环
        if (i < tokens.length && tokens[i] is double) nextNum();
      }
      return path;
    } catch (_) {
      return Path();
    }
  }

  /// 提取一条 path 中的所有坐标点（控制点 + 端点），用于包围盒计算。
  static List<Offset> svgPathPoints(String d) {
    try {
      final List<dynamic> tokens = _tokenize(d);
      final List<Offset> pts = <Offset>[];
      int i = 0;
      double cx = 0, cy = 0;
      String cmd = '';
      double nn() {
        while (i < tokens.length && tokens[i] is String) {
          i++;
        }
        if (i >= tokens.length) return 0;
        final dynamic v = tokens[i];
        i++;
        return v is double ? v : 0;
      }

      while (i < tokens.length) {
        if (tokens[i] is String) {
          cmd = tokens[i] as String;
          i++;
        }
        final bool rel = cmd == cmd.toLowerCase();
        final String c = cmd.toUpperCase();
        if (c == 'Z') continue;
        if (c == 'M' || c == 'L' || c == 'T') {
          final double x = nn();
          final double y = nn();
          final double ax = rel ? cx + x : x;
          final double ay = rel ? cy + y : y;
          pts.add(Offset(ax, ay));
          cx = ax;
          cy = ay;
          if (c == 'M') cmd = rel ? 'l' : 'L';
          continue;
        }
        if (c == 'H') {
          final double x = nn();
          final double ax = rel ? cx + x : x;
          pts.add(Offset(ax, cy));
          cx = ax;
          continue;
        }
        if (c == 'V') {
          final double y = nn();
          final double ay = rel ? cy + y : y;
          pts.add(Offset(cx, ay));
          cy = ay;
          continue;
        }
        if (c == 'Q') {
          final double x1 = nn();
          final double y1 = nn();
          final double x = nn();
          final double y = nn();
          final double ax1 = rel ? cx + x1 : x1;
          final double ay1 = rel ? cy + y1 : y1;
          final double ax = rel ? cx + x : x;
          final double ay = rel ? cy + y : y;
          pts.add(Offset(ax1, ay1));
          pts.add(Offset(ax, ay));
          cx = ax;
          cy = ay;
          continue;
        }
        if (c == 'C') {
          final double a = nn();
          final double b = nn();
          final double cc = nn();
          final double dd = nn();
          final double x = nn();
          final double y = nn();
          final double x1 = rel ? cx + a : a;
          final double y1 = rel ? cy + b : b;
          final double x2 = rel ? cx + cc : cc;
          final double y2 = rel ? cy + dd : dd;
          final double ax = rel ? cx + x : x;
          final double ay = rel ? cy + y : y;
          pts.add(Offset(x1, y1));
          pts.add(Offset(x2, y2));
          pts.add(Offset(ax, ay));
          cx = ax;
          cy = ay;
          continue;
        }
        if (c == 'A') {
          nn();
          nn();
          nn();
          nn();
          nn();
          final double x = nn();
          final double y = nn();
          final double ax = rel ? cx + x : x;
          final double ay = rel ? cy + y : y;
          pts.add(Offset(ax, ay));
          cx = ax;
          cy = ay;
          continue;
        }
        if (i < tokens.length && tokens[i] is double) nn();
      }
      return pts;
    } catch (_) {
      return const <Offset>[];
    }
  }
}

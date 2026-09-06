import 'dart:math' as math;
import 'dart:ui' show Offset;

/// 晚晴识字 · 笔顺自检（纯 Dart，零依赖，不碰 UI）。
///
/// 输入手写板收集到的轨迹（每笔一串点）+ 字库里的期望笔画名，输出**温和的**矫正建议。
///
/// 🔴 产品红线（必须遵守）：
/// - **绝不打叉、不打分、不羞辱**。判定只用来给「怎么写更顺手」的建议。
/// - 文案一律鼓励式，末尾引导「再写一遍」。
/// - 输出文本必须是**纯中文**（会被送进 TTS 朗读，拉丁字母会被念成英文）。
///   所以数字统一转中文数字（六笔 / 第三笔），不出现阿拉伯数字。
///
/// 判定策略：**宁松勿严**——误报（把写对的说成写错）比漏报伤人得多。
/// 所以单笔只做「粗分类包含匹配」，复合笔画（横折钩）只要测到「有拐弯」就算过；
/// 笔画数不一致时**不做逐笔比对**（下标已错位，比出来的结论必然是误报）。
class StrokeCheckService {
  StrokeCheckService._();

  // ---------------- 阈值（全部相对画板尺寸，便于随字号/屏幕缩放） ----------------

  /// 「点」判定：首尾位移小于画板短边的这个比例，就认为是一个点（而不是横/竖）。
  /// 取 6%：300dp 画板 ≈ 18dp，比手指抖动大、比任何一笔真正的横竖小。
  static const double kDotRatio = 0.06;

  /// 方向容差（度）：实测方向与某个标准笔向相差在此范围内，就认为「可能是这一笔」。
  ///
  /// 取 35°，**刻意让相邻笔向的窗口互相重叠**——这是宁松勿严的关键：
  /// 比如「人」的撇实测约 115°，同时落在「竖(90°)」和「撇(135°)」两个窗口里，
  /// 期望是撇就算通过，不会因为写得陡一点就被判成「你写成了竖」。
  static const double kDirTolDeg = 35;

  /// 标准笔向（度，屏幕坐标系 y 向下为正）：
  /// 横 0 → 往右；捺 45 → 右下；竖 90 → 往下；撇 135 → 左下；
  /// 横反 180 → 往左（横写反了）；竖反 -90 → 往上（竖写反了）；提 -30 → 右上。
  static const Map<_StrokeKind, double> _kCanonicalAngles = <_StrokeKind, double>{
    _StrokeKind.heng: 0,
    _StrokeKind.na: 45,
    _StrokeKind.shu: 90,
    _StrokeKind.pie: 135,
    _StrokeKind.hengBack: 180,
    _StrokeKind.shuBack: -90,
    _StrokeKind.ti: -30,
  };

  /// 拐点判定：相邻两段方向向量夹角超过这个角度（度）→ 认为这一笔「拐了弯」（折/钩/弯类）。
  /// 取 60°：正常书写的弧度（撇、捺的自然弯曲）一般在 30° 以内，不会误判。
  static const double kTurnAngleDeg = 60;

  /// 参与拐点判定的分段最小位移（占画板短边）。低于此值的段视为抖动，不参与夹角计算。
  static const double kTurnSegMinRatio = 0.10;

  /// 「先上后下」容差：第 i 笔起点比第 i+1 笔起点低于这个比例（占画板高度）才算违规。
  /// 取 12%：给同排笔画（如「口」的横折与竖）足够余量，只抓明显的倒序。
  static const double kOrderYTolRatio = 0.12;

  /// 「先左后右」容差：两笔起点 y 差在此范围内视为「同一排」，此时才比 x 顺序。
  static const double kOrderXTolRatio = 0.12;

  /// 一次最多给几条建议。多了记不住，也容易让人泄气。
  static const int kMaxAdvices = 2;

  /// 笔画数差多少以内仍然逐笔比对（0 = 只有完全一致才逐笔比）。
  static const int kCountTolerance = 0;

  /// 主入口。
  ///
  /// [strokes] 手写轨迹（画板局部坐标，y 向下为正）；
  /// [expectedStrokeNames] 字库 `CharCard.strokeNames`；
  /// [padSize] 田字格边长（画板是正方形，宽高同值）。
  static StrokeCheckResult check({
    required List<List<Offset>> strokes,
    required List<String> expectedStrokeNames,
    required double padSize,
  }) {
    final List<List<Offset>> valid =
        strokes.where((List<Offset> s) => s.length >= 2).toList();

    if (expectedStrokeNames.isEmpty) {
      // 没有期望笔顺可比 → 退回纯鼓励，绝不瞎判。
      return const StrokeCheckResult(
        pass: true,
        advices: <String>[],
        summary: '写得真认真，多练几遍就熟了，慢慢来。',
      );
    }
    if (valid.isEmpty) {
      return const StrokeCheckResult(
        pass: false,
        advices: <String>['还没写呢，用手指在格子里写一遍吧'],
        summary: '还没写呢，用手指在格子里写一遍吧。',
      );
    }

    final double side = padSize <= 0 ? 1 : padSize;
    final List<_Measured> ms = <_Measured>[
      for (final List<Offset> s in valid) _measure(s, side),
    ];

    final List<String> advices = <String>[];

    // ---------- 校验 1 · 笔画数 ----------
    final int expected = expectedStrokeNames.length;
    final int got = ms.length;
    final bool countOk = (got - expected).abs() <= kCountTolerance;
    if (!countOk) {
      advices.add('这个字是${_cn(expected)}笔，你写了${_cn(got)}笔，'
          '${got > expected ? '有的笔画可能分成了两下' : '好像少了一笔'}');
    }

    // ---------- 校验 2 · 单笔方向粗分类 ----------
    // 笔画数不一致时下标必然错位，逐笔比对只会得出误报，所以直接跳过。
    if (countOk) {
      for (int i = 0; i < ms.length && advices.length < kMaxAdvices; i++) {
        final String? advice = _adviceFor(i, ms[i], expectedStrokeNames[i]);
        if (advice != null) {
          advices.add(advice);
          break; // 一次只指一处笔形问题，避免一口气挑三处
        }
      }
    }

    // ---------- 校验 3 · 空间顺序（先上后下、先左后右） ----------
    if (advices.length < kMaxAdvices) {
      final String? orderAdvice = _orderAdvice(ms, valid, side);
      if (orderAdvice != null) advices.add(orderAdvice);
    }

    final bool pass = advices.isEmpty;
    return StrokeCheckResult(
      pass: pass,
      advices: advices,
      summary: pass
          ? '写得很好，笔画和顺序都对上了，真不错。'
          : '写得挺认真的。${advices.join('；')}。慢慢来，再写一遍试试。',
    );
  }

  // ---------------- 单笔测量 ----------------

  static _Measured _measure(List<Offset> pts, double side) {
    final Offset start = pts.first;
    final Offset end = pts.last;
    final double dx = end.dx - start.dx;
    final double dy = end.dy - start.dy;
    final double dist = math.sqrt(dx * dx + dy * dy);

    // ① 位移极小 → 点
    if (dist < side * kDotRatio) {
      return _Measured(_StrokeKind.dot, <_StrokeKind>{_StrokeKind.dot}, start, end);
    }

    final double angle = math.atan2(dy, dx) * 180 / math.pi;
    final _StrokeKind primary = _primaryKind(angle);
    final Set<_StrokeKind> plausible = _plausibleKinds(angle);

    // ② 路径有明显拐点 → 折 / 钩 / 弯 类。
    //    主分类记 turn，但**同时保留首尾方向的可能性**：手抖或写得弯一点的直笔
    //    也会被测出拐点，如果只留 turn 就会把写对的判成写错。
    if (_hasTurn(pts, side)) {
      return _Measured(
        _StrokeKind.turn,
        <_StrokeKind>{_StrokeKind.turn, ...plausible},
        start,
        end,
      );
    }

    // ③ 直笔：按角度窗口给主分类 + 宽容集合
    return _Measured(primary, plausible, start, end);
  }

  /// 离标准笔向最近的那一类（只用于「你写成了X」这句话）。
  static _StrokeKind _primaryKind(double angle) {
    _StrokeKind best = _StrokeKind.unknown;
    double bestDiff = 360;
    _kCanonicalAngles.forEach((_StrokeKind k, double a) {
      final double diff = _angleDiff(angle, a);
      if (diff < bestDiff) {
        bestDiff = diff;
        best = k;
      }
    });
    return best;
  }

  /// 所有「说得过去」的分类（窗口互相重叠，宁松勿严）。
  static Set<_StrokeKind> _plausibleKinds(double angle) {
    final Set<_StrokeKind> out = <_StrokeKind>{};
    _kCanonicalAngles.forEach((_StrokeKind k, double a) {
      if (_angleDiff(angle, a) <= kDirTolDeg) out.add(k);
    });
    return out;
  }

  /// 两个角度的最小夹角（度，处理 ±180 环绕）。
  static double _angleDiff(double a, double b) {
    double d = (a - b).abs() % 360;
    if (d > 180) d = 360 - d;
    return d;
  }

  /// 按弧长把一笔切成三段，比较相邻段的方向夹角，判断是否「拐了弯」。
  ///
  /// 用三等分而不是逐点求夹角：逐点夹角对手指抖动极其敏感，会把一条直竖判成折。
  static bool _hasTurn(List<Offset> pts, double side) {
    final List<Offset> ends = _thirdPoints(pts);
    if (ends.length < 4) return false;
    final List<Offset> vs = <Offset>[
      ends[1] - ends[0],
      ends[2] - ends[1],
      ends[3] - ends[2],
    ];
    final double minLen = side * kTurnSegMinRatio;
    for (int i = 0; i + 1 < vs.length; i++) {
      final Offset a = vs[i];
      final Offset b = vs[i + 1];
      if (a.distance < minLen || b.distance < minLen) continue;
      if (_angleDeg(a, b) > kTurnAngleDeg) return true;
    }
    return false;
  }

  /// 取一笔的 0 / 1⁄3 / 2⁄3 / 1 四个弧长分位点。
  static List<Offset> _thirdPoints(List<Offset> pts) {
    if (pts.length < 4) return const <Offset>[];
    final List<double> acc = <double>[0];
    for (int i = 1; i < pts.length; i++) {
      acc.add(acc[i - 1] + (pts[i] - pts[i - 1]).distance);
    }
    final double total = acc.last;
    if (total <= 0) return const <Offset>[];
    Offset at(double ratio) {
      final double want = total * ratio;
      for (int i = 0; i < acc.length; i++) {
        if (acc[i] >= want) return pts[i];
      }
      return pts.last;
    }

    return <Offset>[pts.first, at(1 / 3), at(2 / 3), pts.last];
  }

  static double _angleDeg(Offset a, Offset b) {
    final double dot = a.dx * b.dx + a.dy * b.dy;
    final double den = a.distance * b.distance;
    if (den <= 0) return 0;
    final double cos = (dot / den).clamp(-1.0, 1.0);
    return math.acos(cos) * 180 / math.pi;
  }

  // ---------------- 与期望笔画名比对 ----------------

  /// 返回一条建议；`null` 表示这一笔算通过。
  static String? _adviceFor(int idx, _Measured m, String expectedName) {
    // 测不准的一律放过（宁松勿严）
    if (m.kind == _StrokeKind.unknown) return null;

    final Set<_StrokeKind> allowed = _allowedKinds(expectedName);
    if (allowed.isEmpty) return null; // 期望名里没有任何已知关键字 → 不判
    // 只要有**任何一种说得过去的分类**落在期望范围里，就算通过
    if (m.plausible.any(allowed.contains)) return null;

    final String no = '第${_cn(idx + 1)}笔';

    // 方向写反：给最具体的提示（这是最常见、也最值得说的一类）
    if (m.kind == _StrokeKind.hengBack) {
      if (allowed.contains(_StrokeKind.pie)) return null; // 平一点的撇，放过
      if (allowed.contains(_StrokeKind.heng)) {
        return '$no是「横」，横要从左往右写';
      }
    }
    if (m.kind == _StrokeKind.shuBack) {
      if (allowed.contains(_StrokeKind.ti)) return null; // 往右上挑的提，放过
      if (allowed.contains(_StrokeKind.shu)) {
        return '$no是「竖」，竖要从上往下写';
      }
    }
    // 期望是折/钩/弯这类复合笔画，而实测是一条直线 → 只提醒「要拐个弯」
    if (allowed.contains(_StrokeKind.turn) && m.kind != _StrokeKind.dot) {
      return '$no是「$expectedName」，中间要拐一下';
    }
    final String gotName = _kindLabel(m.kind);
    if (gotName.isEmpty) return null;
    return '$no应该是「$expectedName」，你写成了$gotName';
  }

  /// 从期望笔画名里抽关键字，得到「可以接受的实测分类」集合。
  ///
  /// 复合笔画（含两个以上关键字，如「竖提」「横撇」）额外接受「折/弯类」，
  /// 因为它们本身就带拐点，实测很可能被判成 turn。
  static Set<_StrokeKind> _allowedKinds(String name) {
    final Set<_StrokeKind> out = <_StrokeKind>{};
    int hits = 0;
    if (name.contains('横')) {
      out.add(_StrokeKind.heng);
      hits++;
    }
    if (name.contains('竖')) {
      out.add(_StrokeKind.shu);
      hits++;
    }
    if (name.contains('撇')) {
      out.add(_StrokeKind.pie);
      hits++;
    }
    if (name.contains('点')) {
      // 点太短，方向测量本就不可靠 → 任何短斜笔都算对（宁松勿严）
      out.addAll(<_StrokeKind>[
        _StrokeKind.dot,
        _StrokeKind.na,
        _StrokeKind.pie,
        _StrokeKind.ti,
      ]);
      hits++;
    }
    if (name.contains('提')) {
      out.add(_StrokeKind.ti);
      hits++;
    }
    if (name.contains('捺') || name.contains('斜')) {
      out.add(_StrokeKind.na);
      hits++;
    }
    if (name.contains('折') || name.contains('钩') || name.contains('弯') || name.contains('卧')) {
      out.add(_StrokeKind.turn);
      hits++;
    }
    if (hits >= 2) out.add(_StrokeKind.turn);
    return out;
  }

  // ---------------- 空间顺序 ----------------

  /// 用整笔的包围盒（而不是起点）判断书写顺序，避免「十」「抖」这类交叉字误报。
  /// 起点比较太脆：十的横从中间起笔、竖从顶上起笔，单比起点会错判成「先上后下」。
  static String? _orderAdvice(List<_Measured> ms, List<List<Offset>> strokes, double side) {
    final double yTol = side * kOrderYTolRatio;
    final double xTol = side * kOrderXTolRatio;
    for (int i = 0; i + 1 < ms.length; i++) {
      final bboxA = _bbox(strokes[i]);
      final bboxB = _bbox(strokes[i + 1]);
      // 两笔是否在同一竖列（横向有重叠）。左右结构的字（如「好」=女+子）两部件分家，
      // 不能拿左边部件的底横去和右边部件的顶横比上下，否则会误报「先上后下」。
      final bool sameColumn = bboxA.maxX >= bboxB.minX && bboxB.maxX >= bboxA.minX;
      // 先上后下：这一笔「整体」在下一笔的下方（它的顶边低于下一笔的底边）且二者同列 → 顺序倒了。
      if (sameColumn && bboxA.minY - bboxB.maxY > yTol) {
        return '一般先写上面的笔画，再写下面的';
      }
      // 先左后右：两笔纵向有重叠（大致同一排），但这一笔整体在右边 → 顺序倒了。
      final bool sameRow = bboxA.minY <= bboxB.maxY && bboxB.minY <= bboxA.maxY;
      if (sameRow && bboxA.minX - bboxB.maxX > xTol) {
        return '同样高的笔画，一般先写左边的，再写右边的';
      }
    }
    return null;
  }

  static ({double minX, double maxX, double minY, double maxY}) _bbox(List<Offset> pts) {
    double minX = pts.first.dx;
    double maxX = pts.first.dx;
    double minY = pts.first.dy;
    double maxY = pts.first.dy;
    for (final Offset p in pts) {
      if (p.dx < minX) minX = p.dx;
      if (p.dx > maxX) maxX = p.dx;
      if (p.dy < minY) minY = p.dy;
      if (p.dy > maxY) maxY = p.dy;
    }
    return (minX: minX, maxX: maxX, minY: minY, maxY: maxY);
  }

  // ---------------- 中文数字（TTS 只能吃中文，不能出现阿拉伯数字） ----------------

  static String _cn(int n) {
    const List<String> d = <String>['零', '一', '二', '三', '四', '五', '六', '七', '八', '九'];
    if (n < 0) return '零';
    if (n < 10) return d[n];
    if (n < 20) return n == 10 ? '十' : '十${d[n % 10]}';
    if (n < 100) {
      final int t = n ~/ 10;
      final int o = n % 10;
      return '${d[t]}十${o == 0 ? '' : d[o]}';
    }
    return '很多';
  }

  static String _kindLabel(_StrokeKind k) {
    switch (k) {
      case _StrokeKind.dot:
        return '点';
      case _StrokeKind.heng:
      case _StrokeKind.hengBack:
        return '横';
      case _StrokeKind.shu:
      case _StrokeKind.shuBack:
        return '竖';
      case _StrokeKind.pie:
        return '撇';
      case _StrokeKind.na:
        return '捺';
      case _StrokeKind.ti:
        return '提';
      case _StrokeKind.turn:
        return '带拐弯的一笔';
      case _StrokeKind.unknown:
        return '';
    }
  }
}

/// 笔顺自检结果。
///
/// [advices] 最多 [StrokeCheckService.kMaxAdvices] 条，句式温和、指向明确；
/// [summary] 是拼好的整段文案（纯中文，可直接送 TTS 朗读）。
class StrokeCheckResult {
  final bool pass;
  final List<String> advices;
  final String summary;

  const StrokeCheckResult({
    required this.pass,
    required this.advices,
    required this.summary,
  });
}

/// 单笔粗分类。`*Back` = 方向写反（横从右往左、竖从下往上）。
enum _StrokeKind { dot, heng, hengBack, shu, shuBack, pie, na, ti, turn, unknown }

/// 一笔的测量结果。
///
/// [kind] 主分类（只用于「你写成了X」的措辞）；
/// [plausible] 所有说得过去的分类，判定通过与否只看这个集合（宁松勿严）；
/// [start] / [end] 首尾点，[start] 用于「先上后下 / 先左后右」的顺序判定。
class _Measured {
  final _StrokeKind kind;
  final Set<_StrokeKind> plausible;
  final Offset start;
  final Offset end;

  const _Measured(this.kind, this.plausible, this.start, this.end);
}

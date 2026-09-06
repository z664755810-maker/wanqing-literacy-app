import 'dart:math';
import 'package:flutter/material.dart';
import 'package:wanqing_shizi/data/content.dart';
import 'package:wanqing_shizi/services/tts_service.dart';
import 'package:wanqing_shizi/theme/app_theme.dart';

/// 田字格手写板：记录手指轨迹，给出简单评估
class HandwritingPad extends StatefulWidget {
  final double size;
  final String guideChar;
  final ValueChanged<String> onSubmit;
  const HandwritingPad({
    super.key,
    required this.size,
    required this.guideChar,
    required this.onSubmit,
  });

  @override
  State<HandwritingPad> createState() => _HandwritingPadState();
}

class _HandwritingPadState extends State<HandwritingPad> {
  final List<List<Offset>> _strokes = [];
  List<Offset> _current = [];

  void _start(Offset p) {
    setState(() => _current = [p]);
  }

  void _move(Offset p) {
    if (_current.isEmpty) return;
    setState(() => _current.add(p));
  }

  void _end() {
    if (_current.length >= 2) {
      setState(() {
        _strokes.add(List.from(_current));
        _current = [];
      });
    } else {
      setState(() => _current = []);
    }
  }

  void _clear() {
    setState(() {
      _strokes.clear();
      _current = [];
    });
  }

  void _submit() {
    final info = CHARS_UNIQUE[widget.guideChar];
    final expected = info?.strokes.length ?? 0;
    final actual = _strokes.length;

    if (actual == 0) {
      widget.onSubmit('还没有写呢，用手指在格子里写一遍吧。');
      TtsService().speak('还没有写呢，用手指在格子里写一遍吧。');
      return;
    }

    // 简单评估：看落点是否基本在格子里、笔画数是否接近
    final allPoints = _strokes.expand((s) => s).toList();
    final bbox = _boundingBox(allPoints);
    final padSize = widget.size;
    final inside = bbox.left >= -padSize * 0.1 &&
        bbox.top >= -padSize * 0.1 &&
        bbox.right <= padSize * 1.1 &&
        bbox.bottom <= padSize * 1.1;

    String result;
    if (expected > 0) {
      if (actual == expected && inside) {
        result = '写得很认真，笔画像！继续加油。';
      } else if ((actual - expected).abs() <= 1 && inside) {
        result = '写得不错，再对照上面的笔顺多练几遍。';
      } else if (!inside) {
        result = '字写到格子外面啦，试着写在田字格中间。';
      } else {
        result = '还有进步空间，这笔字是${expected}画，您写了$actual笔，再数一数。';
      }
    } else {
      result = inside ? '写得认真，像！' : '试着把字写在田字格中间。';
    }

    widget.onSubmit(result);
    TtsService().speak(result);
  }

  Rect _boundingBox(List<Offset> pts) {
    double minX = double.infinity, minY = double.infinity;
    double maxX = -double.infinity, maxY = -double.infinity;
    for (final p in pts) {
      minX = min(minX, p.dx);
      minY = min(minY, p.dy);
      maxX = max(maxX, p.dx);
      maxY = max(maxY, p.dy);
    }
    return Rect.fromLTRB(minX, minY, maxX, maxY);
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.size;
    return Column(
      children: [
        Container(
          width: s,
          height: s,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFD8CDB4)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: GestureDetector(
              onPanStart: (d) => _start(d.localPosition),
              onPanUpdate: (d) => _move(d.localPosition),
              onPanEnd: (_) => _end(),
              child: CustomPaint(
                size: Size(s, s),
                painter: _HandwritingPainter(
                  strokes: _strokes,
                  current: _current,
                  guideChar: widget.guideChar,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton.icon(
              onPressed: _clear,
              icon: Icon(Icons.clear, color: AppTheme.ink2),
              label: Text('重写', style: AppTheme.sans(size: 15, color: AppTheme.ink2)),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: const Color(0xFFD8CDB4)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: _submit,
              icon: Icon(Icons.check, color: AppTheme.paper),
              label: Text('看看写得怎样', style: AppTheme.sans(size: 15, color: AppTheme.paper)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.dai,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _HandwritingPainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final List<Offset> current;
  final String guideChar;

  _HandwritingPainter({required this.strokes, required this.current, required this.guideChar});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 田字格
    final gridPaint = Paint()
      ..color = const Color(0xFFE0D8C8)
      ..strokeWidth = 1.5;
    canvas.drawLine(Offset(w / 2, 0), Offset(w / 2, h), gridPaint);
    canvas.drawLine(Offset(0, h / 2), Offset(w, h / 2), gridPaint);
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), gridPaint..style = PaintingStyle.stroke);

    // 对角线
    final diagPaint = Paint()
      ..color = const Color(0xFFEFE8DA)
      ..strokeWidth = 1;
    canvas.drawLine(Offset(0, 0), Offset(w, h), diagPaint);
    canvas.drawLine(Offset(w, 0), Offset(0, h), diagPaint);

    // 浅色范字
    final guideText = TextPainter(
      text: TextSpan(
        text: guideChar,
        style: TextStyle(
          fontSize: w * 0.65,
          color: const Color(0xFFE8E0D0),
          fontFamily: 'serif',
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    guideText.layout();
    guideText.paint(canvas, Offset((w - guideText.width) / 2, (h - guideText.height) / 2));

    // 用户笔迹
    final paint = Paint()
      ..color = AppTheme.dai
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    for (final stroke in [...strokes, if (current.isNotEmpty) current]) {
      if (stroke.length < 2) continue;
      final path = Path();
      path.moveTo(stroke.first.dx, stroke.first.dy);
      for (int i = 1; i < stroke.length; i++) {
        path.lineTo(stroke[i].dx, stroke[i].dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

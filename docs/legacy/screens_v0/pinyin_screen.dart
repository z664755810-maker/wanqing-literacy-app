import 'package:flutter/material.dart';
import 'package:wanqing_shizi/data/content.dart';
import 'package:wanqing_shizi/screens/pinyin_detail_screen.dart';
import 'package:wanqing_shizi/services/tts_service.dart';
import 'package:wanqing_shizi/theme/app_theme.dart';

/// 拼音课堂：把“小课堂+声调”融入声母/韵母，每个音节可点击进详情。
class PinyinScreen extends StatefulWidget {
  const PinyinScreen({super.key});

  @override
  State<PinyinScreen> createState() => _PinyinScreenState();
}

class _PinyinScreenState extends State<PinyinScreen> {
  int _tab = 0; // 0 声母，1 韵母

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.paper,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(),
            _tabs(),
            Expanded(child: _tab == 0 ? _shengmuGrid() : _yunmuGrid()),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('拼音课堂', style: AppTheme.serif(size: 30, color: AppTheme.ink, w: FontWeight.w700)),
          const SizedBox(height: 10),
          Text(
            '拼音是汉字的“声音密码”。把声母和韵母拼在一起，再加上声调，就是一个汉字的读音。',
            style: AppTheme.sans(size: 15, color: AppTheme.ink2, h: 1.6),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F0E6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFD8CDB4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('先点下面的声母或韵母，', style: AppTheme.sans(size: 15, color: AppTheme.ink)),
                Text('进入详情页，听发音、看口型、练例词。', style: AppTheme.sans(size: 15, color: AppTheme.ink)),
                const SizedBox(height: 6),
                Text('拼读公式：声母（轻短）+ 韵母（响亮）+ 声调 = 汉字读音',
                    style: AppTheme.sans(size: 14, color: AppTheme.dai, w: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabs() {
    final labels = ['声母（23个）', '韵母（24个）'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
      child: Row(
        children: List.generate(labels.length, (i) {
          final active = _tab == i;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: i == 0 ? 10 : 0),
              child: InkWell(
                onTap: () => setState(() => _tab = i),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: active ? AppTheme.dai : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: active ? AppTheme.dai : const Color(0xFFD8CDB4)),
                  ),
                  child: Center(
                    child: Text(labels[i],
                        style: AppTheme.sans(
                            size: 16,
                            color: active ? AppTheme.paper : AppTheme.ink,
                            w: active ? FontWeight.w600 : FontWeight.normal)),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _shengmuGrid() {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(22, 10, 22, 30),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: SHENGMU.length,
      itemBuilder: (ctx, i) {
        final s = SHENGMU[i];
        return _phonemeCard(
          label: s.b,
          sub: s.name,
          onTap: () => Navigator.push(
              ctx, MaterialPageRoute(builder: (_) => PinyinDetailScreen(sm: s))),
          onSound: () => TtsService().speak('${s.name}，${s.word}'),
        );
      },
    );
  }

  Widget _yunmuGrid() {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(22, 10, 22, 30),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.9,
      ),
      itemCount: YUNMU.length,
      itemBuilder: (ctx, i) {
        final y = YUNMU[i];
        return _phonemeCard(
          label: y.b,
          sub: y.name,
          onTap: () => Navigator.push(
              ctx, MaterialPageRoute(builder: (_) => PinyinDetailScreen(ym: y))),
          onSound: () => TtsService().speak('${y.name}，${y.word}'),
        );
      },
    );
  }

  Widget _phonemeCard({
    required String label,
    required String sub,
    required VoidCallback onTap,
    required VoidCallback onSound,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFD8CDB4)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4, offset: const Offset(0, 2))],
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(label,
                      style: AppTheme.serif(size: 32, color: AppTheme.ink, w: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(sub, style: AppTheme.sans(size: 13, color: AppTheme.ink2)),
                ],
              ),
            ),
            Positioned(
              top: 6,
              right: 6,
              child: GestureDetector(
                onTap: onSound,
                child: Icon(Icons.volume_up, size: 18, color: AppTheme.dai),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

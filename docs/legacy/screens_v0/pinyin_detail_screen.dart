import 'package:flutter/material.dart';
import 'package:wanqing_shizi/data/content.dart';
import 'package:wanqing_shizi/services/tts_service.dart';
import 'package:wanqing_shizi/theme/app_theme.dart';

/// 拼音详情页：声母/韵母的完整发音讲解
class PinyinDetailScreen extends StatelessWidget {
  final Shengmu? sm;
  final Yunmu? ym;
  const PinyinDetailScreen({super.key, this.sm, this.ym});

  @override
  Widget build(BuildContext context) {
    final isShengmu = sm != null;
    final title = isShengmu ? '声母 ${sm!.b}' : '韵母 ${ym!.b}';
    final name = isShengmu ? sm!.name : ym!.name;
    final py = isShengmu ? sm!.py : ym!.py;
    final word = isShengmu ? sm!.word : ym!.word;
    final how = isShengmu ? sm!.how : ym!.how;
    final warn = isShengmu ? sm!.warn : null;

    return Scaffold(
      backgroundColor: AppTheme.paper,
      appBar: AppBar(
        backgroundColor: AppTheme.paper,
        elevation: 0,
        iconTheme: IconThemeData(color: AppTheme.ink),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(title, style: AppTheme.serif(size: 22, color: AppTheme.ink, w: FontWeight.w600)),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          children: [
            // 大字读音
            Center(
              child: Column(
                children: [
                  Text(sm?.b ?? ym?.b ?? '',
                      style: AppTheme.serif(size: 96, color: AppTheme.dai, w: FontWeight.w700)),
                  const SizedBox(height: 12),
                  Text('读作：$py（$name）',
                      style: AppTheme.serif(size: 24, color: AppTheme.ink)),
                  const SizedBox(height: 16),
                  _playButton(context, '听标准音', isShengmu ? '${sm!.name}，${sm!.word}' : '${ym!.name}，${ym!.word}'),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // 发音要领
            _sectionTitle('发音要领'),
            const SizedBox(height: 8),
            Text(how,
                style: AppTheme.sans(size: 18, color: AppTheme.ink, h: 1.7)),
            if (warn != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFFCC80)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange.shade800),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(warn,
                          style: AppTheme.sans(size: 16, color: Colors.orange.shade900)),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 28),

            // 例字例词
            _sectionTitle('例字例词'),
            const SizedBox(height: 8),
            Text('常用于这些字词中：$word',
                style: AppTheme.sans(size: 18, color: AppTheme.ink, h: 1.7)),
            const SizedBox(height: 16),
            _playButton(context, '听例词读音', word),
            const SizedBox(height: 28),

            // 韵母：四声练习
            if (!isShengmu && ym != null) ...[
              _sectionTitle('声调练习：同一个韵母，声调不同，意思不同'),
              const SizedBox(height: 8),
              ...ym!.tones.map((t) {
                final parts = t.split(' ');
                final mark = parts.isNotEmpty ? parts[0] : t;
                final word = parts.length > 1 ? parts.sublist(1).join(' ') : '';
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    onTap: () => TtsService().speak(word),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFD8CDB4)),
                      ),
                      child: Row(
                        children: [
                          Text(mark, style: AppTheme.serif(size: 32, color: AppTheme.dai)),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(word,
                                style: AppTheme.sans(size: 18, color: AppTheme.ink)),
                          ),
                          Icon(Icons.volume_up, color: AppTheme.ink2),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 24),
            ],

            // 拼读提示
            _sectionTitle('怎么跟读'),
            const SizedBox(height: 8),
            Text(
              isShengmu
                  ? '先看清口型，再听标准音，最后自己念一遍。声母发音轻而短，不要拖长。'
                  : '韵母发音要饱满，口型要到位。四个声调要分开练：先念第一声平稳，第二声上扬，第三声拐弯，第四声下降。',
              style: AppTheme.sans(size: 17, color: AppTheme.ink2, h: 1.7),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Row(
      children: [
        Container(width: 4, height: 22, color: AppTheme.zhe),
        const SizedBox(width: 10),
        Text(text, style: AppTheme.serif(size: 20, color: AppTheme.ink, w: FontWeight.w600)),
      ],
    );
  }

  Widget _playButton(BuildContext context, String text, String sound) {
    return ElevatedButton.icon(
      onPressed: () => TtsService().speak(sound),
      icon: Icon(Icons.volume_up, color: AppTheme.paper),
      label: Text(text, style: AppTheme.sans(size: 18, color: AppTheme.paper, w: FontWeight.w500)),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.dai,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:wanqing_shizi/data/content.dart';
import 'package:wanqing_shizi/services/store.dart';
import 'package:wanqing_shizi/services/tts_service.dart';
import 'package:wanqing_shizi/theme/app_theme.dart';

/// 汉字详情页：大字 + 拼音 + 笔顺 + 释义 + 例句 + 手写练习
class CharDetailScreen extends StatefulWidget {
  final String char;
  const CharDetailScreen({super.key, required this.char});

  @override
  State<CharDetailScreen> createState() => _CharDetailScreenState();
}

class _CharDetailScreenState extends State<CharDetailScreen> {
  bool _fav = false;
  final Set<String> _learnedToday = {};

  @override
  void initState() {
    super.initState();
    _loadFav();
    Store().markStudied(widget.char);
    _learnedToday.add(widget.char);
  }

  Future<void> _loadFav() async {
    final favs = await Store().favoriteChars();
    if (mounted) setState(() => _fav = favs.contains(widget.char));
  }

  void _toggleFav() async {
    await Store().toggleFavorite(widget.char);
    final favs = await Store().favoriteChars();
    if (mounted) setState(() => _fav = favs.contains(widget.char));
  }

  @override
  Widget build(BuildContext context) {
    final info = CHARS_UNIQUE[widget.char] ??
        CharInfo(widget.char, '这个字还在准备中。', '', '我们会尽快补充完整内容。', []);
    final strokes = info.strokes;

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
        title: Text('汉字学习', style: AppTheme.serif(size: 22, color: AppTheme.ink)),
        actions: [
          IconButton(
            icon: Icon(_fav ? Icons.star : Icons.star_border, color: AppTheme.zhe),
            onPressed: _toggleFav,
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          children: [
            // 大字 + 拼音 + 朗读
            Center(
              child: Column(
                children: [
                  Text(widget.char,
                      style: AppTheme.serif(size: 110, color: AppTheme.ink, w: FontWeight.w700)),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () => TtsService().speakChar(widget.char),
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: const Color(0xFFD8CDB4)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(info.py,
                              style: AppTheme.serif(size: 28, color: AppTheme.dai)),
                          const SizedBox(width: 10),
                          Icon(Icons.volume_up, color: AppTheme.dai),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 笔顺：用正楷笔画名称
            _sectionTitle('笔顺'),
            const SizedBox(height: 8),
            if (strokes.isEmpty)
              Text('这个字暂时没有笔顺数据，先用眼睛看、用手指在空中写。',
                  style: AppTheme.sans(size: 16, color: AppTheme.ink2))
            else
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFD8CDB4)),
                ),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: List.generate(strokes.length, (i) {
                    return InkWell(
                      onTap: () => TtsService().speak('第${i + 1}笔，${strokes[i]}'),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F0E6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('${i + 1}. ${strokes[i]}',
                            style: AppTheme.sans(size: 16, color: AppTheme.ink)),
                      ),
                    );
                  }),
                ),
              ),
            const SizedBox(height: 24),

            // 释义
            _sectionTitle('意思'),
            const SizedBox(height: 8),
            Text(info.mean, style: AppTheme.sans(size: 18, color: AppTheme.ink, h: 1.7)),
            const SizedBox(height: 24),

            // 例词例句
            _sectionTitle('常用词'),
            const SizedBox(height: 8),
            Text(info.ex, style: AppTheme.serif(size: 20, color: AppTheme.dai)),
            const SizedBox(height: 16),
            _sectionTitle('例句'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFD8CDB4)),
              ),
              child: Text(info.sent, style: AppTheme.serif(size: 20, color: AppTheme.ink, h: 1.8)),
            ),
            const SizedBox(height: 28),

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
}

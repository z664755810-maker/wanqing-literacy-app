import 'package:flutter/material.dart';
import 'package:wanqing_shizi/data/content.dart';
import 'package:wanqing_shizi/screens/char_detail_screen.dart';
import 'package:wanqing_shizi/services/tts_service.dart';
import 'package:wanqing_shizi/theme/app_theme.dart';

/// 词条详情页：节气名、节日名、词组等
class TermDetailScreen extends StatelessWidget {
  final TermInfo info;
  const TermDetailScreen({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
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
        title: Text(info.tag, style: AppTheme.serif(size: 20, color: AppTheme.ink)),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          children: [
            Center(
              child: Column(
                children: [
                  Text(info.term,
                      style: AppTheme.serif(size: 64, color: AppTheme.dai, w: FontWeight.w700)),
                  const SizedBox(height: 12),
                  Text(info.py, style: AppTheme.serif(size: 26, color: AppTheme.ink2)),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => TtsService().speak(info.term),
                    icon: Icon(Icons.volume_up, color: AppTheme.paper),
                    label: Text('朗读词条', style: AppTheme.sans(size: 17, color: AppTheme.paper)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.dai,
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            _sectionTitle('意思'),
            const SizedBox(height: 8),
            Text(info.meaning, style: AppTheme.sans(size: 18, color: AppTheme.ink, h: 1.7)),
            const SizedBox(height: 24),
            _sectionTitle('例句'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFD8CDB4)),
              ),
              child: Text(info.sentence,
                  style: AppTheme.serif(size: 20, color: AppTheme.ink, h: 1.8)),
            ),
            const SizedBox(height: 24),
            _sectionTitle('组成单字（点字可学）'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: info.chars.map((c) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => CharDetailScreen(char: c)));
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFD8CDB4)),
                    ),
                    child: Center(
                      child: Text(c,
                          style: AppTheme.serif(size: 32, color: AppTheme.ink, w: FontWeight.w600)),
                    ),
                  ),
                );
              }).toList(),
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
}

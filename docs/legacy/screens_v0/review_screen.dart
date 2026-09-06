import 'dart:math';
import 'package:flutter/material.dart';
import 'package:wanqing_shizi/data/content.dart';
import 'package:wanqing_shizi/screens/char_detail_screen.dart';
import 'package:wanqing_shizi/services/store.dart';
import 'package:wanqing_shizi/services/tts_service.dart';
import 'package:wanqing_shizi/theme/app_theme.dart';

/// 复习模块：听音辨字 + 今日复习列表
class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final _rnd = Random();
  List<String> _pool = [];
  String _ans = '';
  List<String> _opts = [];
  bool _answered = false;
  String _feedback = '';
  int _streak = 0;

  @override
  void initState() {
    super.initState();
    _buildPool();
  }

  Future<void> _buildPool() async {
    _pool = await Store().reviewPool();
    if (_pool.isEmpty) {
      // 没有到期复习的，就从收藏里抽，再不行从系统课程抽
      final favs = await Store().favoriteChars();
      _pool = favs.toList();
      if (_pool.length < 4) {
        _pool = SYS_CATS.expand((c) => c.list).toList();
      }
    }
    _pool = _pool.toSet().toList();
    if (_pool.length >= 4) _next();
    if (mounted) setState(() {});
  }

  void _next() {
    if (_pool.length < 4) return;
    _ans = _pool[_rnd.nextInt(_pool.length)];
    final set = <String>{_ans};
    while (set.length < 4) {
      final x = _pool[_rnd.nextInt(_pool.length)];
      if (x != _ans) set.add(x);
    }
    _opts = set.toList()..shuffle();
    _feedback = '';
    _answered = false;
    // 朗读题目：先给一点提示
    TtsService().speak('请听音，选择正确的字');
    Future.delayed(const Duration(milliseconds: 800), () {
      TtsService().speakChar(_ans);
    });
    if (mounted) setState(() {});
  }

  void _answer(String c) {
    if (_answered) return;
    _answered = true;
    final correct = c == _ans;
    if (correct) {
      _streak++;
      _feedback = '对！就是「$_ans」${CHARS_UNIQUE[_ans]?.py ?? ''}';
      Store().recordReview(_ans, true);
    } else {
      _streak = 0;
      _feedback = '不对，正确答案是「$_ans」${CHARS_UNIQUE[_ans]?.py ?? ''}';
      Store().recordReview(_ans, false);
    }
    TtsService().speak(_feedback);
    if (mounted) setState(() {});
  }

  Color _optColor(String c) {
    if (!_answered) return AppTheme.ink;
    if (c == _ans) return const Color(0xFF2E7D32);
    return AppTheme.ink2.withValues(alpha: 0.4);
  }

  Color _optBg(String c) {
    if (!_answered) return Colors.white;
    if (c == _ans) return const Color(0xFFE8F5E9);
    return const Color(0xFFF5F5F5);
  }

  @override
  Widget build(BuildContext context) {
    if (_pool.length < 4) {
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
          title: Text('复习巩固', style: AppTheme.serif(size: 22, color: AppTheme.ink)),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('复习池里的字还不够',
                    style: AppTheme.serif(size: 24, color: AppTheme.ink)),
                const SizedBox(height: 12),
                Text('先去“汉字课堂”学几个字，再来复习。',
                    textAlign: TextAlign.center,
                    style: AppTheme.sans(size: 16, color: AppTheme.ink2)),
              ],
            ),
          ),
        ),
      );
    }

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
        title: Text('复习巩固', style: AppTheme.serif(size: 22, color: AppTheme.ink)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('复习巩固', style: AppTheme.serif(size: 30, color: AppTheme.ink, w: FontWeight.w700)),
              const SizedBox(height: 8),
              Text('听读音，选出听到的字。', style: AppTheme.sans(size: 16, color: AppTheme.ink2)),
              const SizedBox(height: 24),

              // 听音区
              Center(
                child: InkWell(
                  onTap: () => TtsService().speakChar(_ans),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 28),
                    decoration: BoxDecoration(
                      color: AppTheme.dai,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.volume_up, size: 48, color: AppTheme.paper),
                        const SizedBox(height: 10),
                        Text('再听一遍', style: AppTheme.sans(size: 18, color: AppTheme.paper)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 选项
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 1.4,
                children: _opts.map((c) {
                  return InkWell(
                    onTap: () => _answer(c),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: _optBg(c),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _answered && c == _ans
                              ? const Color(0xFF4CAF50)
                              : const Color(0xFFD8CDB4),
                          width: _answered && c == _ans ? 2 : 1,
                        ),
                      ),
                      child: Center(
                        child: Text(c,
                            style: AppTheme.serif(size: 48, color: _optColor(c), w: FontWeight.w600)),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // 反馈
              if (_feedback.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _feedback.startsWith('对') ? const Color(0xFFE8F5E9) : const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(_feedback,
                      style: AppTheme.sans(
                          size: 17,
                          color: _feedback.startsWith('对') ? const Color(0xFF2E7D32) : const Color(0xFFE65100))),
                ),
              const SizedBox(height: 16),

              // 下一题 / 查看详情
              if (_answered)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => CharDetailScreen(char: _ans)));
                        },
                        icon: Icon(Icons.book, color: AppTheme.dai),
                        label: Text('去学这个字', style: AppTheme.sans(size: 16, color: AppTheme.dai)),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppTheme.dai),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _next,
                        icon: Icon(Icons.arrow_forward, color: AppTheme.paper),
                        label: Text('下一题', style: AppTheme.sans(size: 16, color: AppTheme.paper)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.dai,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 24),
              Text('连续答对：$_streak 题', style: AppTheme.sans(size: 14, color: AppTheme.ink2)),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

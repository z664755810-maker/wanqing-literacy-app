import 'package:flutter/material.dart';
import 'package:wanqing_shizi/data/content.dart';
import 'package:wanqing_shizi/services/tts_service.dart';
import 'package:wanqing_shizi/theme/app_theme.dart';
import 'package:wanqing_shizi/widgets/app_bottom_nav.dart';

/// 每日阅读：成语故事 / 寓言故事 / 生活短文
class ReadScreen extends StatelessWidget {
  const ReadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('每日阅读')),
      bottomNavigationBar: const AppBottomNav(3),
      body: ListView.separated(
        padding: const EdgeInsets.all(18),
        itemCount: STORIES.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (_, i) {
          final s = STORIES[i];
          final preview = s.paragraphs.join('');
          final prev = preview.length > 42 ? '${preview.substring(0, 42)}……' : preview;
          return Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: const BorderSide(color: Color(0xFFD8CDB4)),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => StoryDetailScreen(story: s)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s.title, style: AppTheme.serif(size: 22, color: AppTheme.ink, w: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(s.titlePy, style: AppTheme.serif(size: 14, color: AppTheme.ink2)),
                    const SizedBox(height: 4),
                    Text(s.tag, style: AppTheme.serif(size: 12, color: AppTheme.zhe)),
                    const SizedBox(height: 10),
                    Text(prev, style: AppTheme.serif(size: 15, color: AppTheme.ink2)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// 阅读详情：逐字拼音 + 点字发音 + 分段朗读
class StoryDetailScreen extends StatefulWidget {
  final Story story;
  const StoryDetailScreen({super.key, required this.story});

  @override
  State<StoryDetailScreen> createState() => _StoryDetailScreenState();
}

class _StoryDetailScreenState extends State<StoryDetailScreen> {
  int _startIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.story.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(22),
          children: [
            Text(widget.story.titlePy, style: AppTheme.serif(size: 16, color: AppTheme.ink2)),
            const SizedBox(height: 4),
            Text(widget.story.tag, style: AppTheme.serif(size: 13, color: AppTheme.zhe)),
            const SizedBox(height: 20),

            // 分段文章，每段逐字带拼音
            ...List.generate(widget.story.paragraphs.length, (i) {
              final isStart = i == _startIndex;
              final para = widget.story.paragraphs[i];
              return Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: InkWell(
                  onTap: () => _readFrom(i),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isStart ? const Color(0xFFE8F5E9) : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isStart ? const Color(0xFF81C784) : const Color(0xFFD8CDB4),
                        width: isStart ? 1.5 : 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _pinyinParagraph(para),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.play_arrow, size: 18, color: AppTheme.dai),
                            const SizedBox(width: 4),
                            Text('从这里开始读', style: AppTheme.sans(size: 15, color: AppTheme.dai, w: FontWeight.w500)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => TtsService().speak(widget.story.paragraphs.sublist(_startIndex).join('')),
                icon: const Icon(Icons.volume_up),
                label: const Text('从标记处整篇朗读'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.dai,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => setState(() => _startIndex = 0),
                icon: Icon(Icons.replay, color: AppTheme.dai),
                label: Text('从头开始', style: TextStyle(color: AppTheme.dai, fontSize: 16)),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppTheme.dai),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _readFrom(int index) {
    setState(() => _startIndex = index);
    TtsService().speak(widget.story.paragraphs[index]);
  }

  /// 把一段文字按字拆成“拼音在上、汉字在下”的块
  Widget _pinyinParagraph(String text) {
    return Wrap(
      spacing: 4,
      runSpacing: 10,
      crossAxisAlignment: WrapCrossAlignment.end,
      children: text.runes.map((r) {
        final ch = String.fromCharCode(r);
        final py = _lookupPinyin(ch);
        final isPunct = RegExp(r'[。，、！？：；""''（）]').hasMatch(ch);
        if (isPunct) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Text(ch, style: AppTheme.serif(size: 22, color: AppTheme.ink2)),
          );
        }
        return InkWell(
          onTap: () => TtsService().speakChar(ch),
          borderRadius: BorderRadius.circular(4),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(py.isEmpty ? ' ' : py,
                    style: AppTheme.sans(size: 11, color: AppTheme.dai, w: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(ch, style: AppTheme.serif(size: 26, color: AppTheme.ink, w: FontWeight.w600)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  /// 查单字拼音：优先用内置字典，否则返回空
  String _lookupPinyin(String ch) {
    final info = CHARS_UNIQUE[ch];
    if (info != null) return info.py;
    // 尝试词条中找
    for (final t in TERMS.values) {
      for (int i = 0; i < t.term.length; i++) {
        if (t.term[i] == ch) {
          // 从拼音字符串中切出对应位置
          final pyParts = t.py.split(' ');
          int idx = 0;
          for (int j = 0; j < t.term.length; j++) {
            if (t.term[j] == ch && idx < pyParts.length) {
              // 简单返回第一个匹配
              return pyParts[idx];
            }
            if (t.term[j] != ' ') idx++;
          }
        }
      }
    }
    return '';
  }
}

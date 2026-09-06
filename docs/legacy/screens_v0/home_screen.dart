import 'package:flutter/material.dart';
import 'package:wanqing_shizi/theme/app_theme.dart';
import 'package:wanqing_shizi/services/store.dart';
import 'package:wanqing_shizi/widgets/app_bottom_nav.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final today = Store().todayCount;
    final streak = Store().streak;
    return Scaffold(
      appBar: AppBar(
        title: const Text('晚晴识字'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text('今日已学 $today · 连续 $streak 天',
                  style: AppTheme.serif(size: 14, color: AppTheme.ink2)),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Color(0xFFD8CDB4)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 22),
                child: Column(
                  children: [
                    Text('人 间 重 晚 晴',
                        style: AppTheme.serif(size: 16, color: AppTheme.zhe)),
                    const SizedBox(height: 8),
                    Text('晚晴识字',
                        style: AppTheme.serif(
                            size: 56, color: AppTheme.dai, w: FontWeight.w700)),
                    const SizedBox(height: 12),
                    Text('每天学一点，慢慢就熟了。',
                        style: AppTheme.serif(size: 18, color: AppTheme.ink),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 6),
                    Text('拼音是钥匙，汉字是门，日子里的故事就是回家的路。',
                        style: AppTheme.serif(size: 15, color: AppTheme.ink2),
                        textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 22),
            Wrap(
              spacing: 14,
              runSpacing: 14,
              children: const [
                _HomeCard('/pinyin', '拼音课堂', '声母、韵母逐个学，点击听发音、看口型',
                    Icons.record_voice_over_outlined),
                _HomeCard('/hanzi', '汉字课堂', '系统课程 + 二十四节气 / 神仙民俗 / 老家河南',
                    Icons.menu_book_outlined),
                _HomeCard('/read', '每日阅读', '烧香、念佛、过年、老家——字从生活里来',
                    Icons.auto_stories_outlined),
                _HomeCard('/review', '复习巩固', '听音辨字 · 手写温习 · 按时提醒',
                    Icons.replay_outlined),
              ],
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFBF6E9),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Color(0xFFD8CDB4)),
              ),
              child: Text(
                '提示：本版用平板系统朗读，正式版会内置更自然、更像真人老师的发音；'
                '声母（如 zh）点击后播放的是真实音节示例，不会被拆成字母念。',
                style: AppTheme.serif(size: 13, color: AppTheme.ink2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeCard extends StatelessWidget {
  final String route;
  final String title;
  final String desc;
  final IconData icon;
  const _HomeCard(this.route, this.title, this.desc, this.icon);

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return SizedBox(
      width: (w - 22 * 2 - 14) / 2,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: Color(0xFFD8CDB4)),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => Navigator.pushNamed(context, route),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 30, color: AppTheme.dai),
                const SizedBox(height: 10),
                Text(title, style: AppTheme.serif(size: 20, color: AppTheme.ink)),
                const SizedBox(height: 6),
                Text(desc, style: AppTheme.serif(size: 13, color: AppTheme.ink2)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

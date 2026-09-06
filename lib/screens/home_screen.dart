import 'package:flutter/material.dart';

import '../app_router.dart';
import '../data/char_library.dart';
import '../data/lessons.dart';
import '../state/app_state.dart';
import '../theme/app_dimens.dart';
import '../theme/app_theme.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/big_button.dart';

/// 首页「今天学什么」：继续上次学习 / 今日待复习 / 累计学会字数。
///
/// 数据来自 [AppState]（全局单例 + ChangeNotifier），用 [ListenableBuilder] 订阅，
/// 复习/学字后首页数字实时刷新。
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppDimens d = AppDimens.of(context);
    final AppState app = AppState.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text('晚晴识字', style: AppTheme.serif(size: d.fs(26))),
        actions: <Widget>[
          IconButton(
            iconSize: d.fs(30),
            tooltip: '设置',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.pushNamed(context, AppRouter.settings),
          ),
        ],
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: app,
          builder: (BuildContext context, _) {
            final int due = app.dueCount;
            final int learned = app.progress.learnedCount;
            final int todayNew = app.progress.todayNewCount;
            final Lesson cont = lessonOf(app.progress.unlockedLesson);
            return ListView(
              padding: EdgeInsets.all(d.pagePad),
              children: <Widget>[
                Text('今天学点什么', style: AppTheme.serif(size: d.fs(34), w: FontWeight.w600)),
                SizedBox(height: d.fs(AppDimens.gapL)),
                _ProgressCard(d: d, learned: learned, total: kCharLibrarySize),
                SizedBox(height: d.fs(AppDimens.gapM)),
                _HomeCard(
                  d: d,
                  subtitle: '继续学习',
                  title: '第 ${cont.id} 课 · ${cont.chars.join(" ")}',
                  onTap: () => Navigator.pushNamed(context, AppRouter.lesson, arguments: cont.id),
                ),
                SizedBox(height: d.fs(AppDimens.gapM)),
                _HomeCard(
                  d: d,
                  subtitle: '复习专区',
                  title: due > 0 ? '今天复习 $due 个字' : '今天没有要复习的字',
                  onTap: () => Navigator.pushNamed(context, AppRouter.review),
                ),
                SizedBox(height: d.fs(AppDimens.gapM)),
                _HomeCard(
                  d: d,
                  subtitle: '故事屋（点字听读）',
                  title: '哪吒闹海 · 大闹天宫 · 白蛇传…',
                  onTap: () => Navigator.pushNamed(context, AppRouter.storyShelf),
                ),
                SizedBox(height: d.fs(AppDimens.gapM)),
                _HomeCard(
                  d: d,
                  subtitle: '我的字库',
                  title: '已学会 $learned 个字${todayNew > 0 ? '（今日 +$todayNew）' : ''}',
                  onTap: () => Navigator.pushNamed(context, AppRouter.library),
                ),
                SizedBox(height: d.fs(AppDimens.gapL)),
                BigButton(
                  label: learned == 0 ? '开始学习' : '继续学习',
                  icon: Icons.school_outlined,
                  onTap: () => Navigator.pushNamed(context, AppRouter.lesson, arguments: cont.id),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: AppBottomNav(AppBottomNav.indexOfRoute(AppRouter.home)),
    );
  }
}

/// 首页学习进度条：已学 / 总字数 + 温和鼓励语，给妈妈看得见的成就感。
class _ProgressCard extends StatelessWidget {
  final AppDimens d;
  final int learned;
  final int total;

  const _ProgressCard({required this.d, required this.learned, required this.total});

  @override
  Widget build(BuildContext context) {
    final double p = total == 0 ? 0 : (learned / total).clamp(0.0, 1.0);
    final String cheer = learned == 0
        ? '刚起步，咱们慢慢来'
        : (p >= 1 ? '全部学会啦，真了不起！' : '已经学会 $learned 个字，继续加油');
    return Card(
      child: Padding(
        padding: EdgeInsets.all(d.fs(AppDimens.gapM)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(child: Text('学习进度', style: AppTheme.sans(size: d.fs(16), color: AppTheme.zhe))),
                Text('$learned / $total', style: AppTheme.serif(size: d.fs(18), w: FontWeight.w600)),
              ],
            ),
            SizedBox(height: d.fs(AppDimens.gapS)),
            LinearProgressIndicator(
              value: p,
              minHeight: d.fs(14),
              backgroundColor: AppTheme.paper2,
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.dai),
            ),
            SizedBox(height: d.fs(AppDimens.gapS)),
            Text(cheer, style: AppTheme.serif(size: d.fs(18), color: AppTheme.ink2)),
          ],
        ),
      ),
    );
  }
}

/// 首页信息卡片（点击进入对应模块）。
class _HomeCard extends StatelessWidget {
  final AppDimens d;
  final String subtitle;
  final String title;
  final VoidCallback onTap;

  const _HomeCard({required this.d, required this.subtitle, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimens.radius),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(d.fs(AppDimens.gapM)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(subtitle, style: AppTheme.sans(size: d.fs(16), color: AppTheme.zhe)),
              SizedBox(height: d.fs(AppDimens.gapXs)),
              Text(title, style: AppTheme.serif(size: d.fs(24), w: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

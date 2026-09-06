import 'package:flutter/material.dart';

import '../app_router.dart';
import '../data/char_library.dart';
import '../services/review_service.dart';
import '../services/progress_service.dart';
import '../state/app_state.dart';
import '../theme/app_dimens.dart';
import '../theme/app_theme.dart';
import '../widgets/app_bottom_nav.dart';

/// 智能复习：到期队列（1/3/7/30 天四档）+ 复习专区（手动选任意已学字复盘）。
///
/// 到期队列来自 [ReviewService.buildQueue]；点「记住了/忘了，再学」即时回写进度，
/// 并通知 [AppState] 刷新首页到期数。复习专区列出全部已学字（含毕业熟字），点字进详情。
class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  late List<String> _due;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
    _due = ReviewService.buildQueue(AppState.instance.progress);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  Future<void> _onResult(String c, bool ok) async {
    await ReviewService.recordResult(c, ok, AppState.instance.progress);
    AppState.instance.refreshDue();
    setState(() {
      _due.remove(c);
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppDimens d = AppDimens.of(context);
    final AppState app = AppState.instance;
    final int learned = app.progress.learnedCount;
    return Scaffold(
      appBar: AppBar(
        title: Text('复习', style: AppTheme.serif(size: d.fs(26))),
        bottom: TabBar(
          controller: _tabs,
          labelStyle: AppTheme.serif(size: d.fs(18), w: FontWeight.w600),
          unselectedLabelStyle: AppTheme.serif(size: d.fs(18)),
          labelColor: AppTheme.dai,
          unselectedLabelColor: AppTheme.ink2,
          indicatorColor: AppTheme.dai,
          tabs: <Widget>[
            Tab(text: '到期复习 (${_due.length})'),
            Tab(text: '复习专区 ($learned)'),
          ],
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabs,
          children: <Widget>[
            _buildDue(d),
            _buildPool(d, app),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNav(AppBottomNav.indexOfRoute(AppRouter.review)),
    );
  }

  Widget _buildDue(AppDimens d) {
    if (_due.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.spa_outlined, size: d.fs(72), color: AppTheme.dai),
            SizedBox(height: d.fs(AppDimens.gapM)),
            Text('今天复习完啦，真棒！', style: AppTheme.serif(size: d.fs(24))),
          ],
        ),
      );
    }
    return ListView(
      padding: EdgeInsets.all(d.pagePad),
      children: <Widget>[
        for (final String c in _due) ...<Widget>[
          _DueCard(char: c, d: d, onResult: _onResult),
          SizedBox(height: d.fs(AppDimens.gapM)),
        ],
      ],
    );
  }

  Widget _buildPool(AppDimens d, AppState app) {
    final List<String> pool = ReviewService.manualPool(app.progress);
    if (pool.isEmpty) {
      return Center(
        child: Text('先去学几个字，再来这里复习哦', style: AppTheme.serif(size: d.fs(22))),
      );
    }
    return GridView.count(
      crossAxisCount: 4,
      padding: EdgeInsets.all(d.pagePad),
      mainAxisSpacing: d.fs(AppDimens.gapM),
      crossAxisSpacing: d.fs(AppDimens.gapM),
      childAspectRatio: 1,
      children: <Widget>[
        for (final String c in pool) _PoolTile(char: c, d: d),
      ],
    );
  }
}

/// 到期复习卡片：超大汉字 + 拼音 + 「记住了 / 忘了，再学」。
class _DueCard extends StatelessWidget {
  final String char;
  final AppDimens d;
  final Future<void> Function(String, bool) onResult;

  const _DueCard({required this.char, required this.d, required this.onResult});

  @override
  Widget build(BuildContext context) {
    final CharCard? card = kCharLibrary[char];
    return Card(
      child: Padding(
        padding: EdgeInsets.all(d.fs(AppDimens.gapM)),
        child: Column(
          children: <Widget>[
            Text(char, style: AppTheme.serif(size: d.fs(AppDimens.fsHeroChar * 0.6))),
            SizedBox(height: d.fs(AppDimens.gapS)),
            if (card != null) Text(card.pinyin, style: AppTheme.sans(size: d.fs(22), color: AppTheme.zhe)),
            SizedBox(height: d.fs(AppDimens.gapM)),
            Row(
              children: <Widget>[
                Expanded(child: _ResultBtn(d: d, label: '记住了', primary: true, onTap: () => onResult(char, true))),
                SizedBox(width: d.fs(AppDimens.gapM)),
                Expanded(child: _ResultBtn(d: d, label: '忘了，再学', primary: false, onTap: () => onResult(char, false))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultBtn extends StatelessWidget {
  final AppDimens d;
  final String label;
  final bool primary;
  final VoidCallback onTap;

  const _ResultBtn({required this.d, required this.label, required this.primary, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final Color accent = primary ? AppTheme.dai : AppTheme.zhe;
    return Material(
      color: primary ? accent : AppTheme.paper,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.radius), side: BorderSide(color: accent, width: 2)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.radius),
        child: Container(
          constraints: BoxConstraints(minHeight: d.touch),
          alignment: Alignment.center,
          child: Text(label, style: AppTheme.serif(size: d.fs(22), color: primary ? Colors.white : accent, w: FontWeight.w700)),
        ),
      ),
    );
  }
}

/// 复习专区瓦片：已学字（含毕业熟字），点字进详情。
class _PoolTile extends StatelessWidget {
  final String char;
  final AppDimens d;

  const _PoolTile({required this.char, required this.d});

  @override
  Widget build(BuildContext context) {
    bool graduated = false;
    for (final ProgressEntry e in AppState.instance.progress.entries) {
      if (e.char == char) {
        graduated = e.isGraduated;
        break;
      }
    }
    return Material(
      color: graduated ? AppTheme.daiSoft : AppTheme.paper,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.radius), side: const BorderSide(color: AppTheme.line, width: 1)),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, AppRouter.charDetail, arguments: char),
        borderRadius: BorderRadius.circular(AppDimens.radius),
        child: Stack(
          children: <Widget>[
            Center(child: Text(char, style: AppTheme.serif(size: d.fs(48), w: FontWeight.w500))),
            if (graduated)
              Positioned(
                top: d.fs(AppDimens.gapS),
                right: d.fs(AppDimens.gapS),
                child: Icon(Icons.verified_outlined, size: d.fs(22), color: AppTheme.dai),
              ),
          ],
        ),
      ),
    );
  }
}

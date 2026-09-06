import 'package:flutter/material.dart';

import '../app_router.dart';
import '../data/char_library.dart';
import '../state/app_state.dart';
import '../theme/app_dimens.dart';
import '../theme/app_theme.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/char_pic.dart';
import '../widgets/gentle_hint.dart';

/// 「我的」字库：已学 / 未学分栏。
///
/// - 已学会：可自由点进单字详情回看。
/// - 未学会：**不可进入学习（不可跳学）**，点一下只温和提醒「先学完前面的课」。
/// 数据来自 [AppState]（全局单例 + ChangeNotifier），用 [ListenableBuilder] 订阅，学字后实时刷新。
class HanziScreen extends StatelessWidget {
  const HanziScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppDimens d = AppDimens.of(context);
    final AppState app = AppState.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text('我的', style: AppTheme.serif(size: d.fs(26))),
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
            final Set<String> learned = app.progress.learnedChars;
            final List<String> learnedList = learned.toList();
            final List<String> unlearned = kCharLibrary.keys.where((String c) => !learned.contains(c)).toList();
            final List<String> marks = app.getMarks();
            return DefaultTabController(length: 3,
              child: Column(
                children: <Widget>[
                  TabBar(
                    labelStyle: AppTheme.serif(size: d.fs(18), w: FontWeight.w600),
                    unselectedLabelStyle: AppTheme.serif(size: d.fs(18)),
                    labelColor: AppTheme.dai,
                    unselectedLabelColor: AppTheme.ink2,
                    indicatorColor: AppTheme.dai,
                    tabs: <Widget>[
                      Tab(text: '已学会 (${learnedList.length})'),
                      Tab(text: '未学会 (${unlearned.length})'),
                      Tab(text: '我圈的字 (${marks.length})'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: <Widget>[
                        _LearnedGrid(d: d, chars: learnedList),
                        _UnlearnedGrid(d: d, chars: unlearned),
                        _MarksGrid(d: d, chars: marks),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: AppBottomNav(AppBottomNav.indexOfRoute(AppRouter.library)),
    );
  }
}

/// 已学会：可点进详情。
class _LearnedGrid extends StatelessWidget {
  final AppDimens d;
  final List<String> chars;

  const _LearnedGrid({required this.d, required this.chars});

  @override
  Widget build(BuildContext context) {
    if (chars.isEmpty) {
      return Center(child: Text('还没有学会的字，去「学习」里认几个吧', style: AppTheme.serif(size: d.fs(22))));
    }
    return GridView.count(
      crossAxisCount: 4,
      padding: EdgeInsets.all(d.pagePad),
      mainAxisSpacing: d.fs(AppDimens.gapM),
      crossAxisSpacing: d.fs(AppDimens.gapM),
      childAspectRatio: 1,
      children: <Widget>[
        for (final String c in chars)
          Material(
            color: AppTheme.daiSoft,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.radius), side: BorderSide(color: AppTheme.dai.withValues(alpha: 0.4), width: 1)),
            child: InkWell(
              onTap: () => Navigator.pushNamed(context, AppRouter.charDetail, arguments: c),
              borderRadius: BorderRadius.circular(AppDimens.radius),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CharPic(card: kCharLibrary[c]!, height: d.fs(54), width: d.fs(54)),
                  SizedBox(height: d.fs(4)),
                  Text(c, style: AppTheme.serif(size: d.fs(34), w: FontWeight.w500)),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// 未学会：灰显，**不可进入学习**；点一下温和提醒。
class _UnlearnedGrid extends StatefulWidget {
  final AppDimens d;
  final List<String> chars;

  const _UnlearnedGrid({required this.d, required this.chars});

  @override
  State<_UnlearnedGrid> createState() => _UnlearnedGridState();
}

class _UnlearnedGridState extends State<_UnlearnedGrid> {
  bool _lockedNotice = false;

  @override
  Widget build(BuildContext context) {
    final AppDimens d = widget.d;
    if (widget.chars.isEmpty) {
      return Center(child: Text('全部字都学会啦，了不起！', style: AppTheme.serif(size: d.fs(22))));
    }
    return Column(
      children: <Widget>[
        if (_lockedNotice)
          Padding(
            padding: EdgeInsets.fromLTRB(d.pagePad, d.pagePad, d.pagePad, 0),
            child: const GentleHint(message: '这个字还没学呢，先按课学完前面的字吧'),
          ),
        Expanded(
          child: GridView.count(
            crossAxisCount: 4,
            padding: EdgeInsets.all(d.pagePad),
            mainAxisSpacing: d.fs(AppDimens.gapM),
            crossAxisSpacing: d.fs(AppDimens.gapM),
            childAspectRatio: 1,
            children: <Widget>[
              for (final String c in widget.chars)
                Material(
                  color: AppTheme.paper2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.radius), side: const BorderSide(color: AppTheme.line, width: 1)),
                  child: InkWell(
                    onTap: () => setState(() => _lockedNotice = true),
                    borderRadius: BorderRadius.circular(AppDimens.radius),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Opacity(
                          opacity: 0.55,
                          child: CharPic(card: kCharLibrary[c]!, height: d.fs(54), width: d.fs(54)),
                        ),
                        SizedBox(height: d.fs(4)),
                        Text(c, style: AppTheme.serif(size: d.fs(34), color: AppTheme.ink2.withValues(alpha: 0.55), w: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// 「我圈的字」：读故事时点「圈生字」收进来的自标字（可含字库外的字）。
///
/// 点卡片进单字详情（字库外字走兜底页）；右上角 × 取消圈选（零惩罚、无二次确认）；
/// 字库外的字标「字库外」角标。列表随 [AppState] 实时刷新（删除即消失）。
class _MarksGrid extends StatefulWidget {
  final AppDimens d;
  final List<String> chars;

  const _MarksGrid({required this.d, required this.chars});

  @override
  State<_MarksGrid> createState() => _MarksGridState();
}

class _MarksGridState extends State<_MarksGrid> {
  bool _justRemoved = false;

  @override
  Widget build(BuildContext context) {
    final AppDimens d = widget.d;
    final AppState app = AppState.instance;
    if (widget.chars.isEmpty) {
      return Center(child: Text('读书时遇到不认识的字，点「圈生字」就能收进来', style: AppTheme.serif(size: d.fs(22))));
    }
    return Column(
      children: <Widget>[
        if (_justRemoved)
          Padding(
            padding: EdgeInsets.fromLTRB(d.pagePad, d.pagePad, d.pagePad, 0),
            child: const GentleHint(message: '已经取消圈选'),
          ),
        Expanded(
          child: GridView.count(
            crossAxisCount: 4,
            padding: EdgeInsets.all(d.pagePad),
            mainAxisSpacing: d.fs(AppDimens.gapM),
            crossAxisSpacing: d.fs(AppDimens.gapM),
            childAspectRatio: 1,
            children: <Widget>[
              for (final String c in widget.chars)
                _MarkCell(
                  d: d,
                  char: c,
                  inLib: kCharLibrary.containsKey(c),
                  onRemove: () {
                    setState(() => _justRemoved = true);
                    app.removeMark(c);
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// 单个「我圈的字」卡片：大字 + 配图（字库内），点进学习；右上角 × 移除；字库外标「字库外」。
class _MarkCell extends StatelessWidget {
  final AppDimens d;
  final String char;
  final bool inLib;
  final VoidCallback onRemove;

  const _MarkCell({required this.d, required this.char, required this.inLib, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.daiSoft,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radius),
        side: BorderSide(color: AppTheme.dai.withValues(alpha: 0.4), width: 1),
      ),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, AppRouter.charDetail, arguments: char),
        borderRadius: BorderRadius.circular(AppDimens.radius),
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (inLib)
                  CharPic(card: kCharLibrary[char]!, height: d.fs(54), width: d.fs(54))
                else
                  SizedBox(height: d.fs(54), width: d.fs(54)),
                SizedBox(height: d.fs(4)),
                Text(char, style: AppTheme.serif(size: d.fs(34), w: FontWeight.w500)),
              ],
            ),
            // 字库外角标（左上，弱化处理）
            if (!inLib)
              Positioned(
                top: d.fs(4),
                left: d.fs(6),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: d.fs(6), vertical: d.fs(2)),
                  decoration: BoxDecoration(
                    color: AppTheme.ink2.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppDimens.radiusSm),
                  ),
                  child: Text('字库外', style: AppTheme.serif(size: d.fs(12), color: AppTheme.ink2)),
                ),
              ),
            // 右上角 × 移除：热区 ≥48dp（d.touch 默认 64）；与卡片点击互不干扰（× 在 Stack 上层先吃事件）
            Positioned(
              top: 0,
              right: 0,
              child: SizedBox(
                width: d.touch,
                height: d.touch,
                child: InkWell(
                  onTap: onRemove,
                  borderRadius: BorderRadius.circular(AppDimens.radius),
                  child: Center(
                    child: Icon(Icons.close, size: d.fs(22), color: AppTheme.ink2),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

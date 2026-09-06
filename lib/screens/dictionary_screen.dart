import 'package:flutter/material.dart';

import '../app_router.dart';
import '../data/char_library.dart';
import '../theme/app_dimens.dart';
import '../theme/app_theme.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/char_pic.dart';

/// 字典：按课序（1–20）浏览**全部**生字，作为随时查字的工具。
///
/// 与「我的」页（学习进度）职责分开：这里不做已学/未学判断，
/// 60 个字全部可点开看 读音/释义/词组/例句/笔顺，是妈妈的「查字本」。
class DictionaryScreen extends StatelessWidget {
  const DictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppDimens d = AppDimens.of(context);

    // 按课号聚合（kCharLibrary 已按课序插入，这里再显式排一次更稳）
    final Map<int, List<CharCard>> byLesson = <int, List<CharCard>>{};
    for (final CharCard c in kCharLibrary.values) {
      (byLesson[c.lessonId] ??= <CharCard>[]).add(c);
    }
    final List<int> lessons = byLesson.keys.toList()..sort();

    return Scaffold(
      appBar: AppBar(
        title: Text('字典', style: AppTheme.serif(size: d.fs(26))),
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
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: d.fs(AppDimens.gapM)),
          children: <Widget>[
            for (final int lid in lessons) ...<Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(d.pagePad, d.fs(AppDimens.gapM), d.pagePad, d.fs(AppDimens.gapS)),
                child: Text('第 $lid 课', style: AppTheme.serif(size: d.fs(22), w: FontWeight.w700, color: AppTheme.dai)),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: d.pagePad),
                child: GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: d.fs(AppDimens.gapM),
                  crossAxisSpacing: d.fs(AppDimens.gapM),
                  childAspectRatio: 0.92,
                  children: <Widget>[
                    for (final CharCard c in byLesson[lid]!) _DictTile(d: d, card: c),
                  ],
                ),
              ),
              SizedBox(height: d.fs(AppDimens.gapM)),
            ],
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNav(AppBottomNav.indexOfRoute(AppRouter.dictionary)),
    );
  }
}

/// 字典单字卡：字 + 拼音 + 释义 + 分类小标，点开看详情。
class _DictTile extends StatelessWidget {
  final AppDimens d;
  final CharCard card;

  const _DictTile({required this.d, required this.card});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.paper2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.radius), side: const BorderSide(color: AppTheme.line, width: 1)),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimens.radius),
        onTap: () => Navigator.pushNamed(context, AppRouter.charDetail, arguments: card.char),
        child: Padding(
          padding: EdgeInsets.all(d.fs(AppDimens.gapS)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CharPic(card: card, height: d.fs(76), radius: BorderRadius.circular(d.fs(AppDimens.radiusSm))),
              SizedBox(height: d.fs(4)),
              Text(card.char, style: AppTheme.serif(size: d.fs(36), w: FontWeight.w500)),
              SizedBox(height: d.fs(2)),
              Text(card.pinyin, style: AppTheme.sans(size: d.fs(15), color: AppTheme.zhe)),
              SizedBox(height: d.fs(2)),
              Text(
                card.meaning,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTheme.sans(size: d.fs(12), color: AppTheme.ink2),
              ),
              SizedBox(height: d.fs(2)),
              Container(
                padding: EdgeInsets.symmetric(horizontal: d.fs(6), vertical: d.fs(1)),
                decoration: BoxDecoration(
                  color: AppTheme.daiSoft,
                  borderRadius: BorderRadius.circular(d.fs(8)),
                ),
                child: Text(card.category, style: AppTheme.sans(size: d.fs(11), color: AppTheme.dai)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

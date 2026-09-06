import 'package:flutter/material.dart';
import 'package:wanqing_shizi/data/content.dart';
import 'package:wanqing_shizi/screens/char_detail_screen.dart';
import 'package:wanqing_shizi/screens/term_detail_screen.dart';
import 'package:wanqing_shizi/services/store.dart';
import 'package:wanqing_shizi/theme/app_theme.dart';

/// 汉字课堂：系统课程 + 文化分类（词条） + 我的收藏
class HanziScreen extends StatefulWidget {
  const HanziScreen({super.key});

  @override
  State<HanziScreen> createState() => _HanziScreenState();
}

class _HanziScreenState extends State<HanziScreen> {
  int _tab = 0; // 0 系统课程，1 文化分类，2 我的收藏
  int _sysCat = 0;
  int _culCat = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.paper,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _tabs(),
            Expanded(
              child: _tab == 0
                  ? _systemView()
                  : (_tab == 1 ? _cultureView() : _favoritesView()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabs() {
    final labels = ['系统课程', '文化分类', '我的收藏'];
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 14, 22, 8),
      child: Row(
        children: List.generate(labels.length, (i) {
          final active = _tab == i;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: i < 2 ? 10 : 0),
              child: InkWell(
                onTap: () => setState(() => _tab = i),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: active ? AppTheme.dai : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: active ? AppTheme.dai : const Color(0xFFD8CDB4)),
                  ),
                  child: Center(
                    child: Text(labels[i],
                        style: AppTheme.sans(
                            size: 16,
                            color: active ? AppTheme.paper : AppTheme.ink,
                            w: active ? FontWeight.w600 : FontWeight.normal)),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ---------- 系统课程 ----------
  Widget _systemView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 48,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 22),
            itemCount: SYS_CATS.length,
            itemBuilder: (ctx, i) {
              final active = _sysCat == i;
              return Padding(
                padding: const EdgeInsets.only(right: 10, top: 8, bottom: 8),
                child: InkWell(
                  onTap: () => setState(() => _sysCat = i),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                    decoration: BoxDecoration(
                      color: active ? AppTheme.zhe : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: active ? AppTheme.zhe : const Color(0xFFD8CDB4)),
                    ),
                    child: Center(
                      child: Text(SYS_CATS[i].cat,
                          style: AppTheme.sans(
                              size: 14,
                              color: active ? AppTheme.paper : AppTheme.ink)),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(22, 10, 22, 30),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.95,
            ),
            itemCount: SYS_CATS[_sysCat].list.length,
            itemBuilder: (ctx, i) {
              final c = SYS_CATS[_sysCat].list[i];
              return _charCell(c, onTap: () => _openChar(c));
            },
          ),
        ),
      ],
    );
  }

  // ---------- 文化分类（词条卡片） ----------
  Widget _cultureView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 48,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 22),
            itemCount: TERM_CATS.length,
            itemBuilder: (ctx, i) {
              final active = _culCat == i;
              return Padding(
                padding: const EdgeInsets.only(right: 10, top: 8, bottom: 8),
                child: InkWell(
                  onTap: () => setState(() => _culCat = i),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                    decoration: BoxDecoration(
                      color: active ? AppTheme.zhe : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: active ? AppTheme.zhe : const Color(0xFFD8CDB4)),
                    ),
                    child: Center(
                      child: Text(TERM_CATS[i].cat,
                          style: AppTheme.sans(
                              size: 14,
                              color: active ? AppTheme.paper : AppTheme.ink)),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(22, 10, 22, 30),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.5,
            ),
            itemCount: TERM_CATS[_culCat].list.length,
            itemBuilder: (ctx, i) {
              final term = TERM_CATS[_culCat].list[i];
              return _termCell(term);
            },
          ),
        ),
      ],
    );
  }

  Widget _termCell(String term) {
    final info = TERMS[term];
    return InkWell(
      onTap: () {
        if (term.length == 1) {
          _openChar(term);
          return;
        }
        if (info != null) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => TermDetailScreen(info: info)));
        }
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFD8CDB4)),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Text(term,
                textAlign: TextAlign.center,
                style: AppTheme.serif(size: 22, color: AppTheme.ink, w: FontWeight.w600)),
          ),
        ),
      ),
    );
  }

  // ---------- 我的收藏 ----------
  Widget _favoritesView() {
    return FutureBuilder<List<String>>(
      future: Future.value(Store().favoriteChars().toList()),
      builder: (ctx, snap) {
        if (!snap.hasData) return const Center(child: CircularProgressIndicator());
        final favs = snap.data!;
        if (favs.isEmpty) {
          return Center(
            child: Text('还没有收藏的字\n学习时点“收藏”就会出现在这里',
                textAlign: TextAlign.center,
                style: AppTheme.sans(size: 16, color: AppTheme.ink2)),
          );
        }
        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(22, 10, 22, 30),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.95,
          ),
          itemCount: favs.length,
          itemBuilder: (ctx, i) => _charCell(favs[i], onTap: () => _openChar(favs[i])),
        );
      },
    );
  }

  Widget _charCell(String c, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFD8CDB4)),
        ),
        child: Center(
          child: Text(c, style: AppTheme.serif(size: 32, color: AppTheme.ink, w: FontWeight.w600)),
        ),
      ),
    );
  }

  void _openChar(String c) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => CharDetailScreen(char: c)));
  }
}

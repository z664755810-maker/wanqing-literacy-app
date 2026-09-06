import 'package:flutter/material.dart';

import '../app_router.dart';
import '../data/pinyin_course.dart';
import '../services/voice_player.dart';
import '../theme/app_dimens.dart';
import '../theme/app_theme.dart';
import '../widgets/app_bottom_nav.dart';

/// 拼音学习界面（方案 A：呼读音代读）。
///
/// 分五块（Tab）：声母 / 韵母 / 整体认读 / 四声 / 拼读。
/// 所有朗读都走 [VoicePlayer.playText]（真实汉字），自动用预生成音频或回落系统 TTS。
/// 🔴 绝不送拼音字母——字母只作界面展示，朗读字段全是汉字呼读音。
///
/// ⚠️ v1.15 修复：本页是底部导航的一级页，但旧版漏放了 [AppBottomNav]，而 tab 切换用
/// `pushReplacementNamed` 会把上一页顶掉 → 进入拼音后既无返回键也无导航，变成死路。
/// 现补回底部导航（与首页/阅读/复习等页一致），妈妈可随时切走或回「学习」。
///
/// ⚠️ v1.16 修复：旧版的 [TabBar] 在 `appBar.bottom` 与 [DefaultTabController] 在 `body` 内
/// 是两个独立对象——TabBar 点不响应、TabBarView 不会切页（看起来「全屏灰、内容只一部分」）。
/// 现把 [DefaultTabController] 提到 Scaffold 之上统一控制 TabBar + TabBarView。
/// 同时新增「教学顺序」：先学 6 个基础声母（bpmfdtn），再学其他——有章法、不迷路。
class PinyinScreen extends StatelessWidget {
  const PinyinScreen({super.key});

  /// 人教版教学顺序：先学这 6 个声母（与课本章节一致），给「无思路」的母亲一根线。
  static const List<String> _kStartShengmu = <String>['b', 'p', 'm', 'f', 'd', 't'];

  @override
  Widget build(BuildContext context) {
    final AppDimens d = AppDimens.of(context);
    return DefaultTabController(
      length: 5,
      // DefaultTabController 包住 Scaffold → appBar.bottom 的 TabBar 与 body 的 TabBarView
      // 共享同一个控制器，TabBar 点击会真切换 TabBarView。
      child: Scaffold(
        appBar: AppBar(
          title: Text('拼音学习', style: AppTheme.serif(size: d.fs(26))),
          bottom: TabBar(
            isScrollable: true,
            labelStyle: AppTheme.serif(size: d.fs(18), w: FontWeight.w600),
            unselectedLabelStyle: AppTheme.serif(size: d.fs(18)),
            labelColor: AppTheme.dai,
            unselectedLabelColor: AppTheme.ink2,
            indicatorColor: AppTheme.dai,
            tabs: const <Widget>[
              Tab(text: '声母'),
              Tab(text: '韵母'),
              Tab(text: '整体认读'),
              Tab(text: '四声'),
              Tab(text: '拼读'),
            ],
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            children: <Widget>[
              _ShengmuGrid(d: d, startOrder: _kStartShengmu),
              _YunmuGrid(d: d),
              _ZhengtiGrid(d: d),
              _SishengList(d: d),
              _PinduyGrid(d: d),
            ],
          ),
        ),
        bottomNavigationBar: AppBottomNav(AppBottomNav.indexOfRoute(AppRouter.pinyin)),
      ),
    );
  }
}

/// 计算网格列数（平板更宽，列数更多；手机至少 3 列）。
int _cols(AppDimens d, BuildContext context) =>
    (MediaQuery.of(context).size.width / d.fs(160)).floor().clamp(3, 6);

/// 单个「字母 + 呼读音」卡片（点一下朗读呼读音汉字）。
///
/// v1.16: 加 `highlight` 参数——给「建议先学」的声母加黛青描边，让母亲知道从哪儿开始。
///
/// v1.17: 加 `readText` 参数——[huduyin] 退化为**纯展示**，
/// 朗读改用 [readText]（null 时沿用 [huduyin]）。
/// 少数汉字本音不是一声（如「得」dé），拼音教学要念一声（dē），
/// 由 [readText] 指向专属隔离音频，避免污染同字在词组里的本音。
class _LetterTile extends StatelessWidget {
  final AppDimens d;
  final String letter;
  final String huduyin;
  /// v1.17：朗读用文本，null 表示沿用 [huduyin]。
  final String? readText;
  final String? note;
  final String label;
  final bool highlight;

  const _LetterTile({
    required this.d,
    required this.letter,
    required this.huduyin,
    this.readText,
    this.note,
    required this.label,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color borderColor = highlight ? AppTheme.dai : AppTheme.line;
    final double borderWidth = highlight ? 2.5 : 1.0;
    return Material(
      color: AppTheme.paper,
      borderRadius: BorderRadius.circular(AppDimens.radiusSm),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimens.radiusSm),
        // v1.17：朗读优先用 readText（隔离的拼音教学音），没配才沿用展示用的 huduyin。
        onTap: () => VoicePlayer.instance.playText(readText ?? huduyin, label: label),
        child: Container(
          padding: EdgeInsets.all(d.fs(12)),
          decoration: BoxDecoration(
            color: highlight ? AppTheme.daiSoft : AppTheme.paper,
            borderRadius: BorderRadius.circular(AppDimens.radiusSm),
            border: Border.all(color: borderColor, width: borderWidth),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(letter,
                  style: AppTheme.serif(
                    size: d.fs(38),
                    w: FontWeight.w700,
                    color: highlight ? AppTheme.dai : null,
                  )),
              SizedBox(height: d.fs(4)),
              Text('读：$huduyin',
                  style: AppTheme.sans(size: d.fs(16), color: AppTheme.zhe, w: FontWeight.w600)),
              if (note != null) ...<Widget>[
                SizedBox(height: d.fs(4)),
                Text(note!,
                    style: AppTheme.sans(size: d.fs(12), color: AppTheme.ink2),
                    textAlign: TextAlign.center),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// 声母网格：v1.16 加教学顺序提示 + 「建议先学」高亮。
class _ShengmuGrid extends StatelessWidget {
  final AppDimens d;
  final List<String> startOrder;
  const _ShengmuGrid({required this.d, required this.startOrder});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(d.fs(AppDimens.gapM)),
      children: <Widget>[
        // 教学顺序提示：妈妈一看就知道「先学这 6 个」（人教版拼音课本顺序）
        Container(
          padding: EdgeInsets.all(d.fs(AppDimens.gapM)),
          decoration: BoxDecoration(
            color: AppTheme.daiSoft,
            borderRadius: BorderRadius.circular(AppDimens.radius),
            border: Border.all(color: AppTheme.dai.withValues(alpha: 0.4), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(Icons.school_outlined, size: d.fs(24), color: AppTheme.dai),
                  SizedBox(width: d.fs(AppDimens.gapS)),
                  Text('学习顺序',
                      style: AppTheme.serif(
                          size: d.fs(20), color: AppTheme.dai, w: FontWeight.w700)),
                ],
              ),
              SizedBox(height: d.fs(AppDimens.gapS)),
              Text(
                '课本里先学这 6 个：${startOrder.join('  ')}。点一下听读音，记住形状。',
                style: AppTheme.serif(size: d.fs(17), color: AppTheme.ink2),
              ),
            ],
          ),
        ),
        SizedBox(height: d.fs(AppDimens.gapM)),
        // 声母网格：高亮"建议先学"的 6 个
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: _cols(d, context),
          mainAxisSpacing: d.fs(AppDimens.gapS),
          crossAxisSpacing: d.fs(AppDimens.gapS),
          childAspectRatio: 1.1,
          children: <Widget>[
            for (final Shengmu s in kShengmu)
              _LetterTile(
                d: d,
                letter: s.letter,
                huduyin: s.huduyin,
                readText: s.readText,
                note: s.note,
                label: '拼音·${s.letter}',
                highlight: startOrder.contains(s.letter),
              ),
          ],
        ),
      ],
    );
  }
}

class _YunmuGrid extends StatelessWidget {
  final AppDimens d;
  const _YunmuGrid({required this.d});
  @override
  Widget build(BuildContext context) => GridView.count(
        crossAxisCount: _cols(d, context),
        padding: EdgeInsets.all(d.fs(AppDimens.gapM)),
        mainAxisSpacing: d.fs(AppDimens.gapS),
        crossAxisSpacing: d.fs(AppDimens.gapS),
        childAspectRatio: 1.1,
        children: <Widget>[
          for (final Yunmu y in kYunmu)
            _LetterTile(
              d: d,
              letter: y.letter,
              huduyin: y.huduyin,
              readText: y.readText,
              label: '拼音·${y.letter}',
            ),
        ],
      );
}

class _ZhengtiGrid extends StatelessWidget {
  final AppDimens d;
  const _ZhengtiGrid({required this.d});
  @override
  Widget build(BuildContext context) => GridView.count(
        crossAxisCount: _cols(d, context),
        padding: EdgeInsets.all(d.fs(AppDimens.gapM)),
        mainAxisSpacing: d.fs(AppDimens.gapS),
        crossAxisSpacing: d.fs(AppDimens.gapS),
        childAspectRatio: 1.1,
        children: <Widget>[
          for (final Zhengti z in kZhengti)
            _LetterTile(
              d: d,
              letter: z.syllable,
              huduyin: z.huduyin,
              readText: z.readText,
              label: '拼音·${z.syllable}',
            ),
        ],
      );
}

/// 四声演示：每行一个韵，点一下连读四个声调汉字（妈，麻，马，骂）。
class _SishengList extends StatelessWidget {
  final AppDimens d;
  const _SishengList({required this.d});
  @override
  Widget build(BuildContext context) => ListView.separated(
        padding: EdgeInsets.all(d.fs(AppDimens.gapM)),
        itemCount: kSisheng.length,
        separatorBuilder: (_, __) => SizedBox(height: d.fs(AppDimens.gapS)),
        itemBuilder: (BuildContext ctx, int i) {
          final Sisheng s = kSisheng[i];
          final String sentence = s.words.join('，');
          return Material(
            color: AppTheme.paper,
            borderRadius: BorderRadius.circular(AppDimens.radius),
            child: InkWell(
              borderRadius: BorderRadius.circular(AppDimens.radius),
              onTap: () => VoicePlayer.instance.playText(sentence, label: '四声·${s.yunmu}'),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: d.fs(18),
                  vertical: d.fs(14),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppDimens.radius),
                  border: Border.all(color: AppTheme.line, width: 1),
                ),
                child: Row(
                  children: <Widget>[
                    Text(s.yunmu,
                        style: AppTheme.serif(size: d.fs(26), w: FontWeight.w700, color: AppTheme.zhe)),
                    SizedBox(width: d.fs(AppDimens.gapM)),
                    Expanded(
                      child: Text(
                        s.words.join('  '),
                        style: AppTheme.serif(size: d.fs(30), w: FontWeight.w600),
                      ),
                    ),
                    Icon(Icons.volume_up_outlined, size: d.fs(26), color: AppTheme.dai),
                  ],
                ),
              ),
            ),
          );
        },
      );
}

/// 拼读演示：b + a → ba（八），点一下读结果汉字。
class _PinduyGrid extends StatelessWidget {
  final AppDimens d;
  const _PinduyGrid({required this.d});
  @override
  Widget build(BuildContext context) => GridView.count(
        crossAxisCount: _cols(d, context),
        padding: EdgeInsets.all(d.fs(AppDimens.gapM)),
        mainAxisSpacing: d.fs(AppDimens.gapS),
        crossAxisSpacing: d.fs(AppDimens.gapS),
        childAspectRatio: 1.6,
        children: <Widget>[
          for (final Pinduy p in kPinduy)
            Material(
              color: AppTheme.paper,
              borderRadius: BorderRadius.circular(AppDimens.radiusSm),
              child: InkWell(
                borderRadius: BorderRadius.circular(AppDimens.radiusSm),
                onTap: () => VoicePlayer.instance.playText(p.hanzi, label: '拼读·${p.syllable}'),
                child: Container(
                  padding: EdgeInsets.all(d.fs(12)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppDimens.radiusSm),
                    border: Border.all(color: AppTheme.line, width: 1),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('${p.sm} + ${p.ym} → ${p.syllable}',
                          style: AppTheme.sans(size: d.fs(18), color: AppTheme.ink2)),
                      SizedBox(height: d.fs(6)),
                      Text(p.hanzi,
                          style: AppTheme.serif(size: d.fs(38), w: FontWeight.w700, color: AppTheme.dai)),
                    ],
                  ),
                ),
              ),
            ),
        ],
      );
}
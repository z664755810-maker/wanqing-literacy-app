import 'package:flutter/material.dart';

import '../app_router.dart';
import '../data/story.dart';
import '../data/story_model.dart';
import '../theme/app_dimens.dart';
import '../theme/app_theme.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/landscape_scope.dart';
import '../widgets/ruby_text.dart';
import '../widgets/story_image.dart';

/// 故事屋 · 书架（横屏双列）。
///
/// ## 为什么这里要挂 [LandscapeScope]
/// 书架是故事屋的模块入口：进故事屋 → 锁横屏，出故事屋 → 恢复竖屏。
/// 阅读器压在书架之上，天然继承横屏，所以它不重复申请（见 LandscapeScope 注释）。
///
/// ## 退出入口（此前缺失，用户会被困在故事屋）
/// - AppBar 左侧「‹ 返回」：可 pop 就 pop，已经是根路由则回到首页；
/// - 底部导航：与其它页面一致，可随时切走。
///
/// 定位与「短句实战」区分：这里是**注音泛读**——允许生字，但每个字上方带拼音，
/// 点字可听。适合在学完基础字后，把识字成果用到「读故事」上，体会读书的乐趣。
class StoryShelfScreen extends StatelessWidget {
  const StoryShelfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppDimens d = AppDimens.of(context);
    return LandscapeScope(
      child: Scaffold(
        backgroundColor: AppTheme.paper,
        appBar: AppBar(
          toolbarHeight: d.touch,
          leadingWidth: d.fs(150),
          leading: _ExitButton(d: d),
          title: Text(
            '故事屋',
            style: AppTheme.serif(size: d.fs(28), w: FontWeight.w700),
          ),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: d.fs(AppDimens.gapM)),
              child: Center(
                child: Text(
                  '横屏阅读 · 共 ${kAllStories.length} 个故事',
                  style: AppTheme.sans(size: d.fs(15), color: AppTheme.ink2),
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: AppDimens.maxReadWidth),
              child: GridView.builder(
                padding: EdgeInsets.all(d.pagePad),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  // 用「最大列宽 + 固定行高」代替固定列数/宽高比：
                  // 横屏宽屏 2 列、窄屏自动 1 列，且卡片高度永远 = mainAxisExtent，
                  // 不会因为内容多一行就溢出（之前 2.75 宽高比在标题折行时会撑爆）。
                  maxCrossAxisExtent: d.fs(520),
                  mainAxisSpacing: d.fs(AppDimens.gapM),
                  crossAxisSpacing: d.fs(AppDimens.gapM),
                  mainAxisExtent: d.fs(230),
                ),
                itemCount: kAllStories.length,
                itemBuilder: (BuildContext context, int i) => _BookCard(book: kAllStories[i]),
              ),
            ),
          ),
        ),
        // 底部导航：让用户在故事屋里随时能切到别的模块（此前缺失导致「出不去」）
        bottomNavigationBar: AppBottomNav(AppBottomNav.indexOfRoute(AppRouter.storyShelf)),
      ),
    );
  }
}

/// 退出故事屋：能返回就返回，已是根路由则回首页。
class _ExitButton extends StatelessWidget {
  final AppDimens d;

  const _ExitButton({required this.d});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: d.fs(AppDimens.gapS)),
      child: InkWell(
        onTap: () {
          final NavigatorState nav = Navigator.of(context);
          if (nav.canPop()) {
            nav.pop();
          } else {
            nav.pushReplacementNamed(AppRouter.home);
          }
        },
        borderRadius: BorderRadius.circular(d.fs(AppDimens.radius)),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: d.fs(AppDimens.gapS)),
          constraints: BoxConstraints(minHeight: d.touch * 0.78),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.arrow_back_ios_new, size: d.fs(26), color: AppTheme.dai),
              SizedBox(width: d.fs(2)),
              Text(
                '返回',
                style: AppTheme.serif(size: d.fs(21), color: AppTheme.dai, w: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 单本书卡片（横屏宽扁）：封面 + 来源标签 + 书名(注音) + 难度 + 简介。
class _BookCard extends StatelessWidget {
  final StoryBook book;

  const _BookCard({required this.book});

  @override
  Widget build(BuildContext context) {
    final AppDimens d = AppDimens.of(context);
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimens.radius),
        onTap: () => Navigator.pushNamed(context, AppRouter.storyReader, arguments: book),
        child: Padding(
          padding: EdgeInsets.all(d.fs(AppDimens.gapM)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              StoryImage(
                book.cover,
                height: d.fs(120),
                width: d.fs(88),
                caption: '封面',
              ),
              SizedBox(width: d.fs(AppDimens.gapM)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: d.fs(10),
                            vertical: d.fs(3),
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.zheSoft,
                            borderRadius: BorderRadius.circular(AppDimens.radius),
                          ),
                          child: Text(
                            kStorySourceLabel[book.source]!,
                            style: AppTheme.sans(
                              size: d.fs(14),
                              color: AppTheme.zhe,
                              w: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(width: d.fs(AppDimens.gapS)),
                        for (int s = 0; s < 3; s++)
                          Icon(
                            s < book.difficulty
                                ? Icons.star_rounded
                                : Icons.star_outline_rounded,
                            size: d.fs(17),
                            color: AppTheme.zhe,
                          ),
                      ],
                    ),
                    SizedBox(height: d.fs(AppDimens.gapXs)),
                    RubyText(
                      book.title,
                      fontSize: 26,
                      speakOnTap: false,
                      runSpacing: 8,
                    ),
                    SizedBox(height: d.fs(AppDimens.gapXs)),
                    Text(
                      book.intro,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.sans(size: d.fs(14), color: AppTheme.ink2, h: 1.4),
                    ),
                  ],
                ),
              ),
              SizedBox(width: d.fs(AppDimens.gapS)),
              Icon(Icons.chevron_right, size: d.fs(30), color: AppTheme.dai),
            ],
          ),
        ),
      ),
    );
  }
}

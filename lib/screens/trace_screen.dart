import 'package:flutter/material.dart';

import '../data/char_library.dart';
import '../services/tts_service.dart';
import '../theme/app_dimens.dart';
import '../theme/app_theme.dart';
import '../widgets/handwriting_pad.dart';
import '../widgets/stroke_order_demo.dart';

/// 描红写一写：左边「笔顺示例」先看一遍，右边田字格 + 浅色范字，手指描摹。
///
/// 写完点「看看写得怎样」会走 StrokeCheckService 自检笔画数/笔形/顺序，给温和建议。
/// 红线不变：**绝不打叉、不打分**，只给「怎么写更顺手」的鼓励式提示。
class TraceScreen extends StatelessWidget {
  final String char;

  const TraceScreen({super.key, this.char = ''});

  @override
  Widget build(BuildContext context) {
    final AppDimens d = AppDimens.of(context);
    final CharCard? card = kCharLibrary[char];
    if (card == null) {
      return Scaffold(
        appBar: AppBar(title: Text('描红', style: AppTheme.serif(size: d.fs(26)))),
        body: const SafeArea(child: Center(child: Text('字库里没有这个字'))),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('描红 · ${card.char}', style: AppTheme.serif(size: d.fs(26)))),
      // 🔴 关键：这里**绝不能**用 ListView / SingleChildScrollView 包裹手写板。
      //
      // 原因（v1.9 修复的实机 bug）：滚动容器会注册一个「竖向拖拽识别器」，与手写板的
      // Pan 识别器同处一个「手势竞技场」互相竞争：
      //   · 横向笔画 → 无人竞争，Pan 正常获胜 → 能写；
      //   · 竖向笔画 → 滚动容器先达阈值、抢先判定获胜 → Pan 被判负，页面跟着手指滚起来。
      // 表现正是用户反馈的「左右能写、上下一写整屏就滑」。
      //
      // 所以整屏改为**不滚动**的固定布局：顶部信息卡 + 中部田字格(Expanded) + 底部按钮，
      // 竖向手势再无竞争者，横竖笔画、断笔多笔全部归手写板。
      //
      // 左侧新增的「笔顺示例」栏自己带一个 SingleChildScrollView，但它是手写板的**兄弟节点**、
      // 不在手写板的命中路径上：手指落在田字格里时，命中测试只沿右侧分支往下走，
      // 左栏的滚动识别器根本不进这次手势竞技场，所以描红手势不受影响。
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext ctx, BoxConstraints c) {
            // 左侧笔顺栏约占 28% 宽（夹在 92~180dp 之间，保证窄屏也放得下田字格）
            final double demoW = (c.maxWidth * 0.28).clamp(d.fs(92), d.fs(180));
            final double gap = d.fs(AppDimens.gapM);
            final double widthAvail = c.maxWidth - d.pagePad * 2 - demoW - gap;
            // 预留：顶部信息卡 + 底部按钮行 + 手写板自带的「重写/看看写得怎样」按钮(约70) + 各处间距
            final double reserve = d.fs(160) + d.buttonH + d.pagePad * 2 + 70;
            final double heightAvail = c.maxHeight - reserve;
            // 取宽高可用值的较小者；下限 120 是「还能写得下一个字」的底线（防极小屏溢出）
            final double padSize =
                (widthAvail < heightAvail ? widthAvail : heightAvail).clamp(120.0, d.fs(360));
            return Padding(
              padding: EdgeInsets.all(d.pagePad),
              child: Column(
                children: <Widget>[
                  _CharHeader(d: d, card: card),
                  SizedBox(height: gap),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        StrokeOrderDemo(
                          char: card.char,
                          strokeNames: card.strokeNames,
                          width: demoW,
                        ),
                        SizedBox(width: gap),
                        Expanded(
                          child: Center(
                            child: HandwritingPad(
                              // 换字必须重建 State，否则上一个字的笔画会留在画板上
                              key: ValueKey<String>('trace-${card.char}'),
                              size: padSize,
                              guideChar: card.char,
                              strokeNames: card.strokeNames,
                              onSubmit: (String msg) {
                                ScaffoldMessenger.of(ctx).showSnackBar(
                                  SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: d.fs(AppDimens.gapM)),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: _Btn(
                          d: d,
                          icon: Icons.volume_up_outlined,
                          label: '听读音',
                          onTap: () => TtsService.instance.speak(card.char),
                        ),
                      ),
                      SizedBox(width: d.fs(AppDimens.gapM)),
                      Expanded(
                        child: _Btn(
                          d: d,
                          icon: Icons.check_circle_outline,
                          label: '完成',
                          primary: true,
                          onTap: () => Navigator.pop(ctx),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

/// 顶部紧凑信息卡：汉字 + 拼音 + 释义（横排）。
///
/// 刻意做成紧凑卡片，而不是「超大汉字 + 拼音 + 释义」三行大排版：屏幕高度要让给田字格，
/// 且田字格内部本来就有超大浅色范字（字号 = 格宽 × 0.65），顶部无需再重复放一个巨字。
class _CharHeader extends StatelessWidget {
  final AppDimens d;
  final CharCard card;

  const _CharHeader({required this.d, required this.card});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: d.fs(AppDimens.gapM), vertical: d.fs(AppDimens.gapS)),
      decoration: BoxDecoration(color: AppTheme.zheSoft, borderRadius: BorderRadius.circular(AppDimens.radius)),
      child: Row(
        children: <Widget>[
          Text(card.char, style: AppTheme.serif(size: d.fs(AppDimens.fsHuge), w: FontWeight.w700)),
          SizedBox(width: d.fs(AppDimens.gapM)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(card.pinyin, style: AppTheme.sans(size: d.fs(AppDimens.fsPinyin), color: AppTheme.zhe)),
                SizedBox(height: d.fs(AppDimens.gapXs)),
                Text(
                  card.meaning,
                  style: AppTheme.serif(size: d.fs(AppDimens.fsBody), color: AppTheme.ink2),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Btn extends StatelessWidget {
  final AppDimens d;
  final IconData icon;
  final String label;
  final bool primary;
  final VoidCallback onTap;

  const _Btn({required this.d, required this.icon, required this.label, this.primary = false, required this.onTap});

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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, size: d.fs(26), color: primary ? Colors.white : accent),
              SizedBox(width: d.fs(AppDimens.gapS)),
              Text(label, style: AppTheme.serif(size: d.fs(20), color: primary ? Colors.white : accent, w: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }
}

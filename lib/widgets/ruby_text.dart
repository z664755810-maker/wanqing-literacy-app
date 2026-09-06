import 'package:flutter/material.dart';

import '../data/story_ruby.dart';
import '../services/tts_service.dart';
import '../theme/app_dimens.dart';
import '../theme/app_theme.dart';

/// 逐字注音文本（Ruby 文本）。
///
/// 渲染方式：每个汉字上方显示弱化拼音，点任意字即朗读该字（只传真实汉字给 TTS）。
/// 标点无拼音、不参与朗读。换行由 [Wrap] 自适应，平板大屏一行能排很多字。
class RubyText extends StatelessWidget {
  final String ruby;
  final double fontSize;
  final bool speakOnTap;

  /// 行间距（换行后两行之间的距离，基准 dp）。横屏阅读建议放宽到 16。
  final double runSpacing;

  /// 字间距（同一行内字与字的水平间隙，基准 dp）。
  final double charSpacing;

  /// 圈生字模式：开启后点字朗读并回调 [onCharTap]，命中 [marked] 的字显蓝加粗划线。
  final bool markMode;

  /// 已圈中的字集合（仅 markMode 下生效）。
  final Set<String> marked;

  /// 圈生字模式下点字的回调（传真实汉字）。
  final void Function(String)? onCharTap;

  const RubyText(
    this.ruby, {
    super.key,
    this.fontSize = 34,
    this.speakOnTap = true,
    this.runSpacing = 10,
    this.charSpacing = 2,
    this.markMode = false,
    this.marked = const <String>{},
    this.onCharTap,
  });

  @override
  Widget build(BuildContext context) {
    final AppDimens d = AppDimens.of(context);
    final double fs = d.fs(fontSize);
    final List<RubyToken> tokens = parseRuby(ruby);

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.end,
      spacing: d.fs(charSpacing),
      runSpacing: d.fs(runSpacing),
      children: <Widget>[
        for (final RubyToken t in tokens)
          t.isPunctuation
              ? _Punct(t.char, fs)
              : _Char(t, fs, speakOnTap, markMode, marked, onCharTap),
      ],
    );
  }
}

/// 标点：贴底、略小、不可点。
class _Punct extends StatelessWidget {
  final String ch;
  final double fs;
  const _Punct(this.ch, this.fs);

  @override
  Widget build(BuildContext context) {
    final AppDimens d = AppDimens.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: d.fs(6), right: d.fs(2)),
      child: Text(ch, style: AppTheme.serif(size: fs * 0.9, color: AppTheme.ink2)),
    );
  }
}

/// 汉字：上方弱化拼音 + 下方大字，整块可点朗读。
class _Char extends StatelessWidget {
  final RubyToken t;
  final double fs;
  final bool speakOnTap;
  final bool markMode;
  final Set<String> marked;
  final void Function(String)? onCharTap;
  const _Char(this.t, this.fs, this.speakOnTap, this.markMode, this.marked, this.onCharTap);

  @override
  Widget build(BuildContext context) {
    final AppDimens d = AppDimens.of(context);
    final bool isMarked = markMode && marked.contains(t.char);
    // 拼音随汉字字号等比缩放（约 0.42），避免「书架小字/阅读大字」下拼音忽大忽小；
    // 槽位宽略大于汉字，超长拼音（如 shuāng）用 FittedBox 自动缩进，不压到下一个字。
    final double pySize = fs * 0.42;
    final double pySlotH = fs * 0.62;
    return InkWell(
      borderRadius: BorderRadius.circular(d.fs(AppDimens.radiusSm)),
      onTap: markMode
          ? () {
              TtsService.instance.speak(t.char);
              onCharTap?.call(t.char);
            }
          : (speakOnTap
              ? () {
                  TtsService.instance.speak(t.char);
                }
              : null),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: d.fs(3), vertical: d.fs(2)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: pySlotH,
              width: fs * 1.15,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.bottomCenter,
                child: Text(
                  t.hasPinyin ? t.pinyin! : '',
                  style: AppTheme.sans(
                    size: pySize,
                    color: isMarked ? Colors.blue : AppTheme.zhe,
                    w: FontWeight.w500,
                  ).copyWith(
                    decoration: isMarked ? TextDecoration.underline : null,
                    decorationColor: isMarked ? Colors.blue : null,
                  ),
                ),
              ),
            ),
            Text(
              t.char,
              style: AppTheme.serif(
                size: fs,
                color: isMarked ? Colors.blue : AppTheme.ink,
                w: isMarked ? FontWeight.w700 : FontWeight.w500,
              ).copyWith(
                decoration: isMarked ? TextDecoration.underline : null,
                decorationColor: isMarked ? Colors.blue : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

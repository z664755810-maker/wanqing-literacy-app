// 离线语音生成 · 文本清单提取器（仅构建期使用，不进 APK）。
//
// 直接导入应用数据层，用与运行时完全相同的构造方式（rubyToPlain 等）枚举
// 所有会被 TtsService.speak / VoicePlayer.playText 朗读的文本，输出 tool/voice_list.json。
// 这样 manifest 的 key 与 App 运行时传入的字符串逐字一致，不会因拼接差异而 miss。
//
// 运行：dart run tool/gen_voice_list.dart

import 'dart:convert';
import 'dart:io';

import '../lib/data/char_library.dart';
import '../lib/data/sentences.dart';
import '../lib/data/story.dart';
import '../lib/data/story_model.dart';
import '../lib/data/xiehouyu.dart';
import '../lib/data/pinyin_course.dart';
import '../lib/data/story_ruby.dart';

void main() {
  final List<Map<String, String>> out = <Map<String, String>>[];
  final Set<String> seen = <String>{};

  void add(String group, String text) {
    if (text.isEmpty) return;
    if (seen.contains(text)) return;
    seen.add(text);
    out.add(<String, String>{
      'id': '${group}_${out.length}',
      'text': text,
      'group': group,
    });
  }

  // 单字
  for (final CharCard c in kCharLibrary.values) {
    add('char', c.char);
  }
  // 词（字卡里的常用词）
  for (final CharCard c in kCharLibrary.values) {
    for (final String w in c.words) add('word', w);
  }
  // 单字三段式（speakChar：字，词，字）
  for (final CharCard c in kCharLibrary.values) {
    final String w = c.firstWord;
    if (w != c.char) add('char3', '${c.char}，$w，${c.char}');
  }
  // 短句
  for (final Sentence s in kSentences) add('sent', s.text);
  // 故事：整章 + 逐段
  for (final StoryBook b in kAllStories) {
    for (final StoryChapter ch in b.chapters) {
      final String chapText = <String>[
        rubyToPlain(ch.title),
        ...ch.paragraphs.map((StoryParagraph p) => rubyToPlain(p.ruby)),
      ].join('。');
      add('chap', chapText);
      for (final StoryParagraph p in ch.paragraphs) {
        add('para', rubyToPlain(p.ruby));
      }
    }
  }
  // 歇后语（整条朗读的精确拼接）
  for (final Xiehouyu x in kXiehouyu) {
    add('xh', '${rubyToPlain(x.front)}，${rubyToPlain(x.back)}。${rubyToPlain(x.meaning)}');
  }
  // 拼音：声母/韵母/整体认读 呼读音 + 四声 + 拼读
  for (final Shengmu s in kShengmu) add('sm', s.huduyin);
  for (final Yunmu y in kYunmu) add('ym', y.huduyin);
  for (final Zhengti z in kZhengti) add('zt', z.huduyin);
  for (final Sisheng s in kSisheng) add('ss', s.words.join('，'));
  for (final Pinduy p in kPinduy) add('pd', p.hanzi);
  // 固定提示 / 成就语（含手写提示有无句号两种，避免 miss）
  add('hint', '还没写呢，用手指在格子里写一遍吧');
  add('hint', '还没写呢，用手指在格子里写一遍吧。');
  add('ach', '这一课的字都认下了，接着看下一课');
  add('ach', '今天的课都学完了，去复习看看');

  File('tool/voice_list.json').writeAsStringSync(
    const JsonEncoder.withIndent('  ').convert(out),
  );

  final Map<String, int> counts = <String, int>{};
  for (final Map<String, String> m in out) {
    final String g = m['group']!;
    counts[g] = (counts[g] ?? 0) + 1;
  }
  print('TOTAL=${out.length}');
  final List<String> keys = counts.keys.toList()..sort();
  for (final String k in keys) print('  $k=${counts[k]}');
}

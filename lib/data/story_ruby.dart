// ============================================================================
// 晚晴识字 · 注音解析（故事屋专用）
//
// 正文采用「字后紧跟半角括号注音」的写法：`孙(sūn)悟(wù)空(kōng)`。
// 标点不注音：`你(nǐ)好(hǎo)！` 中的 `！` 解析为无拼音的纯字符。
//
// 这样写的好处：① 多音字由人工决定（如 了(le)/了(liǎo)）；② 字音不串位；
// ③ 源码人眼可读不易改坏。本文件只做解析，不碰任何 UI / TTS。
// ============================================================================

/// 一个最小注音单元：一个汉字 + 可选拼音。标点、空格、未注音字符拼音为 null。
class RubyToken {
  const RubyToken(this.char, [this.pinyin]);

  /// 字符本身（汉字或标点）
  final String char;

  /// 该字符的拼音（半角小写，带声调）；标点 / 未注音字符为 null
  final String? pinyin;

  /// 是否为中文标点（无拼音、点击不朗读）
  bool get isPunctuation {
    // CJK 统一表意文字基本区：一 ~ 鿿
    if (char.codeUnits.length != 1) return false;
    final int cp = char.codeUnitAt(0);
    return !(cp >= 0x4E00 && cp <= 0x9FFF);
  }

  /// 拼音是否缺失（含标点和未注音汉字）
  bool get hasPinyin => pinyin != null && pinyin!.isNotEmpty;
}

/// 解析带注音源码为逐字 token 列表。
///
/// 规则：遇到「字符 + `(`」，向后找配对的 `)` 作为拼音；否则作为无拼音字符。
/// 即使源码里漏了括号也不会崩，只是该字符拼音为 null（UI 会优雅降级不显示注音）。
List<RubyToken> parseRuby(String src) {
  final List<RubyToken> out = <RubyToken>[];
  int i = 0;
  while (i < src.length) {
    final String ch = src[i];
    // 下一个字符是 '(' 且能找到配对的 ')' → 注音单元
    if (i + 1 < src.length && src[i + 1] == '(') {
      final int close = src.indexOf(')', i + 2);
      if (close > i + 1) {
        final String py = src.substring(i + 2, close);
        out.add(RubyToken(ch, py));
        i = close + 1;
        continue;
      }
    }
    out.add(RubyToken(ch));
    i += 1;
  }
  return out;
}

/// 提取纯汉字文本（剥掉所有拼音括号）。用于整段朗读，保证只把真实汉字传给 TTS。
String rubyToPlain(String src) => parseRuby(src).map((RubyToken t) => t.char).join('');

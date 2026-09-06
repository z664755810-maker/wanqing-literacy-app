// 拼音学习模块内容（仅个人使用，模仿市面成品识字软件对应功能）。
//
// 设计红线：
// 1. 本文件里所有「会被朗读」的字段都是**真汉字**（呼读音 / 拼读例句），
//    拼音字母本身（b / p / m…）是**纯展示文本**，绝不送进 TtsService
//    —— 送进去会被念成英文字母，这是项目铁律。
// 2. 纯数据文件，零依赖、零网络。
//
// 为什么用「呼读音」代读：系统 TTS 与任何云端 TTS 都念不了拼音字母。
// 人教版拼音教学本身就用汉字呼读音（b→玻、p→坡…）来教声母/韵母，
// 所以本模块朗读呼读音汉字即可，听感与学校教的一致。

/// 声母（23 个）。[letter] 纯展示；[huduyin] 是会被朗读的汉字呼读音。
class Shengmu {
  final String letter;
  final String huduyin;
  /// 个别声母没有对应汉字呼读音（如 j/q/x 直接读其音节），[note] 给母亲一句提示。
  final String? note;
  /// v1.17：朗读时送 VoicePlayer 的文本，null 表示沿用 [huduyin]。
  ///
  /// 少数呼读音汉字的**字面声调**与**拼音教学音**不一致——教学时为让学习者听清音素
  /// 本身，约定**声母呼读音一律念一声**，如「特」本音 tè（四声），教学念 tē（一声）。
  /// 韵母/整体认读不在此列，它们读自己的自然声调（见 [Yunmu.readText]）。
  /// 这类条目指向一条专属隔离音频（如 '得·py'），
  /// 这样改掉拼音教学的读音，不会连带把同字在词组里的本音也改掉（"得到"仍念 dé 到）。
  final String? readText;

  const Shengmu(this.letter, this.huduyin, {this.note, this.readText});
}

const List<Shengmu> kShengmu = <Shengmu>[
  Shengmu('b', '玻'),
  Shengmu('p', '坡'),
  Shengmu('m', '摸'),
  Shengmu('f', '佛'),
  // v1.17：'得'/'日' 本音不是一声，需指向隔离音频（详见 [Shengmu.readText] 注释）。
  Shengmu('d', '得', readText: '得·py'),
  Shengmu('t', '特'),
  Shengmu('n', '讷'),
  Shengmu('l', '勒'),
  Shengmu('g', '哥'),
  Shengmu('k', '科'),
  Shengmu('h', '喝'),
  Shengmu('j', '机', note: '读「机」这个音'),
  Shengmu('q', '欺', note: '读「欺」这个音'),
  Shengmu('x', '希', note: '读「希」这个音'),
  Shengmu('zh', '知'),
  Shengmu('ch', '吃'),
  Shengmu('sh', '狮'),
  Shengmu('r', '日', readText: '日·py'),
  Shengmu('z', '资'),
  Shengmu('c', '疵', note: '读「疵」这个音'),
  Shengmu('s', '丝'),
];

/// 韵母（24 个）。[letter] 展示；[huduyin] 朗读用的汉字呼读音。
class Yunmu {
  final String letter;
  final String huduyin;
  /// 朗读时送 VoicePlayer 的文本，null 表示沿用 [huduyin]。
  /// 注意：韵母/整体认读**按其自然声调读**（鹅é、爱ài、奥ào、昂áng、儿ér、日rì…），
  /// 不改成一声——只有声母的呼读音才读一声（见 [Shengmu.readText]）。
  /// 故本文件韵母/整体认读一律不配 [readText]。
  final String? readText;

  const Yunmu(this.letter, this.huduyin, {this.readText});
}

const List<Yunmu> kYunmu = <Yunmu>[
  Yunmu('a', '啊'),
  Yunmu('o', '喔'),
  Yunmu('e', '鹅'),
  Yunmu('i', '衣'),
  Yunmu('u', '乌'),
  Yunmu('ü', '迂'),
  Yunmu('ai', '爱'),
  Yunmu('ei', '欸'),
  Yunmu('ui', '威'),
  Yunmu('ao', '奥'),
  Yunmu('ou', '欧'),
  Yunmu('iu', '优'),
  Yunmu('ie', '耶'),
  Yunmu('üe', '约'),
  Yunmu('er', '儿'),
  Yunmu('an', '安'),
  Yunmu('en', '恩'),
  Yunmu('in', '因'),
  Yunmu('un', '温'),
  Yunmu('ün', '晕'),
  Yunmu('ang', '昂'),
  Yunmu('eng', '鞥'),
  Yunmu('ing', '英'),
  Yunmu('ong', '轰'),
];

/// 整体认读音节（16 个）。[syllable] 展示；[huduyin] 朗读用的汉字（其音节本身）。
class Zhengti {
  final String syllable;
  final String huduyin;
  /// 朗读时送 VoicePlayer 的文本，null 表示沿用 [huduyin]。
  /// 注意：韵母/整体认读**按其自然声调读**（鹅é、爱ài、奥ào、昂áng、儿ér、日rì…），
  /// 不改成一声——只有声母的呼读音才读一声（见 [Shengmu.readText]）。
  /// 故本文件韵母/整体认读一律不配 [readText]。
  final String? readText;

  const Zhengti(this.syllable, this.huduyin, {this.readText});
}

const List<Zhengti> kZhengti = <Zhengti>[
  Zhengti('zhi', '知'),
  Zhengti('chi', '吃'),
  Zhengti('shi', '狮'),
  // v1.17：整体认读 ri 的 huduyin「日」本就是 rì（四声），是教材标准读音，不再另设教学音；
  // 声母 r 才需要一声教学音（见上，readText: '日·py' → py_ri → rī）。
  Zhengti('ri', '日'),
  Zhengti('zi', '资'),
  Zhengti('ci', '疵'),
  Zhengti('si', '丝'),
  Zhengti('yi', '衣'),
  Zhengti('wu', '乌'),
  Zhengti('yu', '迂'),
  Zhengti('ye', '耶'),
  Zhengti('yue', '约'),
  Zhengti('yuan', '冤'),
  Zhengti('yin', '因'),
  Zhengti('yun', '晕'),
  Zhengti('ying', '英'),
];

/// 四声演示：选 6 个常见韵，配「妈麻马骂」式四声对比汉字。
/// 朗读时直接把 [words] 连成一句话送 TTS（每字自带声调，系统会读对四声）。
class Sisheng {
  final String yunmu; // 展示用韵
  final List<String> words; // 四声汉字，顺序：阴平/阳平/上声/去声

  const Sisheng(this.yunmu, this.words);
}

const List<Sisheng> kSisheng = <Sisheng>[
  Sisheng('a', <String>['妈', '麻', '马', '骂']),
  Sisheng('o', <String>['波', '脖', '跛', '簸']),
  Sisheng('e', <String>['哥', '格', '葛', '个']),
  Sisheng('i', <String>['一', '移', '以', '亿']),
  Sisheng('u', <String>['屋', '吴', '五', '务']),
  Sisheng('ü', <String>['迂', '鱼', '雨', '玉']),
];

/// 拼读示例：声母 + 韵母 → 音节（展示） + 一个常用汉字（朗读，TTS 安全）。
class Pinduy {
  final String sm; // 声母展示
  final String ym; // 韵母展示
  final String syllable; // 音节展示，如 ba
  final String hanzi; // 朗读用汉字，如 八

  const Pinduy(this.sm, this.ym, this.syllable, this.hanzi);
}

const List<Pinduy> kPinduy = <Pinduy>[
  Pinduy('b', 'a', 'ba', '八'),
  Pinduy('p', 'o', 'po', '坡'),
  Pinduy('m', 'i', 'mi', '米'),
  Pinduy('f', 'a', 'fa', '发'),
  Pinduy('d', 'a', 'da', '大'),
  Pinduy('t', 'u', 'tu', '土'),
  Pinduy('n', 'a', 'na', '拿'),
  Pinduy('l', 'i', 'li', '力'),
  Pinduy('g', 'e', 'ge', '哥'),
  Pinduy('k', 'a', 'ka', '卡'),
  Pinduy('h', 'e', 'he', '喝'),
  Pinduy('j', 'i', 'ji', '机'),
  Pinduy('q', 'i', 'qi', '七'),
  Pinduy('x', 'i', 'xi', '西'),
  Pinduy('zh', 'a', 'zha', '扎'),
  Pinduy('ch', 'a', 'cha', '茶'),
  Pinduy('sh', 'a', 'sha', '沙'),
  Pinduy('r', 'i', 'ri', '日'),
  Pinduy('z', 'a', 'za', '杂'),
  Pinduy('c', 'a', 'ca', '擦'),
  Pinduy('s', 'a', 'sa', '洒'),
  Pinduy('b', 'o', 'bo', '波'),
  Pinduy('m', 'a', 'ma', '妈'),
  Pinduy('h', 'u', 'hu', '湖'),
];

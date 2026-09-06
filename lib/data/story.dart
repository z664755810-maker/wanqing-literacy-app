import 'story_model.dart';

// ============================================================================
// 晚晴识字 · 故事屋数据（V1.0 首批 6 篇）
//
// 🔴 注音写法（务必遵守，这是全项目的单一事实来源）：
//    正文中每个汉字后面紧跟半角括号注音：`孙(sūn)悟(wù)空(kōng)`。
//    标点不注音，直接写：`，。！？：""`
//    这样写的好处：① 多音字不会错（如 "了(le)" / "了(liǎo)" 由人工决定）；
//                  ② 字与音不会错位；③ 源码人眼可读，改起来不会改坏。
//
// 🔴 与短句阅读模块的定位区分（不要混淆）：
//    · read_screen（短句实战）：铁律 100% 只用已学汉字，绝不出现生字
//    · story（故事屋）：注音泛读，允许生字，但每个汉字上方都带拼音，
//      点任意字可听发音。母亲"会说不认识"，拼音是她的拐杖。
//
// 🔴 [StoryParagraph.images] 为插图资源路径，1~3 张，按阅读顺序排列。
//    图片必须打包进 APK（纯离线，运行时零网络请求）。
// ============================================================================

// ============================================================================
// 一、哪吒闹海（民间传说）
// ============================================================================

const StoryBook kStoryNezha = StoryBook(
  id: 'nezha',
  title: '哪(né)吒(zhā)闹(nào)海(hǎi)',
  source: StorySource.legend,
  cover: 'assets/images/stories/nezha/cover.png',
  intro: '陈(chén)塘(táng)关(guān)总(zǒng)兵(bīng)的(de)儿(ér)子(zi)，为(wèi)了(le)不(bù)连(lián)累(lěi)百(bǎi)姓(xìng)，一(yī)人(rén)担(dān)下(xià)所(suǒ)有(yǒu)罪(zuì)名(míng)。',
  difficulty: 2,
  chapters: <StoryChapter>[
    StoryChapter(
      id: 'c1',
      title: '出(chū)世(shì)',
      cover: 'assets/images/stories/nezha/c1_cover.png',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '陈(chén)塘(táng)关(guān)有(yǒu)一(yī)位(wèi)总(zǒng)兵(bīng)，名(míng)叫(jiào)李(lǐ)靖(jìng)。'
              '他(tā)的(de)妻(qī)子(zi)怀(huái)胎(tāi)三(sān)年(nián)零(líng)六(liù)个(gè)月(yuè)。',
          images: <String>['assets/images/stories/nezha/c1_p1_1.png'],
          imageCaption: '陈塘关李靖家的院子',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '生(shēng)下(xià)来(lái)的(de)不(bù)是(shì)孩(hái)子(zi)，是(shì)一(yī)个(gè)大(dà)肉(ròu)球(qiú)。'
              '李(lǐ)靖(jìng)以(yǐ)为(wéi)是(shì)妖(yāo)怪(guài)，拔(bá)出(chū)宝(bǎo)剑(jiàn)就(jiù)砍(kǎn)。',
          images: <String>['assets/images/stories/nezha/c1_p2_1.png'],
          imageCaption: '李靖举剑砍向肉球',
        ),
        StoryParagraph(
          id: 'p3',
          ruby: '宝(bǎo)剑(jiàn)砍(kǎn)下(xià)去(qù)，肉(ròu)球(qiú)裂(liè)开(kāi)了(le)。'
              '里(lǐ)面(miàn)跳(tiào)出(chū)一(yī)个(gè)小(xiǎo)男(nán)孩(hái)，满(mǎn)地(dì)乱(luàn)跑(pǎo)。',
          images: <String>['assets/images/stories/nezha/c1_p3_1.png'],
          imageCaption: '肉球裂开，跳出小男孩',
        ),
        StoryParagraph(
          id: 'p4',
          ruby: '这(zhè)孩(hái)子(zi)生(shēng)下(xià)来(lái)就(jiù)会(huì)说(shuō)话(huà)，一(yī)身(shēn)力(lì)气(qì)。'
              '夫(fū)妻(qī)俩(liǎ)又(yòu)惊(jīng)又(yòu)喜(xǐ)，给(gěi)他(tā)取(qǔ)名(míng)叫(jiào)哪(né)吒(zhā)。',
          images: <String>['assets/images/stories/nezha/c1_p4_1.png'],
          imageCaption: '夫妻俩抱着哪吒',
        ),
      ],
    ),
    StoryChapter(
      id: 'c2',
      title: '两(liǎng)件(jiàn)宝(bǎo)贝(bèi)',
      cover: 'assets/images/stories/nezha/c2_cover.png',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '哪(né)吒(zhā)七(qī)岁(suì)那(nà)年(nián)，遇(yù)见(jiàn)了(le)师(shī)父(fù)太(tài)乙(yǐ)真(zhēn)人(rén)。',
          images: <String>['assets/images/stories/nezha/c2_p1_1.png'],
          imageCaption: '太乙真人来到哪吒面前',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '师(shī)父(fù)送(sòng)他(tā)两(liǎng)件(jiàn)宝(bǎo)贝(bèi)。'
              '一(yī)件(jiàn)是(shì)混(hùn)天(tiān)绫(líng)，一(yī)条(tiáo)红(hóng)绸(chóu)子(zi)。'
              '一(yī)件(jiàn)是(shì)乾(qián)坤(kūn)圈(quān)，一(yī)个(gè)金(jīn)镯(zhuó)子(zi)。',
          images: <String>[
            'assets/images/stories/nezha/c2_p2_1.png',
            'assets/images/stories/nezha/c2_p2_2.png',
          ],
          imageCaption: '混天绫与乾坤圈',
        ),
      ],
    ),
    StoryChapter(
      id: 'c3',
      title: '海(hǎi)边(biān)惹(rě)祸(huò)',
      cover: 'assets/images/stories/nezha/c3_cover.png',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '那(nà)年(nián)夏(xià)天(tiān)，天(tiān)气(qì)热(rè)得(de)受(shòu)不(bù)了(liǎo)。'
              '哪(né)吒(zhā)跑(pǎo)到(dào)东(dōng)海(hǎi)边(biān)，脱(tuō)了(le)衣(yī)服(fu)下(xià)水(shuǐ)洗(xǐ)澡(zǎo)。',
          images: <String>['assets/images/stories/nezha/c3_p1_1.png'],
          imageCaption: '哪吒在海边洗澡',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '他(tā)把(bǎ)红(hóng)绸(chóu)子(zi)放(fàng)在(zài)水(shuǐ)里(li)洗(xǐ)。'
              '这(zhè)一(yī)洗(xǐ)，海(hǎi)水(shuǐ)全(quán)变(biàn)成(chéng)了(le)红(hóng)色(sè)。'
              '海(hǎi)底(dǐ)的(de)龙(lóng)宫(gōng)晃(huàng)得(de)像(xiàng)地(dì)震(zhèn)一(yī)样(yàng)。',
          images: <String>[
            'assets/images/stories/nezha/c3_p2_1.png',
            'assets/images/stories/nezha/c3_p2_2.png',
          ],
          imageCaption: '海水变红，龙宫摇晃',
        ),
      ],
    ),
    StoryChapter(
      id: 'c4',
      title: '抽(chōu)龙(lóng)筋(jīn)',
      cover: 'assets/images/stories/nezha/c4_cover.png',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '龙(lóng)王(wáng)派(pài)三(sān)太(tài)子(zǐ)出(chū)来(lái)看(kàn)。'
              '三(sān)太(tài)子(zǐ)冲(chōng)出(chū)水(shuǐ)面(miàn)，大(dà)骂(mà)："哪(nǎ)来(lái)的(de)野(yě)小(xiǎo)子(zi)！"',
          images: <String>['assets/images/stories/nezha/c4_p1_1.png'],
          imageCaption: '三太子冲出水面',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '哪(né)吒(zhā)不(bù)服(fú)气(qì)，举(jǔ)起(qǐ)金(jīn)镯(zhuó)子(zi)就(jiù)打(dǎ)。'
              '三(sān)太(tài)子(zǐ)打(dǎ)不(bù)过(guò)，变(biàn)成(chéng)一(yī)条(tiáo)白(bái)龙(lóng)扑(pū)上(shàng)来(lái)。',
          images: <String>['assets/images/stories/nezha/c4_p2_1.png'],
          imageCaption: '三太子变成白龙',
        ),
        StoryParagraph(
          id: 'p3',
          ruby: '哪(né)吒(zhā)骑(qí)在(zài)龙(lóng)背(bèi)上(shàng)，一(yī)把(bǎ)抽(chōu)下(xià)龙(lóng)筋(jīn)。'
              '他(tā)说(shuō)："这(zhè)条(tiáo)筋(jīn)给(gěi)我(wǒ)父(fù)亲(qīn)做(zuò)腰(yāo)带(dài)。"',
          images: <String>['assets/images/stories/nezha/c4_p3_1.png'],
          imageCaption: '哪吒骑在龙背上抽筋',
        ),
      ],
    ),
    StoryChapter(
      id: 'c5',
      title: '一(yī)人(rén)担(dān)下(xià)',
      cover: 'assets/images/stories/nezha/c5_cover.png',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '龙(lóng)王(wáng)得(dé)知(zhī)儿(ér)子(zi)死(sǐ)了(le)，气(qì)得(de)浑(hún)身(shēn)发(fā)抖(dǒu)。'
              '他(tā)说(shuō)："我(wǒ)要(yào)发(fā)大(dà)水(shuǐ)，淹(yān)了(le)陈(chén)塘(táng)关(guān)！"',
          images: <String>['assets/images/stories/nezha/c5_p1_1.png'],
          imageCaption: '龙王大怒',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '哪(né)吒(zhā)想(xiǎng)了(le)一(yī)想(xiǎng)，站(zhàn)出(chū)来(lái)说(shuō)：'
              '"我(wǒ)一(yī)个(gè)人(rén)做(zuò)的(de)事(shì)，我(wǒ)一(yī)个(gè)人(rén)担(dān)。"',
          images: <String>['assets/images/stories/nezha/c5_p2_1.png'],
          imageCaption: '哪吒站出来承担责任',
        ),
        StoryParagraph(
          id: 'p3',
          ruby: '他(tā)跪(guì)在(zài)地(dì)上(shàng)，对(duì)父(fù)亲(qīn)说(shuō)："骨(gǔ)肉(ròu)还(huán)给(gěi)爹(diē)娘(niáng)。"',
          images: <String>['assets/images/stories/nezha/c5_p3_1.png'],
          imageCaption: '哪吒跪别父母',
        ),
      ],
    ),
    StoryChapter(
      id: 'c6',
      title: '莲(lián)花(huā)重(zhòng)生(shēng)',
      cover: 'assets/images/stories/nezha/c6_cover.png',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '太(tài)乙(yǐ)真(zhēn)人(rén)听(tīng)说(shuō)了(le)，赶(gǎn)来(lái)救(jiù)他(tā)。'
              '师(shī)父(fù)用(yòng)莲(lián)花(huā)和(hé)莲(lián)藕(ǒu)，给(gěi)哪(né)吒(zhā)做(zuò)了(le)一(yī)副(fù)新(xīn)身(shēn)子(zi)。',
          images: <String>['assets/images/stories/nezha/c6_p1_1.png'],
          imageCaption: '师父用莲花莲藕重塑身体',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '哪(né)吒(zhā)又(yòu)活(huó)了(le)过(guò)来(lái)。'
              '他(tā)手(shǒu)拿(ná)火(huǒ)尖(jiān)枪(qiāng)，脚(jiǎo)踩(cǎi)风(fēng)火(huǒ)轮(lún)，肩(jiān)上(shàng)披(pī)着(zhe)混(hùn)天(tiān)绫(líng)。',
          images: <String>['assets/images/stories/nezha/c6_p2_1.png'],
          imageCaption: '哪吒踩着风火轮',
        ),
        StoryParagraph(
          id: 'p3',
          ruby: '从(cóng)此(cǐ)以(yǐ)后(hòu)，他(tā)一(yī)心(xīn)护(hù)着(zhe)百(bǎi)姓(xìng)，'
              '成(chéng)了(le)人(rén)人(rén)敬(jìng)重(zhòng)的(de)小(xiǎo)英(yīng)雄(xióng)。',
          images: <String>['assets/images/stories/nezha/c6_p3_1.png'],
          imageCaption: '哪吒守护百姓',
        ),
      ],
    ),
  ],
);

// ============================================================================
// 二、大闹天宫（西游记）
// ============================================================================

const StoryBook kStoryHavoc = StoryBook(
  id: 'havoc',
  title: '大(dà)闹(nào)天(tiān)宫(gōng)',
  source: StorySource.classic,
  cover: 'assets/images/stories/havoc/cover.png',
  intro: '一(yī)只(zhī)从(cóng)石(shí)头(tou)里(li)蹦(bèng)出(chū)来(lái)的(de)猴(hóu)子(zi)，'
      '学(xué)成(chéng)本(běn)事(shi)后(hòu)不(bù)肯(kěn)服(fú)管(guǎn)，把(bǎ)天(tiān)宫(gōng)闹(nào)了(le)个(gè)底(dǐ)朝(cháo)天(tiān)。',
  difficulty: 2,
  chapters: <StoryChapter>[
    StoryChapter(
      id: 'c1',
      title: '石(shí)猴(hóu)出(chū)世(shì)',
      cover: 'assets/images/stories/havoc/c1_cover.png',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '东(dōng)胜(shèng)神(shén)州(zhōu)有(yǒu)一(yī)座(zuò)花(huā)果(guǒ)山(shān)。'
              '山(shān)顶(dǐng)有(yǒu)一(yī)块(kuài)仙(xiān)石(shí)，吸(xī)了(le)日(rì)月(yuè)精(jīng)华(huá)。',
          images: <String>['assets/images/stories/havoc/c1_p1_1.png'],
          imageCaption: '花果山顶的仙石',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '一(yī)天(tiān)，仙(xiān)石(shí)裂(liè)开(kāi)，跳(tiào)出(chū)一(yī)只(zhī)石(shí)猴(hóu)。'
              '他(tā)在(zài)山(shān)里(li)和(hé)猴(hóu)子(zi)们(men)玩(wán)耍(shuǎ)，日(rì)子(zi)过(guò)得(de)自(zì)在(zài)。',
          images: <String>['assets/images/stories/havoc/c1_p2_1.png'],
          imageCaption: '石猴蹦出仙石',
        ),
      ],
    ),
    StoryChapter(
      id: 'c2',
      title: '拜(bài)师(shī)学(xué)艺(yì)',
      cover: 'assets/images/stories/havoc/c2_cover.png',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '石(shí)猴(hóu)漂(piāo)洋(yáng)过(guò)海(hǎi)，拜(bài)菩(pú)提(tí)祖(zǔ)师(shī)为(wéi)师(shī)。'
              '师(shī)父(fù)给(gěi)他(tā)取(qǔ)名(míng)孙(sūn)悟(wù)空(kōng)。',
          images: <String>['assets/images/stories/havoc/c2_p1_1.png'],
          imageCaption: '石猴拜菩提祖师',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '他(tā)学(xué)会(huì)了(le)七(qī)十(shí)二(èr)变(biàn)和(hé)筋(jīn)斗(dǒu)云(yún)。'
              '一(yī)个(gè)筋(jīn)斗(dǒu)，能(néng)翻(fān)十(shí)万(wàn)八(bā)千(qiān)里(lǐ)。',
          images: <String>['assets/images/stories/havoc/c2_p2_1.png'],
          imageCaption: '孙悟空翻筋斗云',
        ),
      ],
    ),
    StoryChapter(
      id: 'c3',
      title: '金(jīn)箍(gū)棒(bàng)',
      cover: 'assets/images/stories/havoc/c3_cover.png',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '回(huí)到(dào)花(huā)果(guǒ)山(shān)，孙(sūn)悟(wù)空(kōng)没(méi)有(yǒu)趁(chèn)手(shǒu)的(de)兵(bīng)器(qì)。'
              '他(tā)下(xià)到(dào)东(dōng)海(hǎi)龙(lóng)宫(gōng)，拿(ná)走(zǒu)了(le)定(dìng)海(hǎi)神(shén)针(zhēn)。',
          images: <String>['assets/images/stories/havoc/c3_p1_1.png'],
          imageCaption: '孙悟空在东海龙宫',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '那(nà)根(gēn)铁(tiě)棒(bàng)能(néng)大(dà)能(néng)小(xiǎo)，叫(jiào)如(rú)意(yì)金(jīn)箍(gū)棒(bàng)。'
              '他(tā)又(yòu)闯(chuǎng)进(jìn)地(dì)府(fǔ)，把(bǎ)生(shēng)死(sǐ)簿(bù)上(shàng)猴(hóu)子(zi)的(de)名(míng)字(zi)全(quán)划(huá)掉(diào)了(le)。',
          images: <String>['assets/images/stories/havoc/c3_p2_1.png'],
          imageCaption: '如意金箍棒',
        ),
      ],
    ),
    StoryChapter(
      id: 'c4',
      title: '齐(qí)天(tiān)大(dà)圣(shèng)',
      cover: 'assets/images/stories/havoc/c4_cover.png',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '玉(yù)皇(huáng)大(dà)帝(dì)听(tīng)说(shuō)了(le)，派(pài)太(tài)白(bái)金(jīn)星(xīng)去(qù)招(zhāo)安(ān)。'
              '孙(sūn)悟(wù)空(kōng)上(shàng)了(le)天(tiān)，当(dāng)了(le)个(gè)弼(bì)马(mǎ)温(wēn)。',
          images: <String>['assets/images/stories/havoc/c4_p1_1.png'],
          imageCaption: '太白金星来招安',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '后(hòu)来(lái)他(tā)知(zhī)道(dào)这(zhè)官(guān)最(zuì)小(xiǎo)，气(qì)得(de)回(huí)了(le)花(huā)果(guǒ)山(shān)。'
              '他(tā)竖(shù)起(qǐ)大(dà)旗(qí)，自(zì)称(chēng)齐(qí)天(tiān)大(dà)圣(shèng)。',
          images: <String>['assets/images/stories/havoc/c4_p2_1.png'],
          imageCaption: '孙悟空竖起大旗',
        ),
      ],
    ),
    StoryChapter(
      id: 'c5',
      title: '偷(tōu)桃(táo)盗(dào)丹(dān)',
      cover: 'assets/images/stories/havoc/c5_cover.png',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '玉(yù)帝(dì)又(yòu)派(pài)人(rén)请(qǐng)他(tā)上(shàng)天(tiān)，让(ràng)他(tā)看(kān)管(guǎn)蟠(pán)桃(táo)园(yuán)。'
              '孙(sūn)悟(wù)空(kōng)把(bǎ)熟(shú)透(tòu)的(de)大(dà)桃(táo)吃(chī)了(le)个(gè)精(jīng)光(guāng)。',
          images: <String>['assets/images/stories/havoc/c5_p1_1.png'],
          imageCaption: '孙悟空在蟠桃园',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '王(wáng)母(mǔ)娘(niáng)娘(niáng)开(kāi)蟠(pán)桃(táo)会(huì)，没(méi)有(yǒu)请(qǐng)他(tā)。'
              '他(tā)一(yī)气(qì)之(zhī)下(xià)，闯(chuǎng)进(jìn)兜(dōu)率(lǜ)宫(gōng)，把(bǎ)太(tài)上(shàng)老(lǎo)君(jūn)的(de)金(jīn)丹(dān)当(dāng)炒(chǎo)豆(dòu)吃(chī)了(le)。',
          images: <String>['assets/images/stories/havoc/c5_p2_1.png'],
          imageCaption: '孙悟空偷吃金丹',
        ),
      ],
    ),
    StoryChapter(
      id: 'c6',
      title: '天(tiān)兵(bīng)天(tiān)将(jiàng)',
      cover: 'assets/images/stories/havoc/c6_cover.png',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '玉(yù)帝(dì)大(dà)怒(nù)，派(pài)十(shí)万(wàn)天(tiān)兵(bīng)天(tiān)将(jiàng)下(xià)界(jiè)。'
              '孙(sūn)悟(wù)空(kōng)一(yī)个(gè)人(rén)挡(dǎng)在(zài)门(mén)口(kǒu)，一(yī)根(gēn)金(jīn)箍(gū)棒(bàng)打(dǎ)退(tuì)了(le)一(yī)波(bō)又(yòu)一(yī)波(bō)。',
          images: <String>['assets/images/stories/havoc/c6_p1_1.png'],
          imageCaption: '孙悟空独挡天兵',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '后(hòu)来(lái)二(èr)郎(láng)神(shén)带(dài)着(zhe)哮(xiào)天(tiān)犬(quǎn)赶(gǎn)来(lái)，两(liǎng)人(rén)斗(dòu)了(le)几(jǐ)百(bǎi)回(huí)合(hé)。'
              '最(zuì)后(hòu)，太(tài)上(shàng)老(lǎo)君(jūn)用(yòng)金(jīn)刚(gāng)琢(zhuó)砸(zá)中(zhòng)了(le)他(tā)。',
          images: <String>['assets/images/stories/havoc/c6_p2_1.png'],
          imageCaption: '二郎神与孙悟空大战',
        ),
      ],
    ),
    StoryChapter(
      id: 'c7',
      title: '五(wǔ)行(xíng)山(shān)下(xià)',
      cover: 'assets/images/stories/havoc/c7_cover.png',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '孙(sūn)悟(wù)空(kōng)被(bèi)抓(zhuā)住(zhù)，刀(dāo)砍(kǎn)不(bù)死(sǐ)，火(huǒ)烧(shāo)不(bù)烂(làn)。'
              '如(rú)来(lái)佛(fó)祖(zǔ)出(chū)手(shǒu)，把(bǎ)他(tā)压(yā)在(zài)五(wǔ)行(xíng)山(shān)下(xià)。',
          images: <String>['assets/images/stories/havoc/c7_p1_1.png'],
          imageCaption: '如来把悟空压在五行山下',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '五(wǔ)百(bǎi)年(nián)后(hòu)，他(tā)才(cái)跟(gēn)着(zhe)唐(táng)僧(sēng)去(qù)西(xī)天(tiān)取(qǔ)经(jīng)。',
          images: <String>['assets/images/stories/havoc/c7_p2_1.png'],
          imageCaption: '五百年后踏上取经路',
        ),
      ],
    ),
  ],
);

// ============================================================================
// 三、白蛇传（民间传说）
// ============================================================================

const StoryBook kStoryWhiteSnake = StoryBook(
  id: 'whitesnake',
  title: '白(bái)蛇(shé)传(zhuàn)',
  source: StorySource.legend,
  cover: 'assets/images/stories/whitesnake/cover.png',
  intro: '一(yī)把(bǎ)雨(yǔ)伞(sǎn)，换(huàn)来(lái)一(yī)世(shì)情(qíng)分(fèn)。'
      '白(bái)娘(niáng)子(zi)为(wèi)救(jiù)丈(zhàng)夫(fu)，不(bù)惜(xī)上(shàng)山(shān)盗(dào)仙(xiān)草(cǎo)。',
  difficulty: 2,
  chapters: <StoryChapter>[
    StoryChapter(
      id: 'c1',
      title: '西(xī)湖(hú)借(jiè)伞(sǎn)',
      cover: 'assets/images/stories/whitesnake/c1_cover.png',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '很(hěn)久(jiǔ)以(yǐ)前(qián)，杭(háng)州(zhōu)西(xī)湖(hú)边(biān)下(xià)起(qǐ)了(le)大(dà)雨(yǔ)。'
              '一(yī)位(wèi)白(bái)衣(yī)女(nǚ)子(zi)和(hé)一(yī)位(wèi)青(qīng)衣(yī)姑(gū)娘(niáng)躲(duǒ)在(zài)树(shù)下(xià)。',
          images: <String>['assets/images/stories/whitesnake/c1_p1_1.png'],
          imageCaption: '西湖边下起大雨',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '一(yī)个(gè)年(nián)轻(qīng)人(rén)撑(chēng)着(zhe)伞(sǎn)走(zǒu)过(guò)来(lái)。'
              '他(tā)名(míng)叫(jiào)许(xǔ)仙(xiān)，是(shì)一(yī)位(wèi)药(yào)铺(pù)的(de)伙(huǒ)计(ji)。'
              '许(xǔ)仙(xiān)看(kàn)她(tā)们(men)淋(lín)雨(yǔ)，把(bǎ)伞(sǎn)借(jiè)给(gěi)了(le)她(tā)们(men)。',
          images: <String>['assets/images/stories/whitesnake/c1_p2_1.png'],
          imageCaption: '许仙借伞',
        ),
      ],
    ),
    StoryChapter(
      id: 'c2',
      title: '成(chéng)家(jia)开(kāi)铺(pù)',
      cover: 'assets/images/stories/whitesnake/c2_cover.png',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '白(bái)娘(niáng)子(zi)记(jì)住(zhù)了(le)这(zhè)份(fèn)好(hǎo)。'
              '后(hòu)来(lái)，她(tā)和(hé)许(xǔ)仙(xiān)成(chéng)了(le)亲(qīn)。',
          images: <String>['assets/images/stories/whitesnake/c2_p1_1.png'],
          imageCaption: '白娘子与许仙成亲',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '两(liǎng)人(rén)开(kāi)了(le)一(yī)间(jiān)药(yào)铺(pù)，救(jiù)过(guò)不(bù)少(shǎo)穷(qióng)人(rén)。'
              '日(rì)子(zi)过(guò)得(de)踏(tā)实(shi)，街(jiē)坊(fāng)都(dōu)夸(kuā)他(tā)们(men)。',
          images: <String>['assets/images/stories/whitesnake/c2_p2_1.png'],
          imageCaption: '夫妻二人开药铺',
        ),
      ],
    ),
    StoryChapter(
      id: 'c3',
      title: '端(duān)午(wǔ)现(xiàn)形(xíng)',
      cover: 'assets/images/stories/whitesnake/c3_cover.png',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '一(yī)年(nián)端(duān)午(wǔ)节(jié)，许(xǔ)仙(xiān)劝(quàn)白(bái)娘(niáng)子(zi)喝(hē)了(le)雄(xióng)黄(huáng)酒(jiǔ)。'
              '白(bái)娘(niáng)子(zi)喝(hē)完(wán)，显(xiǎn)出(chū)了(le)白(bái)蛇(shé)的(de)原(yuán)形(xíng)。',
          images: <String>['assets/images/stories/whitesnake/c3_p1_1.png'],
          imageCaption: '端午节喝酒现原形',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '许(xǔ)仙(xiān)一(yī)看(kàn)，吓(xià)得(de)昏(hūn)了(le)过(guò)去(qù)。',
          images: <String>['assets/images/stories/whitesnake/c3_p2_1.png'],
          imageCaption: '许仙吓得昏倒',
        ),
      ],
    ),
    StoryChapter(
      id: 'c4',
      title: '昆(kūn)仑(lún)盗(dào)草(cǎo)',
      cover: 'assets/images/stories/whitesnake/c4_cover.png',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '白(bái)娘(niáng)子(zi)醒(xǐng)来(lái)，不(bù)顾(gù)自(zì)己(jǐ)有(yǒu)孕(yùn)在(zài)身(shēn)。'
              '她(tā)上(shàng)昆(kūn)仑(lún)山(shān)，去(qù)偷(tōu)灵(líng)芝(zhī)仙(xiān)草(cǎo)。',
          images: <String>['assets/images/stories/whitesnake/c4_p1_1.png'],
          imageCaption: '白娘子上昆仑山',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '守(shǒu)山(shān)的(de)仙(xiān)童(tóng)不(bù)肯(kěn)给(gěi)，两(liǎng)人(rén)打(dǎ)了(le)起(qǐ)来(lái)。'
              '南(nán)极(jí)仙(xiān)翁(wēng)看(kàn)她(tā)一(yī)心(xīn)救(jiù)人(rén)，把(bǎ)仙(xiān)草(cǎo)送(sòng)给(gěi)了(le)她(tā)。',
          images: <String>['assets/images/stories/whitesnake/c4_p2_1.png'],
          imageCaption: '南极仙翁送仙草',
        ),
      ],
    ),
    StoryChapter(
      id: 'c5',
      title: '不(bù)管(guǎn)人(rén)蛇(shé)',
      cover: 'assets/images/stories/whitesnake/c5_cover.png',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '许(xǔ)仙(xiān)吃(chī)下(xià)仙(xiān)草(cǎo)，慢(màn)慢(màn)醒(xǐng)了(le)过(guò)来(lái)。',
          images: <String>['assets/images/stories/whitesnake/c5_p1_1.png'],
          imageCaption: '许仙苏醒',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '他(tā)握(wò)着(zhe)白(bái)娘(niáng)子(zi)的(de)手(shǒu)说(shuō)：'
              '"不(bù)管(guǎn)你(nǐ)是(shì)人(rén)是(shì)蛇(shé)，你(nǐ)都(dōu)是(shì)我(wǒ)的(de)妻(qī)子(zi)。"',
          images: <String>['assets/images/stories/whitesnake/c5_p2_1.png'],
          imageCaption: '夫妻二人握手',
        ),
      ],
    ),
  ],
);

// ============================================================================
// 四、司马光砸缸（语文课本）
// ============================================================================

const StoryBook kStorySimaGuang = StoryBook(
  id: 'simaguang',
  title: '司(sī)马(mǎ)光(guāng)砸(zá)缸(gāng)',
  source: StorySource.textbook,
  cover: 'assets/images/stories/simaguang/cover.png',
  intro: '别(bié)人(rén)都(dōu)吓(xià)跑(pǎo)了(le)，只(zhǐ)有(yǒu)他(tā)想(xiǎng)到(dào)了(le)办(bàn)法(fǎ)。'
      '遇(yù)事(shì)不(bù)慌(huāng)，才(cái)救(jiù)了(le)一(yī)条(tiáo)命(mìng)。',
  difficulty: 1,
  chapters: <StoryChapter>[
    StoryChapter(
      id: 'c1',
      title: '爱(ài)读(dú)书(shū)的(de)孩(hái)子(zi)',
      cover: 'assets/images/stories/simaguang/c1_cover.png',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '古(gǔ)时(shí)候(hòu)有(yǒu)个(gè)孩(hái)子(zi)，名(míng)叫(jiào)司(sī)马(mǎ)光(guāng)。'
              '他(tā)从(cóng)小(xiǎo)就(jiù)爱(ài)读(dú)书(shū)，遇(yù)事(shì)不(bù)慌(huāng)。',
          images: <String>['assets/images/stories/simaguang/c1_p1_1.png'],
          imageCaption: '司马光小时候读书',
        ),
      ],
    ),
    StoryChapter(
      id: 'c2',
      title: '院(yuàn)里(li)的(de)大(dà)水(shuǐ)缸(gāng)',
      cover: 'assets/images/stories/simaguang/c2_cover.png',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '一(yī)天(tiān)，他(tā)和(hé)几(jǐ)个(gè)小(xiǎo)朋(péng)友(yǒu)在(zài)院(yuàn)子(zi)里(li)玩(wán)。'
              '院(yuàn)子(zi)里(li)有(yǒu)一(yī)口(kǒu)大(dà)水(shuǐ)缸(gāng)，比(bǐ)孩(hái)子(zi)还(hái)高(gāo)。',
          images: <String>['assets/images/stories/simaguang/c2_p1_1.png'],
          imageCaption: '院子里的水缸',
        ),
      ],
    ),
    StoryChapter(
      id: 'c3',
      title: '有(yǒu)人(rén)掉(diào)进(jìn)去(qù)了(le)',
      cover: 'assets/images/stories/simaguang/c3_cover.png',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '一(yī)个(gè)小(xiǎo)孩(hái)爬(pá)到(dào)缸(gāng)沿(yán)上(shàng)，一(yī)不(bù)小(xiǎo)心(xīn)掉(diào)了(le)进(jìn)去(qù)。'
              '水(shuǐ)缸(gāng)里(li)装(zhuāng)满(mǎn)了(le)水(shuǐ)，那(nà)孩(hái)子(zi)喊(hǎn)不(bù)出(chū)来(lái)。',
          images: <String>['assets/images/stories/simaguang/c3_p1_1.png'],
          imageCaption: '小孩掉进水缸',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '别(bié)的(de)孩(hái)子(zi)都(dōu)吓(xià)坏(huài)了(le)，有(yǒu)的(de)哭(kū)，有(yǒu)的(de)跑(pǎo)。',
          images: <String>['assets/images/stories/simaguang/c3_p2_1.png'],
          imageCaption: '孩子们吓坏了',
        ),
      ],
    ),
    StoryChapter(
      id: 'c4',
      title: '搬(bān)起(qǐ)石(shí)头(tou)',
      cover: 'assets/images/stories/simaguang/c4_cover.png',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '司(sī)马(mǎ)光(guāng)没(méi)有(yǒu)跑(pǎo)。'
              '他(tā)搬(bān)起(qǐ)一(yī)块(kuài)大(dà)石(shí)头(tou)，使(shǐ)足(zú)力(lì)气(qì)砸(zá)过(guò)去(qù)。',
          images: <String>['assets/images/stories/simaguang/c4_p1_1.png'],
          imageCaption: '司马光搬起石头砸缸',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '"咣(guāng)"的(de)一(yī)声(shēng)，水(shuǐ)缸(gāng)破(pò)了(le)。'
              '水(shuǐ)一(yī)下(xià)子(zi)流(liú)了(le)出(chū)来(lái)，那(nà)个(gè)孩(hái)子(zi)得(dé)救(jiù)了(le)。',
          images: <String>['assets/images/stories/simaguang/c4_p2_1.png'],
          imageCaption: '水缸破了，孩子得救',
        ),
        StoryParagraph(
          id: 'p3',
          ruby: '大(dà)人(rén)们(men)赶(gǎn)来(lái)，都(dōu)夸(kuā)司(sī)马(mǎ)光(guāng)聪(cōng)明(míng)。'
              '这(zhè)件(jiàn)事(shì)一(yī)直(zhí)传(chuán)到(dào)今(jīn)天(tiān)。',
          images: <String>['assets/images/stories/simaguang/c4_p3_1.png'],
          imageCaption: '大人们夸奖司马光',
        ),
      ],
    ),
  ],
);

// ============================================================================
// 五、小马过河（语文课本）
// ============================================================================

const StoryBook kStoryPony = StoryBook(
  id: 'pony',
  title: '小(xiǎo)马(mǎ)过(guò)河(hé)',
  source: StorySource.textbook,
  cover: 'assets/images/stories/pony/cover.png',
  intro: '老(lǎo)牛(niú)说(shuō)水(shuǐ)浅(qiǎn)，松(sōng)鼠(shǔ)说(shuǐ)水(shuǐ)深(shēn)。'
      '其(qí)实(shí)自(zì)己(jǐ)试(shì)一(yī)试(shì)，就(jiù)知(zhī)道(dào)了(le)。',
  difficulty: 1,
  chapters: <StoryChapter>[
    StoryChapter(
      id: 'c1',
      title: '娘(niáng)让(ràng)我(wǒ)送(sòng)麦(mài)子(zi)',
      cover: 'assets/images/stories/pony/c1_cover.png',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '有(yǒu)一(yī)匹(pǐ)小(xiǎo)马(mǎ)，和(hé)妈(mā)妈(ma)住(zhù)在(zài)河(hé)边(biān)。',
          images: <String>['assets/images/stories/pony/c1_p1_1.png'],
          imageCaption: '小马和妈妈住在河边',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '一(yī)天(tiān)，妈(mā)妈(ma)说(shuō)："你(nǐ)帮(bāng)我(wǒ)把(bǎ)这(zhè)半(bàn)袋(dài)麦(mài)子(zi)送(sòng)到(dào)磨(mò)坊(fáng)去(qù)。"'
              '小(xiǎo)马(mǎ)驮(duò)起(qǐ)麦(mài)子(zi)，飞(fēi)快(kuài)地(de)跑(pǎo)出(chū)去(qù)了(le)。',
          images: <String>['assets/images/stories/pony/c1_p2_1.png'],
          imageCaption: '小马驮着麦子上路',
        ),
      ],
    ),
    StoryChapter(
      id: 'c2',
      title: '一(yī)条(tiáo)小(xiǎo)河(hé)',
      cover: 'assets/images/stories/pony/c2_cover.png',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '跑(pǎo)着(zhe)跑(pǎo)着(zhe)，一(yī)条(tiáo)小(xiǎo)河(hé)挡(dǎng)住(zhù)了(le)去(qù)路(lù)。'
              '小(xiǎo)马(mǎ)为(wéi)难(nán)了(le)：这(zhè)条(tiáo)河(hé)我(wǒ)能(néng)过(guò)去(qù)吗(ma)？',
          images: <String>['assets/images/stories/pony/c2_p1_1.png'],
          imageCaption: '小马被小河挡住',
        ),
      ],
    ),
    StoryChapter(
      id: 'c3',
      title: '老(lǎo)牛(niú)说(shuō)水(shuǐ)浅(qiǎn)',
      cover: 'assets/images/stories/pony/c3_cover.png',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '他(tā)看(kàn)见(jiàn)一(yī)头(tóu)老(lǎo)牛(niú)在(zài)河(hé)边(biān)吃(chī)草(cǎo)。',
          images: <String>['assets/images/stories/pony/c3_p1_1.png'],
          imageCaption: '老牛在河边吃草',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '小(xiǎo)马(mǎ)问(wèn)："牛(niú)伯(bó)伯(bó)，请(qǐng)您(nín)告(gào)诉(su)我(wǒ)，这(zhè)条(tiáo)河(hé)我(wǒ)能(néng)蹚(tāng)过(guò)去(qù)吗(ma)？"'
              '老(lǎo)牛(niú)说(shuō)："水(shuǐ)很(hěn)浅(qiǎn)，刚(gāng)没(mò)小(xiǎo)腿(tuǐ)，能(néng)过(guò)。"',
          images: <String>['assets/images/stories/pony/c3_p2_1.png'],
          imageCaption: '老牛告诉小河水浅',
        ),
      ],
    ),
    StoryChapter(
      id: 'c4',
      title: '松(sōng)鼠(shǔ)说(shuō)水(shuǐ)深(shēn)',
      cover: 'assets/images/stories/pony/c4_cover.png',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '小(xiǎo)马(mǎ)正(zhèng)要(yào)下(xià)水(shuǐ)，树(shù)上(shàng)的(de)松(sōng)鼠(shǔ)急(jí)得(de)大(dà)叫(jiào)：'
              '"小(xiǎo)马(mǎ)，别(bié)过(guò)河(hé)！河(hé)水(shuǐ)很(hěn)深(shēn)，昨(zuó)天(tiān)我(wǒ)的(de)同(tóng)伴(bàn)就(jiù)淹(yān)死(sǐ)了(le)。"',
          images: <String>['assets/images/stories/pony/c4_p1_1.png'],
          imageCaption: '松鼠在树上大叫',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '小(xiǎo)马(mǎ)不(bù)知(zhī)道(dào)该(gāi)听(tīng)谁(shuí)的(de)，跑(pǎo)回(huí)家(jiā)问(wèn)妈(mā)妈(ma)。',
          images: <String>['assets/images/stories/pony/c4_p2_1.png'],
          imageCaption: '小马跑回家问妈妈',
        ),
      ],
    ),
    StoryChapter(
      id: 'c5',
      title: '自(zì)己(jǐ)试(shì)一(yī)试(shì)',
      cover: 'assets/images/stories/pony/c5_cover.png',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '妈(mā)妈(ma)说(shuō)："孩(hái)子(zi)，光(guāng)听(tīng)别(bié)人(rén)说(shuō)不(bù)行(xíng)。"'
              '"你(nǐ)自(zì)己(jǐ)去(qù)试(shì)一(yī)试(shì)，就(jiù)知(zhī)道(dào)了(le)。"',
          images: <String>['assets/images/stories/pony/c5_p1_1.png'],
          imageCaption: '妈妈教导小马',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '小(xiǎo)马(mǎ)又(yòu)跑(pǎo)到(dào)河(hé)边(biān)，小(xiǎo)心(xīn)地(de)蹚(tāng)进(jìn)水(shuǐ)里(li)。'
              '原(yuán)来(lái)河(hé)水(shuǐ)既(jì)不(bù)像(xiàng)老(lǎo)牛(niú)说(shuō)的(de)那(nà)样(yàng)浅(qiǎn)，也(yě)不(bù)像(xiàng)松(sōng)鼠(shǔ)说(shuō)的(de)那(nà)样(yàng)深(shēn)。',
          images: <String>['assets/images/stories/pony/c5_p2_1.png'],
          imageCaption: '小马小心蹚水',
        ),
        StoryParagraph(
          id: 'p3',
          ruby: '小(xiǎo)马(mǎ)顺(shùn)利(lì)地(de)过(guò)了(le)河(hé)，把(bǎ)麦(mài)子(zi)送(sòng)到(dào)了(le)磨(mò)坊(fáng)。',
          images: <String>['assets/images/stories/pony/c5_p3_1.png'],
          imageCaption: '小马顺利过河',
        ),
      ],
    ),
  ],
);

// ============================================================================
// 六、赶集（原创 · 80 年代农村生活故事）
// ============================================================================

const StoryBook kStoryMarket = StoryBook(
  id: 'market',
  title: '赶(gǎn)集(jí)',
  source: StorySource.life,
  cover: 'assets/images/stories/market/cover.png',
  intro: '三(sān)块(kuài)二(èr)毛(máo)钱(qián)，娘(niáng)数(shǔ)了(le)两(liǎng)遍(biàn)，'
      '给(gěi)我(wǒ)买(mǎi)了(le)一(yī)根(gēn)冰(bīng)棍(gùn)。',
  difficulty: 1,
  chapters: <StoryChapter>[
    StoryChapter(
      id: 'c1',
      title: '天(tiān)没(méi)亮(liàng)就(jiù)起(qǐ)床(chuáng)',
      cover: 'assets/images/stories/market/c1_cover.png',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '天(tiān)还(hái)没(méi)亮(liàng)，娘(niáng)就(jiù)起(qǐ)了(le)床(chuáng)。'
              '她(tā)把(bǎ)鸡(jī)蛋(dàn)一(yī)个(gè)一(yī)个(gè)放(fàng)进(jìn)竹(zhú)篮(lán)里(li)。',
          images: <String>['assets/images/stories/market/c1_p1_1.png'],
          imageCaption: '天没亮，娘往竹篮里放鸡蛋',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '今(jīn)天(tiān)是(shì)镇(zhèn)上(shàng)逢(féng)集(jí)的(de)日(rì)子(zi)。',
          images: <String>['assets/images/stories/market/c1_p2_1.png'],
          imageCaption: '集日的招牌',
        ),
      ],
    ),
    StoryChapter(
      id: 'c2',
      title: '走(zǒu)过(guò)麦(mài)田(tián)',
      cover: 'assets/images/stories/market/c2_cover.png',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '我(wǒ)背(bēi)着(zhe)竹(zhú)篮(lán)，娘(niáng)提(tí)着(zhe)布(bù)口(kǒu)袋(dài)，一(yī)起(qǐ)上(shàng)路(lù)。'
              '土(tǔ)路(lù)两(liǎng)旁(páng)是(shì)麦(mài)田(tián)，风(fēng)一(yī)吹(chuī)，麦(mài)浪(làng)一(yī)层(céng)接(jiē)一(yī)层(céng)。',
          images: <String>['assets/images/stories/market/c2_p1_1.png'],
          imageCaption: '娘俩走在麦田间的土路上',
        ),
      ],
    ),
    StoryChapter(
      id: 'c3',
      title: '街(jiē)上(shàng)真(zhēn)热(rè)闹(nao)',
      cover: 'assets/images/stories/market/c3_cover.png',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '走(zǒu)了(le)一(yī)个(gè)钟(zhōng)头(tóu)，镇(zhèn)上(shàng)到(dào)了(le)。'
              '街(jiē)上(shàng)人(rén)挤(jǐ)人(rén)，卖(mài)菜(cài)的(de)、卖(mài)布(bù)的(de)、卖(mài)糖(táng)的(de)，吆(yāo)喝(he)声(shēng)不(bù)断(duàn)。',
          images: <String>['assets/images/stories/market/c3_p1_1.png'],
          imageCaption: '镇上集市人来人往',
        ),
      ],
    ),
    StoryChapter(
      id: 'c4',
      title: '三(sān)块(kuài)二(èr)毛(máo)钱(qián)',
      cover: 'assets/images/stories/market/c4_cover.png',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '娘(niáng)把(bǎ)鸡(jī)蛋(dàn)卖(mài)给(gěi)了(le)一(yī)位(wèi)老(lǎo)大(dà)爷(ye)。'
              '三(sān)块(kuài)二(èr)毛(máo)钱(qián)，她(tā)捏(niē)在(zài)手(shǒu)里(li)，数(shǔ)了(le)两(liǎng)遍(biàn)。',
          images: <String>['assets/images/stories/market/c4_p1_1.png'],
          imageCaption: '娘数着手里的零钱',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '然(rán)后(hòu)她(tā)给(gěi)我(wǒ)买(mǎi)了(le)一(yī)根(gēn)冰(bīng)棍(gùn)。',
          images: <String>['assets/images/stories/market/c4_p2_1.png'],
          imageCaption: '娘给我买冰棍',
        ),
      ],
    ),
    StoryChapter(
      id: 'c5',
      title: '回(huí)家(jiā)的(de)路(lù)上(shàng)',
      cover: 'assets/images/stories/market/c5_cover.png',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '回(huí)家(jiā)的(de)路(lù)上(shàng)，太(tài)阳(yáng)已(yǐ)经(jīng)偏(piān)西(xī)了(le)。'
              '我(wǒ)舔(tiǎn)着(zhe)冰(bīng)棍(gùn)，走(zǒu)在(zài)娘(niáng)的(de)影(yǐng)子(zi)里(li)。',
          images: <String>['assets/images/stories/market/c5_p1_1.png'],
          imageCaption: '夕阳下娘俩走在回家路上',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '那(nà)根(gēn)冰(bīng)棍(gùn)的(de)甜(tián)，我(wǒ)到(dào)现(xiàn)在(zài)还(hái)记(jì)得(de)。',
          images: <String>['assets/images/stories/market/c5_p2_1.png'],
          imageCaption: '冰棍的特写',
        ),
      ],
    ),
  ],
);

// ============================================================================
// 守株待兔（中国寓言）
// ============================================================================

const StoryBook kStoryFableShouzhu = StoryBook(
  id: 'fable_shouzhu',
  title: '守(shǒu)株(zhū)待(dài)兔(tù)',
  source: StorySource.fable,
  cover: 'assets/images/stories/fable_shouzhu/cover.png',
  intro: '有(yǒu)个(gè)农(nóng)夫(fū)天(tiān)天(tiān)守(shǒu)在(zài)树(shù)下(xià)，盼(pàn)着(zhe)兔(tù)子(zi)再(zài)撞(zhuàng)上(shàng)来(lái)。',
  difficulty: 1,
  chapters: <StoryChapter>[
    StoryChapter(
      id: 'c1',
      title: '农(nóng)夫(fū)和(hé)兔(tù)子(zi)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '从(cóng)前(qián)有(yǒu)个(gè)农(nóng)夫(fū)，天(tiān)不(bù)亮(liàng)就(jiù)下(xià)地(dì)，在(zài)田(tián)里(li)弯(wān)腰(yāo)干(gàn)一(yī)整(zhěng)天(tiān)的(de)活(huó)。',
          images: <String>['assets/images/stories/fable_shouzhu/c1_p1_1.png'],
          imageCaption: '第1章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '一(yī)天(tiān)，一(yī)只(zhī)白(bái)兔(tù)飞(fēi)快(kuài)跑(pǎo)来(lái)，头(tóu)一(yī)歪(wāi)撞(zhuàng)死(sǐ)在(zài)树(shù)底(dǐ)下(xià)，再(zài)也(yě)不(bù)动(dòng)了(le)。',
          images: <String>[],
          imageCaption: '第1章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c2',
      title: '白(bái)捡(jiǎn)便(biàn)宜(yí)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '农(nóng)夫(fū)走(zǒu)过(guò)去(qù)，轻(qīng)易(yì)捡(jiǎn)到(dào)一(yī)只(zhī)肥(féi)兔(tù)子(zi)，心(xīn)里(li)又(yòu)惊(jīng)又(yòu)喜(xǐ)合(hé)不(bù)拢(lǒng)嘴(zuǐ)。',
          images: <String>['assets/images/stories/fable_shouzhu/c2_p1_1.png'],
          imageCaption: '第2章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '他(tā)盘(pán)算(suàn)着(zhe)：这(zhè)等(děng)好(hǎo)事(shì)不(bù)费(fèi)力(lì)气(qì)，比(bǐ)种(zhòng)地(dì)强(qiáng)上(shàng)百(bǎi)倍(bèi)呢(ne)。',
          images: <String>[],
          imageCaption: '第2章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c3',
      title: '放(fàng)下(xià)农(nóng)活(huó)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '第(dì)二(èr)天(tiān)他(tā)不(bù)再(zài)下(xià)田(tián)，搬(bān)个(gè)小(xiǎo)凳(dèng)坐(zuò)在(zài)树(shù)下(xià)，眼(yǎn)巴(bā)巴(bā)等(děng)兔(tù)子(zi)再(zài)撞(zhuàng)上(shàng)来(lái)。',
          images: <String>['assets/images/stories/fable_shouzhu/c3_p1_1.png'],
          imageCaption: '第3章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '他(tā)想(xiǎng)：田(tián)里(li)草(cǎo)长(zhǎng)由(yóu)它(tā)去(qù)，反(fǎn)正(zhèng)兔(tù)子(zi)会(huì)自(zì)己(jǐ)送(sòng)上(shàng)门(mén)，何(hé)必(bì)流(liú)汗(hàn)。',
          images: <String>[],
          imageCaption: '第3章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c4',
      title: '天(tiān)天(tiān)空(kōng)等(děng)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '一(yī)天(tiān)过(guò)去(qù)没(méi)兔(tù)来(lái)，两(liǎng)天(tiān)过(guò)去(qù)仍(réng)没(méi)有(yǒu)，他(tā)饿(è)得(de)肚(dù)子(zi)咕(gū)咕(gū)直(zhí)叫(jiào)。',
          images: <String>['assets/images/stories/fable_shouzhu/c4_p1_1.png'],
          imageCaption: '第4章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '他(tā)从(cóng)早(zǎo)坐(zuò)到(dào)晚(wǎn)，田(tián)里(li)的(de)禾(hé)苗(miáo)被(bèi)草(cǎo)盖(gài)住(zhù)，邻(lín)居(jū)看(kàn)了(le)直(zhí)摇(yáo)头(tóu)。',
          images: <String>[],
          imageCaption: '第4章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c5',
      title: '田(tián)地(dì)荒(huāng)了(le)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '邻(lín)居(jū)劝(quàn)他(tā)说(shuō)：兔(tù)子(zi)撞(zhuàng)树(shù)是(shì)碰(pèng)巧(qiǎo)，哪(nǎ)能(néng)天(tiān)天(tiān)有(yǒu)，快(kuài)去(qù)把(bǎ)草(cǎo)锄(chú)一(yī)锄(chú)。',
          images: <String>['assets/images/stories/fable_shouzhu/c5_p1_1.png'],
          imageCaption: '第5章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '他(tā)不(bù)听(tīng)劝(quàn)，地(dì)越(yuè)发(fā)荒(huāng)，家(jiā)里(li)粮(liáng)食(shi)见(jiàn)了(le)底(dǐ)，日(rì)子(zi)越(yuè)过(guò)越(yuè)穷(qióng)酸(suān)。',
          images: <String>[],
          imageCaption: '第5章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c6',
      title: '故(gù)事(shì)的(de)道(dào)理(lǐ)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '靠(kào)运(yùn)气(qì)过(guò)日(rì)子(zi)，不(bù)如(rú)踏(tà)踏(tà)实(shí)实(shí)干(gàn)活(huó)，一(yī)锹(qiāo)土(tǔ)一(yī)粒(lì)粮(liáng)才(cái)靠(kào)得(de)住(zhù)。',
          images: <String>['assets/images/stories/fable_shouzhu/c6_p1_1.png'],
          imageCaption: '第6章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '一(yī)次(cì)好(hǎo)运(yùn)不(bù)能(néng)当(dāng)一(yī)辈(bèi)子(zi)的(de)饭(fàn)，勤(qín)快(kuài)的(de)人(rén)才(cái)吃(chī)得(de)长(cháng)久(jiǔ)。',
          images: <String>[],
          imageCaption: '第6章第2段',
        ),
      ],
    ),
  ],
);

// ============================================================================
// 亡羊补牢（中国寓言）
// ============================================================================

const StoryBook kStoryFableWangyang = StoryBook(
  id: 'fable_wangyang',
  title: '亡(wáng)羊(yáng)补(bǔ)牢(láo)',
  source: StorySource.fable,
  cover: 'assets/images/stories/fable_wangyang/cover.png',
  intro: '羊(yáng)圈(juàn)破(pò)了(le)洞(dòng)，丢(diū)了(le)羊(yáng)才(cái)去(qù)修(xiū)，还(hái)不(bù)算(suàn)晚(wǎn)。',
  difficulty: 1,
  chapters: <StoryChapter>[
    StoryChapter(
      id: 'c1',
      title: '丢(diū)了(le)羊(yáng)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '有(yǒu)个(gè)人(rén)养(yǎng)了(le)一(yī)群(qún)羊(yáng)，圈(juàn)栏(lán)用(yòng)木(mù)头(tou)一(yī)根(gēn)根(gēn)围(wéi)起(qǐ)来(lái)。',
          images: <String>['assets/images/stories/fable_wangyang/c1_p1_1.png'],
          imageCaption: '第1章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '一(yī)天(tiān)早(zǎo)上(shàng)他(tā)去(qù)放(fàng)羊(yáng)，发(fā)现(xiàn)少(shǎo)了(le)一(yī)只(zhī)，原(yuán)来(lái)圈(juàn)上(shàng)破(pò)了(le)个(gè)大(dà)洞(dòng)。',
          images: <String>[],
          imageCaption: '第1章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c2',
      title: '不(bù)听(tīng)劝(quàn)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '邻(lín)居(jū)看(kàn)见(jiàn)说(shuō)：快(kuài)把(bǎ)洞(dòng)补(bǔ)上(shàng)吧(ba)，不(bù)然(rán)夜(yè)里(li)狼(láng)还(hái)会(huì)钻(zuān)进(jìn)来(lái)。',
          images: <String>['assets/images/stories/fable_wangyang/c2_p1_1.png'],
          imageCaption: '第2章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '他(tā)摇(yáo)摇(yáo)头(tóu)说(shuō)：羊(yáng)都(dōu)丢(diū)了(le)，再(zài)补(bǔ)也(yě)是(shì)晚(wǎn)了(le)，白(bái)费(fèi)那(nà)劲(jìn)。',
          images: <String>[],
          imageCaption: '第2章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c3',
      title: '又(yòu)丢(diū)一(yī)只(zhī)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '第(dì)二(èr)天(tiān)一(yī)早(zǎo)，他(tā)数(shǔ)羊(yáng)又(yòu)少(shǎo)一(yī)只(zhī)，狼(láng)果(guǒ)然(rán)从(cóng)破(pò)洞(dòng)钻(zuān)进(jìn)去(qù)叼(diāo)走(zǒu)。',
          images: <String>['assets/images/stories/fable_wangyang/c3_p1_1.png'],
          imageCaption: '第3章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '他(tā)后(hòu)悔(huǐ)得(de)直(zhí)拍(pāi)大(dà)腿(tuǐ)，才(cái)明(míng)白(bái)邻(lín)居(jū)的(de)话(huà)句(jù)句(jù)在(zài)理(lǐ)。',
          images: <String>[],
          imageCaption: '第3章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c4',
      title: '赶(gǎn)紧(jǐn)补(bǔ)牢(láo)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '他(tā)立(lì)刻(kè)找(zhǎo)来(lái)钉(dīng)子(zi)和(hé)木(mù)板(bǎn)，把(bǎ)圈(juàn)上(shàng)的(de)破(pò)洞(dòng)一(yī)个(gè)个(gè)钉(dīng)牢(láo)。',
          images: <String>['assets/images/stories/fable_wangyang/c4_p1_1.png'],
          imageCaption: '第4章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '从(cóng)此(cǐ)圈(juàn)栏(lán)严(yán)严(yán)实(shí)实(shí)，狼(láng)再(zài)也(yě)无(wú)法(fǎ)钻(zuān)进(jìn)来(lái)了(le)。',
          images: <String>[],
          imageCaption: '第4章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c5',
      title: '不(bù)再(zài)丢(diū)羊(yáng)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '圈(juàn)牢(láo)了(le)，羊(yáng)一(yī)只(zhī)也(yě)没(méi)丢(diū)，他(tā)的(de)日(rì)子(zi)又(yòu)踏(tà)实(shí)又(yòu)安(ān)稳(wěn)。',
          images: <String>['assets/images/stories/fable_wangyang/c5_p1_1.png'],
          imageCaption: '第5章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '他(tā)笑(xiào)着(zhe)对(duì)邻(lín)居(jū)说(shuō)：迟(chí)做(zuò)总(zǒng)比(bǐ)不(bù)做(zuò)强(qiáng)，以(yǐ)后(hòu)我(wǒ)记(jì)住(zhù)了(le)。',
          images: <String>[],
          imageCaption: '第5章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c6',
      title: '故(gù)事(shì)的(de)道(dào)理(lǐ)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '出(chū)了(le)错(cuò)不(bù)要(yào)紧(jǐn)，赶(gǎn)快(kuài)改(gǎi)正(zhèng)就(jiù)还(hái)来(lái)得(de)及(jí)。',
          images: <String>['assets/images/stories/fable_wangyang/c6_p1_1.png'],
          imageCaption: '第6章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '怕(pà)的(de)是(shì)明(míng)明(míng)有(yǒu)错(cuò)，还(hái)硬(yìng)撑(chēng)着(zhe)不(bù)改(gǎi)，那(nà)才(cái)真(zhēn)吃(chī)亏(kuī)。',
          images: <String>[],
          imageCaption: '第6章第2段',
        ),
      ],
    ),
  ],
);

// ============================================================================
// 揠苗助长（中国寓言）
// ============================================================================

const StoryBook kStoryFableYamiao = StoryBook(
  id: 'fable_yamiao',
  title: '揠(yà)苗(miáo)助(zhù)长(zhǎng)',
  source: StorySource.fable,
  cover: 'assets/images/stories/fable_yamiao/cover.png',
  intro: '有(yǒu)个(gè)人(rén)嫌(xián)禾(hé)苗(miáo)长(zhǎng)得(de)太(tài)慢(màn)，把(bǎ)苗(miáo)一(yī)棵(kē)棵(kē)往(wǎng)上(shàng)拔(bá)高(gāo)。',
  difficulty: 1,
  chapters: <StoryChapter>[
    StoryChapter(
      id: 'c1',
      title: '种(zhǒng)了(le)一(yī)地(dì)苗(miáo)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '古(gǔ)时(shí)候(hòu)有(yǒu)个(gè)农(nóng)夫(fū)，在(zài)地(dì)里(li)种(zhòng)下(xià)一(yī)片(piàn)绿(lǜ)油(yóu)油(yóu)的(de)禾(hé)苗(miáo)。',
          images: <String>['assets/images/stories/fable_yamiao/c1_p1_1.png'],
          imageCaption: '第1章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '他(tā)天(tiān)天(tiān)去(qù)地(dì)里(li)看(kàn)，巴(bā)不(bù)得(de)一(yī)夜(yè)之(zhī)间(jiān)苗(miáo)就(jiù)长(zhǎng)到(dào)腰(yāo)那(nà)么(me)高(gāo)。',
          images: <String>[],
          imageCaption: '第1章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c2',
      title: '嫌(xián)它太(tài)慢(màn)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '过(guò)了(le)几(jǐ)天(tiān)，苗(miáo)才(cái)高(gāo)了(le)一(yī)指(zhǐ)头(tou)，他(tā)急(jí)得(de)直(zhí)在(zài)田(tián)埂(gěng)上(shàng)转(zhuǎn)圈(quān)。',
          images: <String>['assets/images/stories/fable_yamiao/c2_p1_1.png'],
          imageCaption: '第2章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '他(tā)嘀(dí)咕(gu)着(zhe)：我(wǒ)帮(bāng)它(tā)们(men)长(zhǎng)一(yī)长(zhǎng)，不(bù)就(jiù)省(shěng)下(xià)好(hǎo)多(duō)日(rì)子(zi)吗(ma)。',
          images: <String>[],
          imageCaption: '第2章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c3',
      title: '一(yī)棵(kē)棵(kē)拔(bá)高(gāo)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '他(tā)下(xià)到(dào)田(tián)里(li)，弯(wān)腰(yāo)把(bǎ)每(měi)棵(kē)苗(miáo)都(dōu)往(wǎng)上(shàng)拔(bá)了(le)一(yī)截(jié)。',
          images: <String>['assets/images/stories/fable_yamiao/c3_p1_1.png'],
          imageCaption: '第3章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '拔(bá)了(le)一(yī)整(zhěng)天(tiān)，他(tā)看(kàn)着(zhe)高(gāo)了(le)一(yī)截(jié)的(de)苗(miáo)，累(lèi)坏(huài)了(le)也(yě)满(mǎn)意(yì)。',
          images: <String>[],
          imageCaption: '第3章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c4',
      title: '告(gào)诉(su)家(jia)人(rén)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '回(huí)到(dào)家(jiā)他(tā)对(duì)儿(ér)子(zi)说(shuō)：今(jīn)天(tiān)可(kě)把(bǎ)我(wǒ)累(lèi)坏(huài)了(le)，咱(zán)家(jiā)苗(miáo)全(quán)长(zhǎng)高(gāo)啦(la)。',
          images: <String>['assets/images/stories/fable_yamiao/c4_p1_1.png'],
          imageCaption: '第4章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '儿(ér)子(zi)听(tīng)了(le)大(dà)吃(chī)一(yī)惊(jīng)，撒(sā)腿(tuǐ)就(jiù)往(wǎng)田(tián)里(li)跑(pǎo)去(qù)。',
          images: <String>[],
          imageCaption: '第4章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c5',
      title: '苗(miáo)都(dōu)枯(kū)了(le)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '到(dào)了(le)田(tián)边(biān)，禾(hé)苗(miáo)全(quán)无(wú)精(jīng)打(dǎ)采(cǎi)，叶(yè)子(zi)已(yǐ)经(jīng)发(fā)黄(huáng)打(dǎ)蔫(niān)。',
          images: <String>['assets/images/stories/fable_yamiao/c5_p1_1.png'],
          imageCaption: '第5章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '拔(bá)断(duàn)了(le)根(gēn)的(de)苗(miáo)一(yī)夜(yè)之(zhī)间(jiān)全(quán)枯(kū)死(sǐ)，田(tián)里(li)光(guāng)秃(tū)秃(tū)的(de)。',
          images: <String>[],
          imageCaption: '第5章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c6',
      title: '故(gù)事(shì)的(de)道(dào)理(lǐ)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '万(wàn)事(shì)都(dōu)有(yǒu)自(zì)己(jǐ)的(de)步(bù)子(zi)，急(jí)不(bù)得(de)也(yě)催(cuī)不(bù)得(de)。',
          images: <String>['assets/images/stories/fable_yamiao/c6_p1_1.png'],
          imageCaption: '第6章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '硬(yìng)要(yào)拔(bá)它(tā)长(zhǎng)快(kuài)，反(fǎn)而(ér)把(bǎ)好(hǎo)端(duān)端(duān)的(de)苗(miáo)全(quán)毁(huǐ)了(le)。',
          images: <String>[],
          imageCaption: '第6章第2段',
        ),
      ],
    ),
  ],
);

// ============================================================================
// 狐假虎威（中国寓言）
// ============================================================================

const StoryBook kStoryFableHujia = StoryBook(
  id: 'fable_hujia',
  title: '狐(hú)假(jiǎ)虎(hǔ)威(wēi)',
  source: StorySource.fable,
  cover: 'assets/images/stories/fable_hujia/cover.png',
  intro: '狐(hú)狸(li)借(jiè)老(lǎo)虎(hǔ)的(de)威(wēi)风(fēng)，吓(xià)跑(pǎo)了(le)林(lín)里(li)所(suǒ)有(yǒu)的(de)百(bǎi)兽(shòu)。',
  difficulty: 1,
  chapters: <StoryChapter>[
    StoryChapter(
      id: 'c1',
      title: '老(lǎo)虎(hǔ)逮(dài)住(zhù)狐(hú)狸(lí)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '森(sēn)林(lín)里(li)有(yǒu)只(zhī)老(lǎo)虎(hǔ)，一(yī)天(tiān)出(chū)门(mén)逮(dǎi)住(zhù)了(le)一(yī)只(zhī)胖(pàng)狐(hú)狸(li)。',
          images: <String>['assets/images/stories/fable_hujia/c1_p1_1.png'],
          imageCaption: '第1章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '狐(hú)狸(li)吓(xià)得(de)浑(hún)身(shēn)发(fā)抖(dǒu)，脑(nǎo)袋(dai)里(li)飞(fēi)快(kuài)转(zhuàn)着(zhe)逃(táo)命(mìng)的(de)主(zhǔ)意(yi)。',
          images: <String>[],
          imageCaption: '第1章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c2',
      title: '狐(hú)狸(lí)吹(chuī)牛(niú)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '狐(hú)狸(li)挺(tǐng)起(qǐ)胸(xiōng)脯(pú)说(shuō)：你(nǐ)不(bù)敢(gǎn)吃(chī)我(wǒ)，天(tiān)帝(dì)派(pài)我(wǒ)管(guǎn)着(zhe)百(bǎi)兽(shòu)。',
          images: <String>['assets/images/stories/fable_hujia/c2_p1_1.png'],
          imageCaption: '第2章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '老(lǎo)虎(hǔ)半(bàn)信(xìn)半(bàn)疑(yí)，眨(zhǎ)着(zhe)眼(yǎn)盯(dīng)着(zhe)它(tā)，不(bù)知(zhī)该(gāi)不(bù)该(gāi)下(xià)口(kǒu)。',
          images: <String>[],
          imageCaption: '第2章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c3',
      title: '跟(gēn)着(zhe)走(zǒu)一(yī)趟(tàng)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '狐(hú)狸(li)说(shuō)：你(nǐ)跟(gēn)在(zài)我(wǒ)后(hòu)头(tou)走(zǒu)一(yī)趟(tàng)，看(kàn)看(kān)谁(shuí)见(jiàn)了(le)我(wǒ)不(bù)跑(pǎo)。',
          images: <String>['assets/images/stories/fable_hujia/c3_p1_1.png'],
          imageCaption: '第3章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '老(lǎo)虎(hǔ)真(zhēn)的(de)跟(gēn)着(zhe)狐(hú)狸(li)，一(yī)步(bù)一(yī)步(bù)走(zǒu)进(jìn)了(le)密(mì)林(lín)。',
          images: <String>[],
          imageCaption: '第3章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c4',
      title: '百(bǎi)兽(shòu)都(dōu)跑(pǎo)了(le)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '小(xiǎo)鹿(lù)、兔(tù)子(zi)、野(yě)猪(zhū)远(yuǎn)远(yuǎn)望(wàng)见(jiàn)老(lǎo)虎(hǔ)，吓(xià)得(de)掉(diào)头(tóu)就(jiù)没(méi)了(le)影(yǐng)。',
          images: <String>['assets/images/stories/fable_hujia/c4_p1_1.png'],
          imageCaption: '第4章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '狐(hú)狸(li)昂(áng)着(zhe)头(tóu)大(dà)摇(yáo)大(dà)摆(bǎi)，活(huó)像(xiàng)个(gè)大(dà)王(wáng)在(zài)巡(xún)山(shān)。',
          images: <String>[],
          imageCaption: '第4章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c5',
      title: '老(lǎo)虎(hǔ)上(shàng)当(dāng)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '老(lǎo)虎(hǔ)不(bù)知(zhī)道(dào)百(bǎi)兽(shòu)怕(pà)的(de)是(shì)它(tā)，还(hái)以(yǐ)为(wéi)真(zhēn)怕(pà)狐(hú)狸(li)。',
          images: <String>['assets/images/stories/fable_hujia/c5_p1_1.png'],
          imageCaption: '第5章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '它(tā)夹(jiā)着(zhe)尾(wěi)巴(ba)走(zǒu)开(kāi)了(le)，狐(hú)狸(li)背(bèi)后(hòu)偷(tōu)偷(tōu)笑(xiào)弯(wān)了(le)腰(yāo)。',
          images: <String>[],
          imageCaption: '第5章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c6',
      title: '故(gù)事(shì)的(de)道(dào)理(lǐ)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '靠(kào)着(zhe)别(bié)人(rén)的(de)势(shì)力(lì)吓(xià)人(rén)，本(běn)身(shēn)并(bìng)不(bù)算(suàn)本(běn)事(shì)。',
          images: <String>['assets/images/stories/fable_hujia/c6_p1_1.png'],
          imageCaption: '第6章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '看(kàn)清(qīng)谁(shuí)才(cái)真(zhēn)正(zhèng)有(yǒu)能(néng)耐(nài)，才(cái)不(bù)会(huì)上(shàng)当(dàng)受(shòu)骗(piàn)。，这(zhè)个(gè)道(dào)理(lǐ)真(zhēn)叫(jiào)人(rén)想(xiǎng)明(míng)白(bái)。',
          images: <String>[],
          imageCaption: '第6章第2段',
        ),
      ],
    ),
  ],
);

// ============================================================================
// 刻舟求剑（中国寓言）
// ============================================================================

const StoryBook kStoryFableKezhou = StoryBook(
  id: 'fable_kezhou',
  title: '刻(kè)舟(zhōu)求(qiú)剑(jiàn)',
  source: StorySource.fable,
  cover: 'assets/images/stories/fable_kezhou/cover.png',
  intro: '船(chuán)在(zài)江(jiāng)上(shàng)走(zǒu)，剑(jiàn)掉(diào)进(jìn)水(shuǐ)里(li)，他(tā)在(zài)船(chuán)边(biān)刻(kè)个(gè)记(jì)号(hào)。',
  difficulty: 1,
  chapters: <StoryChapter>[
    StoryChapter(
      id: 'c1',
      title: '渡(dù)江(jiāng)丢(diū)剑(jiàn)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '有(yǒu)个(gè)人(rén)坐(zuò)船(chuán)过(guò)江(jiāng)，腰(yāo)间(jiān)挂(guà)着(zhe)一(yī)把(bǎ)祖(zǔ)传(chuán)的(de)宝(bǎo)剑(jiàn)。',
          images: <String>['assets/images/stories/fable_kezhou/c1_p1_1.png'],
          imageCaption: '第1章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '一(yī)个(gè)浪(làng)头(tou)打(dǎ)来(lái)，剑(jiàn)从(cóng)腰(yāo)间(jiān)滑(huá)落(luò)，扑(pū)通(tōng)掉(diào)进(jìn)江(jiāng)水(shuǐ)里(li)。',
          images: <String>[],
          imageCaption: '第1章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c2',
      title: '船(chuán)上(shàng)刻(kè)痕(hén)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '旁(páng)人(rén)催(cuī)他(tā)快(kuài)下(xià)水(shuǐ)去(qù)捞(lāo)，他(tā)却(què)不(bù)慌(huāng)不(bù)忙(máng)。',
          images: <String>['assets/images/stories/fable_kezhou/c2_p1_1.png'],
          imageCaption: '第2章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '他(tā)拿(ná)刀(dāo)在(zài)船(chuán)帮(bāng)上(shàng)刻(kè)了(le)一(yī)道(dào)深(shēn)痕(hén)，说(shuō)：剑(jiàn)从(cóng)这(zhè)儿(er)掉(diào)的(de)。',
          images: <String>[],
          imageCaption: '第2章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c3',
      title: '等(děng)船(chuán)靠(kào)岸(àn)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '船(chuán)慢(màn)慢(màn)顺(shùn)流(liú)走(zǒu)着(zhe)，他(tā)安(ān)坐(zuò)船(chuán)舱(cāng)里(li)等(děng)着(zhe)到(dào)岸(àn)。',
          images: <String>['assets/images/stories/fable_kezhou/c3_p1_1.png'],
          imageCaption: '第3章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '旁(páng)人(rén)问(wèn)他(tā)为(wèi)什(shén)么(me)不(bù)捞(lāo)，他(tā)指(zhǐ)着(zhe)刻(kè)痕(hén)笑(xiào)而(ér)不(bù)答(dá)。',
          images: <String>[],
          imageCaption: '第3章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c4',
      title: '下(xià)水(shuǐ)找(zhǎo)剑(jiàn)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '船(chuán)一(yī)靠(kào)岸(àn)，他(tā)才(cái)脱(tuō)了(le)鞋(xié)，顺(shùn)着(zhe)那(nà)道(dào)刻(kè)痕(hén)跳(tiào)下(xià)水(shuǐ)。',
          images: <String>['assets/images/stories/fable_kezhou/c4_p1_1.png'],
          imageCaption: '第4章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '他(tā)在(zài)那(nà)一(yī)块(kuài)水(shuǐ)里(li)摸(mō)了(le)半(bàn)天(tiān)，哪(nǎ)有(yǒu)半(bàn)点(diǎn)剑(jiàn)的(de)影(yǐng)子(zi)。',
          images: <String>[],
          imageCaption: '第4章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c5',
      title: '剑(jiàn)早(zǎo)走(zǒu)远',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '剑(jiàn)掉(diào)下(xià)去(qù)就(jiù)沉(chén)在(zài)原(yuán)处(chù)，船(chuán)却(què)载(zài)着(zhe)他(tā)走(zǒu)了(le)好(hǎo)远(yuǎn)。',
          images: <String>['assets/images/stories/fable_kezhou/c5_p1_1.png'],
          imageCaption: '第5章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '船(chuán)动(dòng)了(le)那(nà)么(me)久(jiǔ)，刻(kè)痕(hén)早(zǎo)对(duì)不(bù)上(shàng)地(dì)方(fāng)了(le)。',
          images: <String>[],
          imageCaption: '第5章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c6',
      title: '故(gù)事(shì)的(de)道(dào)理(lǐ)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '情(qíng)况(kuàng)变(biàn)了(le)，办(bàn)法(fǎ)也(yě)得(děi)跟(gēn)着(zhe)变(biàn)才(cái)灵(líng)。',
          images: <String>['assets/images/stories/fable_kezhou/c6_p1_1.png'],
          imageCaption: '第6章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '拿(ná)老(lǎo)办(bàn)法(fǎ)对(duì)付(fù)新(xīn)情(qíng)况(kuàng)，只(zhǐ)会(huì)白(bái)忙(máng)一(yī)场(chǎng)。',
          images: <String>[],
          imageCaption: '第6章第2段',
        ),
      ],
    ),
  ],
);

// ============================================================================
// 井底之蛙（中国寓言）
// ============================================================================

const StoryBook kStoryFableJingdi = StoryBook(
  id: 'fable_jingdi',
  title: '井(jǐng)底(dǐ)之(zhī)蛙(wā)',
  source: StorySource.fable,
  cover: 'assets/images/stories/fable_jingdi/cover.png',
  intro: '一(yī)只(zhī)青(qīng)蛙(wā)住(zhù)在(zài)井(jǐng)底(dǐ)，以(yǐ)为(wéi)天(tiān)就(jiù)有(yǒu)井(jǐng)口(kǒu)那(nà)么(me)大(dà)。',
  difficulty: 1,
  chapters: <StoryChapter>[
    StoryChapter(
      id: 'c1',
      title: '井(jǐng)里(lǐ)的(de)青(qīng)蛙(wā)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '一(yī)只(zhī)青(qīng)蛙(wā)住(zhù)在(zài)深(shēn)井(jǐng)底(dǐ)，抬(tái)头(tóu)只(zhǐ)看(kàn)见(jiàn)圆(yuán)圆(yuán)一(yī)小(xiǎo)块(kuài)天(tiān)。',
          images: <String>['assets/images/stories/fable_jingdi/c1_p1_1.png'],
          imageCaption: '第1章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '它(tā)每(měi)天(tiān)在(zài)井(jǐng)里(li)游(yóu)水(shuǐ)唱(chàng)歌(gē)，觉(jué)得(de)自(zì)己(jǐ)的(de)天(tiān)堂(táng)顶(dǐng)好(hǎo)。',
          images: <String>[],
          imageCaption: '第1章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c2',
      title: '海(hǎi)龟(guī)来(lái)访(fǎng)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '一(yī)只(zhī)大(dà)海(hǎi)龟(guī)爬(pá)到(dào)井(jǐng)边(biān)，探(tàn)头(tóu)往(wǎng)下(xià)看(kàn)这(zhè)小(xiǎo)住(zhù)户(hù)。',
          images: <String>['assets/images/stories/fable_jingdi/c2_p1_1.png'],
          imageCaption: '第2章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '青(qīng)蛙(wā)骄(jiāo)傲(ào)地(de)说(shuō)：快(kuài)看(kàn)我(wǒ)的(de)天(tiān)堂(táng)，多(duō)宽(kuān)多(duō)亮(liàng)多(duō)舒(shū)服(fu)。',
          images: <String>[],
          imageCaption: '第2章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c3',
      title: '大(dà)海(hǎi)的(de)模(mó)样(yàng)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '海(hǎi)龟(guī)笑(xiào)着(zhe)说(shuō)：你(nǐ)见(jiàn)过(guò)大(dà)海(hǎi)吗(ma)？那(nà)水(shuǐ)望(wàng)也(yě)望(wàng)不(bù)到(dào)边(biān)。',
          images: <String>['assets/images/stories/fable_jingdi/c3_p1_1.png'],
          imageCaption: '第3章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '大(dà)海(hǎi)九(jiǔ)年(nián)淹(yān)不(bù)没(mò)，旱(hàn)了(le)也(yě)不(bù)见(jiàn)浅(qiǎn)，那(nà)才(cái)叫(jiào)宽(kuān)广(guǎng)。',
          images: <String>[],
          imageCaption: '第3章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c4',
      title: '青(qīng)蛙(wā)愣(lèng)住(zhù)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '青(qīng)蛙(wā)听(tīng)得(de)目(mù)瞪(dèng)口(kǒu)呆(dāi)，从(cóng)没(méi)想(xiǎng)过(guò)天(tiān)还(hái)能(néng)更(gèng)大(dà)更(gèng)蓝(lán)。',
          images: <String>['assets/images/stories/fable_jingdi/c4_p1_1.png'],
          imageCaption: '第4章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '它(tā)悄(qiāo)悄(qiāo)缩(suō)了(le)脖(bó)子(zi)，头(tóu)一(yī)回(huí)有(yǒu)点(diǎn)害(hài)羞(xiū)。',
          images: <String>[],
          imageCaption: '第4章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c5',
      title: '走(zǒu)出(chū)井(jǐng)口(kǒu)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '海(hǎi)龟(guī)说(shuō)：跟(gēn)我(wǒ)出(chū)去(qù)看(kàn)看(kàn)吧(ba)，外(wài)面(miàn)的(de)世(shì)界(jiè)大(dà)着(zhe)呢(ne)。',
          images: <String>['assets/images/stories/fable_jingdi/c5_p1_1.png'],
          imageCaption: '第5章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '青(qīng)蛙(wā)第(dì)一(yī)次(cì)跳(tiào)出(chū)井(jǐng)口(kǒu)，看(kàn)见(jiàn)了(le)真(zhēn)正(zhèng)高(gāo)远(yuǎn)的(de)蓝(lán)天(tiān)。',
          images: <String>[],
          imageCaption: '第5章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c6',
      title: '故(gù)事(shì)的(de)道(dào)理(lǐ)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '只(zhǐ)看(kàn)见(jiàn)眼(yǎn)前(qián)一(yī)小(xiǎo)块(kuài)，就(jiù)以(yǐ)为(wéi)世(shì)界(jiè)只(zhǐ)这(zhè)样(yàng)大(dà)。',
          images: <String>['assets/images/stories/fable_jingdi/c6_p1_1.png'],
          imageCaption: '第6章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '多(duō)走(zǒu)出(chū)门(mén)见(jiàn)见(jiàn)世(shì)面(miàn)，才(cái)知(zhī)道(dào)自(zì)己(jǐ)有(yǒu)多(duō)浅(qiǎn)。',
          images: <String>[],
          imageCaption: '第6章第2段',
        ),
      ],
    ),
  ],
);

// ============================================================================
// 自相矛盾（中国寓言）
// ============================================================================

const StoryBook kStoryFableMaodun = StoryBook(
  id: 'fable_maodun',
  title: '自(zì)相(xiāng)矛(máo)盾(dùn)',
  source: StorySource.fable,
  cover: 'assets/images/stories/fable_maodun/cover.png',
  intro: '卖(mài)矛(máo)又(yòu)卖(mài)盾(dùn)，说(shuō)矛(máo)能(néng)穿(chuān)所(suǒ)有(yǒu)盾(dùn)，盾(dùn)能(néng)挡(dǎng)所(suǒ)有(yǒu)矛(máo)。',
  difficulty: 1,
  chapters: <StoryChapter>[
    StoryChapter(
      id: 'c1',
      title: '集(jí)市(shì)卖(mài)货(huò)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '从(cóng)前(qián)有(yǒu)个(gè)人(rén)在(zài)集(jí)市(shì)摆(bǎi)摊(tān)，左(zuǒ)边(biān)卖(mài)矛(máo)右(yòu)边(biān)卖(mài)盾(dùn)。',
          images: <String>['assets/images/stories/fable_maodun/c1_p1_1.png'],
          imageCaption: '第1章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '他(tā)嗓(sǎng)门(mén)又(yòu)大(dà)又(yòu)亮(liàng)，不(bù)一(yī)会(huì)儿(er)就(jiù)招(zhāo)来(lái)好(hǎo)些(xiē)人(rén)围(wéi)观(guān)。',
          images: <String>[],
          imageCaption: '第1章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c2',
      title: '夸(kuā)他(tā)的(de)矛(máo)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '他(tā)举(jǔ)起(qǐ)长(cháng)矛(máo)大(dà)喊(hǎn)：我(wǒ)的(de)矛(máo)尖(jiān)利(lì)极(jí)了(le)，什(shén)么(me)盾(dùn)都(dōu)刺(cì)得(de)穿(chuān)。',
          images: <String>['assets/images/stories/fable_maodun/c2_p1_1.png'],
          imageCaption: '第2章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '围(wéi)观(guān)的(de)人(rén)点(diǎn)头(tóu)称(chēng)奇(qí)，有(yǒu)人(rén)伸(shēn)手(shǒu)摸(mō)那(nà)寒(hán)光(guāng)闪(shǎn)闪(shǎn)的(de)尖(jiān)。',
          images: <String>[],
          imageCaption: '第2章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c3',
      title: '又(yòu)夸(kuā)他(tā)的(de)盾(dùn)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '他(tā)放(fàng)下(xià)矛(máo)，拍(pāi)着(zhe)盾(dùn)牌(pái)说(shuō)：我(wǒ)的(de)盾(dùn)厚(hòu)实(shí)极(jí)了(le)，什(shén)么(me)矛(máo)也(yě)刺(cì)不(bù)进(jìn)。',
          images: <String>['assets/images/stories/fable_maodun/c3_p1_1.png'],
          imageCaption: '第3章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '人(rén)们(men)听(tīng)了(le)笑(xiào)而(ér)不(bù)语(yǔ)，有(yǒu)人(rén)低(dī)声(shēng)嘀(dí)咕(gu)起(qǐ)来(lái)。',
          images: <String>[],
          imageCaption: '第3章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c4',
      title: '有(yǒu)人(rén)发(fā)问(wèn)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '一(yī)个(gè)白(bái)胡(hú)老(lǎo)头(tóu)笑(xiào)着(zhe)问(wèn)：用(yòng)你(nǐ)的(de)矛(máo)刺(cì)你(nǐ)的(de)盾(dùn)，会(huì)怎(zěn)样(yàng)。',
          images: <String>['assets/images/stories/fable_maodun/c4_p1_1.png'],
          imageCaption: '第4章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '卖(mài)货(huò)的(de)人(rén)张(zhāng)了(le)张(zhāng)嘴(zuǐ)，半(bàn)天(tiān)一(yī)句(jù)话(huà)也(yě)答(dá)不(bù)出(chū)。',
          images: <String>[],
          imageCaption: '第4章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c5',
      title: '说(shuō)不(bù)下(xià)去(qù)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '围(wéi)观(guān)的(de)人(rén)一(yī)阵(zhèn)哄(hōng)笑(xiào)，那(nà)人(rén)脸(liǎn)红(hóng)到(dào)了(le)耳(ěr)根(gēn)。',
          images: <String>['assets/images/stories/fable_maodun/c5_p1_1.png'],
          imageCaption: '第5章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '他(tā)收(shōu)起(qǐ)摊(tān)子(zi)，悄(qiāo)悄(qiāo)挤(jǐ)出(chū)人(rén)群(qún)溜(liū)了(le)。',
          images: <String>[],
          imageCaption: '第5章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c6',
      title: '故(gù)事(shì)的(de)道(dào)理(lǐ)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '说(shuō)话(huà)做(zuò)事(shì)要(yào)前(qián)后(hòu)一(yī)致(zhì)，不(bù)能(néng)自(zì)己(jǐ)打(dǎ)自(zì)己(jǐ)嘴(zuǐ)。',
          images: <String>['assets/images/stories/fable_maodun/c6_p1_1.png'],
          imageCaption: '第6章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '两(liǎng)边(biān)都(dōu)吹(chuī)上(shàng)天(tiān)，迟(chí)早(zǎo)要(yào)露(lòu)出(chū)马(mǎ)脚(jiǎo)。',
          images: <String>[],
          imageCaption: '第6章第2段',
        ),
      ],
    ),
  ],
);

// ============================================================================
// 画蛇添足（中国寓言）
// ============================================================================

const StoryBook kStoryFableHuashe = StoryBook(
  id: 'fable_huashe',
  title: '画(huà)蛇(shé)添(tiān)足(zú)',
  source: StorySource.fable,
  cover: 'assets/images/stories/fable_huashe/cover.png',
  intro: '几(jǐ)个(gè)人(rén)分(fēn)一(yī)壶(hú)酒(jiǔ)，先(xiān)画(huà)完(wán)蛇(shé)的(de)喝(hē)酒(jiǔ)，有(yǒu)人(rén)多(duō)画(huà)了(le)脚(jiǎo)。',
  difficulty: 1,
  chapters: <StoryChapter>[
    StoryChapter(
      id: 'c1',
      title: '分(fèn)一(yī)壶(hú)酒(jiǔ)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '几(jǐ)个(gè)好(hǎo)朋(péng)友(you)得(dé)了(le)一(yī)壶(hú)好(hǎo)酒(jiǔ)，人(rén)多(duō)酒(jiǔ)少(shǎo)分(fēn)不(bù)均(yún)。',
          images: <String>['assets/images/stories/fable_huashe/c1_p1_1.png'],
          imageCaption: '第1章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '他(tā)们(men)商(shāng)量(liang)：比(bǐ)赛(sài)画(huà)蛇(shé)，谁(shuí)先(xiān)画(huà)完(wán)谁(shuí)独(dú)自(zì)喝(hē)。',
          images: <String>[],
          imageCaption: '第1章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c2',
      title: '抢(qiǎng)着(zhe)画(huà)蛇(shé)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '大(dà)家(jiā)蹲(dūn)在(zài)地(dì)上(shàng)，拿(ná)树(shù)枝(zhī)飞(fēi)快(kuài)画(huà)起(qǐ)蛇(shé)来(lái)。',
          images: <String>['assets/images/stories/fable_huashe/c2_p1_1.png'],
          imageCaption: '第2章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '有(yǒu)个(gè)人(rén)手(shǒu)脚(jiǎo)麻(má)利(lì)，不(bù)一(yī)会(huì)儿(er)就(jiù)画(huà)好(hǎo)一(yī)条(tiáo)活(huó)蛇(shé)。',
          images: <String>[],
          imageCaption: '第2章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c3',
      title: '多(duō)此(cǐ)一(yī)举(jǔ)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '他(tā)拿(ná)起(qǐ)酒(jiǔ)壶(hú)正(zhèng)要(yào)喝(hē)，瞥(piē)见(jiàn)别(bié)人(rén)还(hái)在(zài)埋(mái)头(tóu)画(huà)。',
          images: <String>['assets/images/stories/fable_huashe/c3_p1_1.png'],
          imageCaption: '第3章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '他(tā)得(dé)意(yì)地(de)说(shuō)：我(wǒ)还(hái)有(yǒu)空(kòng)给(gěi)蛇(shé)添(tiān)几(jǐ)只(zhī)脚(jiǎo)呢(ne)。',
          images: <String>[],
          imageCaption: '第3章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c4',
      title: '画(huà)起(qǐ)脚(jiǎo)来(lái)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '他(tā)一(yī)边(biān)给(gěi)蛇(shé)描(miáo)脚(jiǎo)，一(yī)边(biān)偷(tōu)笑(xiào)别(bié)人(rén)手(shǒu)慢(màn)。',
          images: <String>['assets/images/stories/fable_huashe/c4_p1_1.png'],
          imageCaption: '第4章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '脚(jiǎo)还(hái)没(méi)画(huà)完(wán)，另(lìng)一(yī)人(rén)已(yǐ)画(huà)完(wán)真(zhēn)蛇(shé)放(fàng)下(xià)笔(bǐ)。',
          images: <String>[],
          imageCaption: '第4章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c5',
      title: '酒(jiǔ)被(bèi)拿(ná)走(zǒu)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '那(nà)人(rén)夺(duó)过(guò)酒(jiǔ)壶(hú)说(shuō)：蛇(shé)本(běn)来(lái)没(méi)脚(jiǎo)，你(nǐ)画(huà)的(de)不(bú)是(shì)蛇(shé)。',
          images: <String>['assets/images/stories/fable_huashe/c5_p1_1.png'],
          imageCaption: '第5章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '说(shuō)完(wán)仰(yǎng)头(tóu)把(bǎ)酒(jiǔ)喝(hē)光(guāng)，画(huà)脚(jiǎo)的(de)人(rén)只(zhǐ)能(néng)干(gān)瞪(dèng)眼(yǎn)。',
          images: <String>[],
          imageCaption: '第5章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c6',
      title: '故(gù)事(shì)的(de)道(dào)理(lǐ)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '事(shì)情(qing)做(zuò)到(dào)好(hǎo)就(jiù)够(gòu)了(le)，多(duō)加(jiā)一(yī)道(dào)反(fǎn)而(ér)弄(nòng)糟(zāo)。',
          images: <String>['assets/images/stories/fable_huashe/c6_p1_1.png'],
          imageCaption: '第6章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '逞(chěng)能(néng)显(xiǎn)摆(bǎi)，常(cháng)把(bǎ)到(dào)手(shǒu)的(de)好(hǎo)处(chù)弄(nòng)丢(diū)。，这(zhè)个(gè)道(dào)理(lǐ)真(zhēn)有(yǒu)意(yì)思(sī)呀(ya)。',
          images: <String>[],
          imageCaption: '第6章第2段',
        ),
      ],
    ),
  ],
);

// ============================================================================
// 郑人买履（中国寓言）
// ============================================================================

const StoryBook kStoryFableZhengren = StoryBook(
  id: 'fable_zhengren',
  title: '郑(zhèng)人(rén)买(mǎi)履(lǚ)',
  source: StorySource.fable,
  cover: 'assets/images/stories/fable_zhengren/cover.png',
  intro: '郑(zhèng)国(guó)有(yǒu)个(gè)人(rén)买(mǎi)鞋(xié)，宁(níng)肯(kěn)信(xìn)量(liáng)好(hǎo)的(de)尺(chǐ)码(mǎ)，也(yě)不(bù)信(xìn)自(zì)己(jǐ)的(de)脚(jiǎo)。',
  difficulty: 1,
  chapters: <StoryChapter>[
    StoryChapter(
      id: 'c1',
      title: '量(liàng)好(hǎo)尺(chǐ)码(mǎ)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '郑(zhèng)国(guó)有(yǒu)个(gè)人(rén)想(xiǎng)买(mǎi)双(shuāng)鞋(xié)，先(xiān)在(zài)家(jiā)量(liáng)好(hǎo)脚(jiǎo)的(de)尺(chǐ)码(mǎ)。',
          images: <String>['assets/images/stories/fable_zhengren/c1_p1_1.png'],
          imageCaption: '第1章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '他(tā)把(bǎ)尺(chǐ)码(mǎ)写(xiě)在(zài)竹(zhú)片(piàn)上(shàng)，小(xiǎo)心(xīn)收(shōu)进(jìn)袖(xiù)口(kǒu)里(li)。',
          images: <String>[],
          imageCaption: '第1章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c2',
      title: '到(dào)了(le)集(jí)市(shì)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '他(tā)走(zǒu)到(dào)集(jí)市(shì)，挑(tiāo)中(zhòng)一(yī)双(shuāng)合(hé)脚(jiǎo)又(yòu)好(hǎo)看(kàn)的(de)鞋(xié)。',
          images: <String>['assets/images/stories/fable_zhengren/c2_p1_1.png'],
          imageCaption: '第2章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '一(yī)摸(mō)袖(xiù)口(kǒu)糟(zāo)了(le)，量(liáng)好(hǎo)的(de)竹(zhú)片(piàn)忘(wàng)在(zài)家(jiā)桌(zhuō)上(shàng)。',
          images: <String>[],
          imageCaption: '第2章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c3',
      title: '回(huí)家(jia)去(qù)取(qǔ)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '他(tā)放(fàng)下(xià)鞋(xié)说(shuō)：我(wǒ)得(děi)回(huí)家(jiā)拿(ná)尺(chǐ)码(mǎ)再(zài)来(lái)买(mǎi)。',
          images: <String>['assets/images/stories/fable_zhengren/c3_p1_1.png'],
          imageCaption: '第3章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '说(shuō)完(wán)转(zhuǎn)身(shēn)就(jiù)跑(pǎo)，集(jí)市(shì)离(lí)家(jiā)可(kě)不(bù)算(suàn)近(jìn)。',
          images: <String>[],
          imageCaption: '第3章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c4',
      title: '集(jí)市(shì)散(sàn)了(le)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '等(děng)他(tā)拿(ná)着(zhe)竹(zhú)片(piàn)赶(gǎn)回(huí)集(jí)市(shì)，摊(tān)位(wèi)早(zǎo)收(shōu)得(de)干(gān)净(jìng)。',
          images: <String>['assets/images/stories/fable_zhengren/c4_p1_1.png'],
          imageCaption: '第4章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '他(tā)一(yī)双(shuāng)鞋(xié)也(yě)没(méi)买(mǎi)成(chéng)，只(zhǐ)好(hǎo)光(guāng)脚(jiǎo)走(zǒu)回(huí)家(jiā)。',
          images: <String>[],
          imageCaption: '第4章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c5',
      title: '别(bié)人(rén)奇(qí)怪(guài)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '路(lù)人(rén)见(jiàn)了(le)问(wèn)：你(nǐ)脚(jiǎo)不(bù)在(zài)这(zhè)儿(er)吗(ma)？用(yòng)脚(jiǎo)试(shì)试(shì)不(bù)就(jiù)行(xíng)。',
          images: <String>['assets/images/stories/fable_zhengren/c5_p1_1.png'],
          imageCaption: '第5章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '他(tā)摇(yáo)头(tóu)说(shuō)：我(wǒ)宁(níng)肯(kěn)信(xìn)尺(chǐ)码(mǎ)，也(yě)不(bù)信(xìn)自(zì)己(jǐ)的(de)脚(jiǎo)。',
          images: <String>[],
          imageCaption: '第5章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c6',
      title: '故(gù)事(shì)的(de)道(dào)理(lǐ)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '规(guī)矩(jǔ)和(hé)方(fāng)法(fǎ)是(shì)帮(bāng)人(rén)的(de)，不(bù)能(néng)盖(gài)过(guò)实(shí)际(jì)。',
          images: <String>['assets/images/stories/fable_zhengren/c6_p1_1.png'],
          imageCaption: '第6章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '太(tài)死(sǐ)板(bǎn)地(de)认(rèn)条(tiáo)条(tiáo)，反(fǎn)把(bǎ)正(zhèng)经(jīng)事(shì)误(wù)了(le)。，这(zhè)样(yàng)做(zuò)才(cái)算(suàn)真(zhēn)明(míng)白(bái)了(le)。',
          images: <String>[],
          imageCaption: '第6章第2段',
        ),
      ],
    ),
  ],
);

// ============================================================================
// 叶公好龙（中国寓言）
// ============================================================================

const StoryBook kStoryFableYegong = StoryBook(
  id: 'fable_yegong',
  title: '叶(yè)公(gōng)好(hào)龙(lóng)',
  source: StorySource.fable,
  cover: 'assets/images/stories/fable_yegong/cover.png',
  intro: '叶(yè)公(gōng)嘴(zuǐ)上(shàng)说(shuō)喜(xǐ)欢(huan)龙(lóng)，真(zhēn)龙(lóng)来(lái)了(le)却(què)吓(xià)得(de)逃(táo)跑(pǎo)。',
  difficulty: 1,
  chapters: <StoryChapter>[
    StoryChapter(
      id: 'c1',
      title: '叶(yè)公(gōng)爱(ài)龙(lóng)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '古(gǔ)时(shí)候(hòu)有(yǒu)位(wèi)叶(yè)公(gōng)，一(yī)提(tí)起(qǐ)龙(lóng)就(jiù)喜(xǐ)欢(huan)得(de)不(bù)得(de)。',
          images: <String>['assets/images/stories/fable_yegong/c1_p1_1.png'],
          imageCaption: '第1章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '他(tā)家(jiā)的(de)墙(qiáng)上(shàng)、柱(zhù)子(zi)、碗(wǎn)碟(dié)上(shàng)，到(dào)处(chù)画(huà)满(mǎn)了(le)龙(lóng)。',
          images: <String>[],
          imageCaption: '第1章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c2',
      title: '满(mǎn)屋(wū)是(shì)龙(lóng)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '客(kè)人(rén)进(jìn)门(mén)抬(tái)头(tóu)是(shì)龙(lóng)，低(dī)头(tóu)也(yě)是(shì)龙(lóng)，像(xiàng)进(jìn)了(le)龙(lóng)宫(gōng)。',
          images: <String>['assets/images/stories/fable_yegong/c2_p1_1.png'],
          imageCaption: '第2章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '叶(yè)公(gōng)常(cháng)对(duì)人(rén)说(shuō)：我(wǒ)这(zhè)一(yī)辈(bèi)子(zi)最(zuì)爱(ài)的(de)就(jiù)是(shì)龙(lóng)。',
          images: <String>[],
          imageCaption: '第2章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c3',
      title: '真(zhēn)龙(lóng)来(lái)了(le)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '天(tiān)上(shàng)真(zhēn)龙(lóng)听(tīng)说(shuō)了(le)，高(gāo)兴(xìng)地(de)飞(fēi)来(lái)看(kàn)这(zhè)位(wèi)爱(ài)龙(lóng)人(rén)。',
          images: <String>['assets/images/stories/fable_yegong/c3_p1_1.png'],
          imageCaption: '第3章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '龙(lóng)把(bǎ)头(tóu)从(cóng)窗(chuāng)外(wài)探(tàn)进(jìn)来(lái)，长(cháng)尾(wěi)巴(ba)拖(tuō)在(zài)厅(tīng)堂(táng)上(shàng)。',
          images: <String>[],
          imageCaption: '第3章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c4',
      title: '吓(xià)得(de)逃(táo)跑(pǎo)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '叶(yè)公(gōng)抬(tái)头(tóu)一(yī)看(kàn)真(zhēn)龙(lóng)，脸(liǎn)色(sè)刷(shuā)地(de)惨(cǎn)白(bái)。',
          images: <String>['assets/images/stories/fable_yegong/c4_p1_1.png'],
          imageCaption: '第4章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '他(tā)扔(rēng)了(le)杯(bēi)子(zi)连(lián)滚(gǔn)带(dài)爬(pá)，没(méi)命(mìng)逃(táo)出(chū)屋(wū)去(qù)。',
          images: <String>[],
          imageCaption: '第4章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c5',
      title: '露(lù)了(le)原(yuán)形(xíng)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '真(zhēn)龙(lóng)看(kàn)着(zhe)他(tā)的(de)背(bèi)影(yǐng)摇(yáo)头(tóu)，慢(màn)慢(màn)飞(fēi)回(huí)天(tiān)上(shàng)。',
          images: <String>['assets/images/stories/fable_yegong/c5_p1_1.png'],
          imageCaption: '第5章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '原(yuán)来(lái)他(tā)爱(ài)的(de)只(zhǐ)是(shì)画(huà)上(shàng)假(jiǎ)龙(lóng)，不(bú)是(shì)真(zhēn)龙(lóng)。',
          images: <String>[],
          imageCaption: '第5章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c6',
      title: '故(gù)事(shì)的(de)道(dào)理(lǐ)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '嘴(zuǐ)上(shàng)说(shuō)得(de)好(hǎo)听(tīng)，遇(yù)到(dào)实(shí)事(shì)才(cái)露(lòu)真(zhēn)心(xīn)。',
          images: <String>['assets/images/stories/fable_yegong/c6_p1_1.png'],
          imageCaption: '第6章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '真(zhēn)正(zhèng)喜(xǐ)欢(huan)一(yī)样(yàng)东(dōng)西(xi)，得(děi)经(jīng)得(de)起(qǐ)真(zhēn)的(de)来(lái)。，这(zhè)样(yàng)才(cái)算(suàn)真(zhēn)正(zhèng)明(míng)白(bái)了(le)道(dào)理(lǐ)，心(xīn)里(li)更(gèng)亮(liàng)。',
          images: <String>[],
          imageCaption: '第6章第2段',
        ),
      ],
    ),
  ],
);

// ============================================================================
// 滥竽充数（中国寓言）
// ============================================================================

const StoryBook kStoryFableLanyu = StoryBook(
  id: 'fable_lanyu',
  title: '滥(làn)竽(yú)充(chōng)数(shù)',
  source: StorySource.fable,
  cover: 'assets/images/stories/fable_lanyu/cover.png',
  intro: '不(bù)会(huì)吹(chuī)竽(yú)的(de)人(rén)，混(hùn)在(zài)乐(yuè)队(duì)里(li)装(zhuāng)样(yàng)子(zi)凑(còu)数(shù)。',
  difficulty: 1,
  chapters: <StoryChapter>[
    StoryChapter(
      id: 'c1',
      title: '齐(qí)王(wáng)爱(ài)听(tīng)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '古(gǔ)时(shí)候(hòu)齐(qí)国(guó)的(de)王(wáng)喜(xǐ)听(tīng)竽(yú)，要(yào)三(sān)百(bǎi)人(rén)一(yī)起(qǐ)吹(chuī)。',
          images: <String>['assets/images/stories/fable_lanyu/c1_p1_1.png'],
          imageCaption: '第1章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '每(měi)回(huí)演(yǎn)奏(zòu)，大(dà)厅(tīng)里(li)整(zhěng)齐(qí)排(pái)满(mǎn)乐(yuè)手(shǒu)，声(shēng)音(yīn)震(zhèn)天(tiān)。',
          images: <String>[],
          imageCaption: '第1章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c2',
      title: '南(nán)郭(guō)混(hùn)入(rù)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '有(yǒu)个(gè)叫(jiào)南(nán)郭(guō)的(de)人(rén)，根(gēn)本(běn)不(bú)会(huì)吹(chuī)竽(yú)却(què)想(xiǎng)领(lǐng)俸(fèng)禄(lù)。',
          images: <String>['assets/images/stories/fable_lanyu/c2_p1_1.png'],
          imageCaption: '第2章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '他(tā)也(yě)报(bào)了(le)名(míng)，混(hùn)进(jìn)队(duì)伍(wu)，站(zhàn)在(zài)队(duì)里(li)装(zhuāng)模(mú)作(zuò)样(yàng)。',
          images: <String>[],
          imageCaption: '第2章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c3',
      title: '装(zhuāng)模(mó)作(zuò)样(yàng)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '演(yǎn)奏(zòu)时(shí)他(tā)鼓(gǔ)起(qǐ)腮(sāi)帮(bāng)，捧(pěng)着(zhe)竽(yú)一(yī)晃(huàng)一(yī)晃(huàng)。',
          images: <String>['assets/images/stories/fable_lanyu/c3_p1_1.png'],
          imageCaption: '第3章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '别(bié)人(rén)真(zhēn)吹(chuī)他(tā)假(jiǎ)吹(chuī)，站(zhàn)在(zài)远(yuǎn)处(chù)谁(shuí)也(yě)看(kàn)不(bù)出(chū)。',
          images: <String>[],
          imageCaption: '第3章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c4',
      title: '混(hùn)了(le)多(duō)年(nián)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '就(jiù)这(zhè)样(yàng)混(hùn)了(le)好(hǎo)些(xiē)年(nián)，他(tā)吃(chī)喝(hē)不(bù)愁(chóu)还(hái)挺(tǐng)得(dé)意(yì)。',
          images: <String>['assets/images/stories/fable_lanyu/c4_p1_1.png'],
          imageCaption: '第4章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '邻(lín)居(jū)夸(kuā)他(tā)是(shì)好(hǎo)乐(yuè)师(shī)，他(tā)也(yě)就(jiù)顺(shùn)着(zhe)应(yìng)承(chéng)下(xià)来(lái)。',
          images: <String>[],
          imageCaption: '第4章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c5',
      title: '新(xīn)王(wáng)要(yào)独(dú)奏(zòu)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '老(lǎo)王(wáng)去(qù)世(shì)，小(xiǎo)王(wáng)继(jì)位(wèi)，偏(piān)偏(piān)喜(xǐ)欢(huan)一(yī)个(gè)个(gè)独(dú)奏(zòu)。',
          images: <String>['assets/images/stories/fable_lanyu/c5_p1_1.png'],
          imageCaption: '第5章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '他(tā)下(xià)令(lìng)：每(měi)个(gè)人(rén)轮(lún)流(liú)单(dān)独(dú)吹(chuī)给(gěi)本(běn)王(wáng)听(tīng)。',
          images: <String>[],
          imageCaption: '第5章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c6',
      title: '只(zhī)好(hǎo)逃(táo)走(zǒu)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '南(nán)郭(guō)听(tīng)了(le)吓(xià)出(chū)一(yī)身(shēn)冷(lěng)汗(hàn)，连(lián)夜(yè)卷(juǎn)铺(pū)盖(gài)溜(liū)走(zǒu)。',
          images: <String>['assets/images/stories/fable_lanyu/c6_p1_1.png'],
          imageCaption: '第6章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '没(méi)真(zhēn)本(běn)事(shì)，靠(kào)混(hùn)是(shì)混(hùn)不(bù)长(cháng)久(jiǔ)的(de)。，这(zhè)个(gè)故(gù)事(shì)说(shuō)得(de)真(zhēn)有(yǒu)道(dào)理(lǐ)。',
          images: <String>[],
          imageCaption: '第6章第2段',
        ),
      ],
    ),
  ],
);

// ============================================================================
// 买椟还珠（中国寓言）
// ============================================================================

const StoryBook kStoryFableMaidu = StoryBook(
  id: 'fable_maidu',
  title: '买(mǎi)椟(dú)还(huán)珠(zhū)',
  source: StorySource.fable,
  cover: 'assets/images/stories/fable_maidu/cover.png',
  intro: '有(yǒu)人(rén)买(mǎi)下(xià)珍(zhēn)珠(zhū)的(de)盒(hé)子(zi)，却(què)把(bǎ)里(lǐ)面(miàn)珠(zhū)子(zi)还(huán)给(gěi)卖(mài)家(jiā)。',
  difficulty: 1,
  chapters: <StoryChapter>[
    StoryChapter(
      id: 'c1',
      title: '楚(chǔ)国(guó)有(yǒu)珠(zhū)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '楚(chǔ)国(guó)有(yǒu)个(gè)珠(zhū)宝(bǎo)商(shāng)，得(dé)到(dào)一(yī)颗(kē)又(yòu)大(dà)又(yòu)亮(liàng)的(de)明(míng)珠(zhū)。',
          images: <String>['assets/images/stories/fable_maidu/c1_p1_1.png'],
          imageCaption: '第1章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '他(tā)想(xiǎng)卖(mài)个(gè)好(hǎo)价(jià)钱(qián)，先(xiān)给(gěi)珠(zhū)子(zi)配(pèi)个(gè)体(tǐ)面(miàn)盒(hé)子(zi)。',
          images: <String>[],
          imageCaption: '第1章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c2',
      title: '精(jīng)装(zhuāng)盒(hé)子(zi)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '他(tā)用(yòng)香(xiāng)木(mù)做(zuò)盒(hé)，雕(diāo)上(shàng)花(huā)纹(wén)还(hái)镶(xiāng)了(le)宝(bǎo)石(shí)。',
          images: <String>['assets/images/stories/fable_maidu/c2_p1_1.png'],
          imageCaption: '第2章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '盒(hé)子(zi)一(yī)打(dǎ)开(kāi)就(jiù)散(sàn)出(chū)香(xiāng)气(qì)，看(kàn)着(zhe)比(bǐ)珠(zhū)还(hái)招(zhāo)人(rén)。',
          images: <String>[],
          imageCaption: '第2章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c3',
      title: '郑(zhèng)人(rén)来(lái)了(le)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '一(yī)个(gè)郑(zhèng)国(guó)人(rén)路(lù)过(guò)，看(kàn)见(jiàn)盒(hé)子(zi)爱(ài)不(bù)释(shì)手(shǒu)。',
          images: <String>['assets/images/stories/fable_maidu/c3_p1_1.png'],
          imageCaption: '第3章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '他(tā)掏(tāo)出(chū)钱(qián)买(mǎi)下(xià)整(zhěng)个(gè)盒(hé)，连(lián)珠(zhū)带(dài)盒(hé)一(yī)并(bìng)拿(ná)走(zǒu)。',
          images: <String>[],
          imageCaption: '第3章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c4',
      title: '只(zhī)要(yào)盒(hé)子(zi)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '走(zǒu)了(le)几(jǐ)步(bù)，他(tā)打(dǎ)开(kāi)盒(hé)看(kàn)珠(zhū)，想(xiǎng)了(le)想(xiǎng)又(yòu)转(zhuǎn)身(shēn)回(huí)来(lái)。',
          images: <String>['assets/images/stories/fable_maidu/c4_p1_1.png'],
          imageCaption: '第4章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '他(tā)取(qǔ)出(chū)明(míng)珠(zhū)还(huán)给(gěi)商(shāng)人(rén)，说(shuō)：我(wǒ)只(zhǐ)要(yào)这(zhè)个(gè)盒(hé)子(zi)。',
          images: <String>[],
          imageCaption: '第4章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c5',
      title: '商(shāng)人(rén)愣(lèng)住(zhù)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '商(shāng)人(rén)接(jiē)过(guò)珠(zhū)子(zi)，一(yī)时(shí)不(bù)知(zhī)该(gāi)笑(xiào)还(hái)是(shì)愣(lèng)。',
          images: <String>['assets/images/stories/fable_maidu/c5_p1_1.png'],
          imageCaption: '第5章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '他(tā)摇(yáo)摇(yáo)头(tóu)收(shōu)起(qǐ)珠(zhū)，看(kàn)着(zhe)那(nà)人(rén)捧(pěng)盒(hé)走(zǒu)远(yuǎn)。',
          images: <String>[],
          imageCaption: '第5章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c6',
      title: '故(gù)事(shì)的(de)道(dào)理(lǐ)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '舍(shě)了(le)本(běn)追(zhuī)末(mò)，为(wèi)好(hǎo)看(kàn)的(de)外(wài)壳(ké)丢(diū)了(le)真(zhēn)东(dōng)西(xi)。',
          images: <String>['assets/images/stories/fable_maidu/c6_p1_1.png'],
          imageCaption: '第6章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '挑(tiāo)东(dōng)西(xi)得(děi)看(kàn)里(lǐ)子(zi)，不(bù)能(néng)光(guāng)看(kàn)包(bāo)装(zhuāng)。，这(zhè)样(yàng)才(cái)算(suàn)真(zhēn)明(míng)白(bái)了(le)道(dào)理(lǐ)。',
          images: <String>[],
          imageCaption: '第6章第2段',
        ),
      ],
    ),
  ],
);

// ============================================================================
// 塞翁失马（中国寓言）
// ============================================================================

const StoryBook kStoryFableSaiweng = StoryBook(
  id: 'fable_saiweng',
  title: '塞(sài)翁(wēng)失(shī)马(mǎ)',
  source: StorySource.fable,
  cover: 'assets/images/stories/fable_saiweng/cover.png',
  intro: '边(biān)塞(sài)老(lǎo)人(rén)丢(diū)了(le)马(mǎ)不(bù)急(jí)，说(shuō)焉(yān)知(zhī)非(fēi)福(fú)。',
  difficulty: 1,
  chapters: <StoryChapter>[
    StoryChapter(
      id: 'c1',
      title: '老(lǎo)翁(wēng)丢(diū)马(mǎ)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '边(biān)塞(sài)上(shàng)住(zhù)着(zhe)一(yī)位(wèi)老(lǎo)翁(wēng)，家(jiā)里(li)养(yǎng)着(zhe)几(jǐ)匹(pǐ)好(hǎo)马(mǎ)。',
          images: <String>['assets/images/stories/fable_saiweng/c1_p1_1.png'],
          imageCaption: '第1章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '一(yī)天(tiān)一(yī)匹(pǐ)马(mǎ)跑(pǎo)丢(diū)了(le)，邻(lín)居(jū)都(dōu)来(lái)安(ān)慰(wèi)他(tā)别(bié)难(nán)过(guò)。',
          images: <String>[],
          imageCaption: '第1章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c2',
      title: '他(tā)说(shuō)没(méi)事(shì)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '老(lǎo)翁(wēng)笑(xiào)着(zhe)说(shuō)：丢(diū)马(mǎ)是(shì)坏(huài)事(shì)，可(kě)谁(shuí)知(zhī)道(dào)不(bù)是(shì)好(hǎo)事(shì)。',
          images: <String>['assets/images/stories/fable_saiweng/c2_p1_1.png'],
          imageCaption: '第2章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '邻(lín)居(jū)听(tīng)了(le)直(zhí)摇(yáo)头(tóu)，都(dōu)觉(jué)得(de)他(tā)在(zài)宽(kuān)慰(wèi)自(zì)己(jǐ)。',
          images: <String>[],
          imageCaption: '第2章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c3',
      title: '马(mǎ)带(dài)驹(jū)回(huí)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '过(guò)了(le)些(xiē)日(rì)子(zi)，那(nà)匹(pǐ)马(mǎ)自(zì)己(jǐ)跑(pǎo)回(huí)来(lái)，还(hái)带(dài)回(huí)一(yī)匹(pǐ)好(hǎo)马(mǎ)。',
          images: <String>['assets/images/stories/fable_saiweng/c3_p1_1.png'],
          imageCaption: '第3章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '邻(lín)居(jū)又(yòu)来(lái)道(dào)喜(xǐ)，老(lǎo)翁(wēng)却(què)说(shuō)：这(zhè)也(yě)许(xǔ)是(shì)祸(huò)呢(ne)。',
          images: <String>[],
          imageCaption: '第3章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c4',
      title: '儿(ér)子(zi)摔(shuāi)伤(shāng)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '老(lǎo)翁(wēng)的(de)儿(ér)子(zi)骑(qí)新(xīn)马(mǎ)出(chū)门(mén)，马(mǎ)受(shòu)惊(jīng)把(bǎ)他(tā)摔(shuāi)断(duàn)了(le)腿(tuǐ)。',
          images: <String>['assets/images/stories/fable_saiweng/c4_p1_1.png'],
          imageCaption: '第4章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '邻(lín)居(jū)叹(tàn)气(qì)说(shuō)真(zhēn)是(shì)祸(huò)事(shì)，老(lǎo)翁(wēng)仍(réng)说(shuō)不(bù)一(yī)定(dìng)。',
          images: <String>[],
          imageCaption: '第4章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c5',
      title: '免(miǎn)去(qù)从(cóng)军(jūn)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '正(zhèng)赶(gǎn)上(shàng)打(dǎ)仗(zhàng)，年(nián)轻(qīng)人(rén)全(quán)被(bèi)抓(zhuā)去(qù)当(dāng)兵(bīng)。',
          images: <String>['assets/images/stories/fable_saiweng/c5_p1_1.png'],
          imageCaption: '第5章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '他(tā)儿(ér)子(zi)因(yīn)腿(tuǐ)伤(shāng)留(liú)在(zài)家(jiā)，躲(duǒ)过(guò)了(le)战(zhàn)场(chǎng)死(sǐ)伤(shāng)。',
          images: <String>[],
          imageCaption: '第5章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c6',
      title: '故(gù)事(shì)的(de)道(dào)理(lǐ)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '好(hǎo)事(shì)坏(huài)事(shì)常(cháng)互(hù)相(xiāng)转(zhuǎn)换(huàn)，不(bù)要(yào)急(jí)着(zhe)下(xià)结(jié)论(lùn)。',
          images: <String>['assets/images/stories/fable_saiweng/c6_p1_1.png'],
          imageCaption: '第6章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '遇(yù)事(shì)沉(chén)住(zhù)气(qì)，福(fú)祸(huò)都(dōu)是(shì)一(yī)时(shí)的(de)。，这(zhè)个(gè)道(dào)理(lǐ)真(zhēn)叫(jiào)人(rén)想(xiǎng)明(míng)白(bái)了(le)。',
          images: <String>[],
          imageCaption: '第6章第2段',
        ),
      ],
    ),
  ],
);

// ============================================================================
// 杯弓蛇影（中国寓言）
// ============================================================================

const StoryBook kStoryFableBeigong = StoryBook(
  id: 'fable_beigong',
  title: '杯(bēi)弓(gōng)蛇(shé)影(yǐng)',
  source: StorySource.fable,
  cover: 'assets/images/stories/fable_beigong/cover.png',
  intro: '客(kè)人(rén)把(bǎ)映(yìng)在(zài)酒(jiǔ)杯(bēi)里(li)的(de)弓(gōng)影(yǐng)当(dāng)成(chéng)了(le)蛇(shé)，吓(xià)出(chū)病(bìng)来(lái)。',
  difficulty: 1,
  chapters: <StoryChapter>[
    StoryChapter(
      id: 'c1',
      title: '请(qǐng)客(kè)喝(hē)酒(jiǔ)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '有(yǒu)个(gè)官(guān)员(yuán)请(qǐng)朋(péng)友(you)来(lái)家(jiā)喝(hē)酒(jiǔ)，厅(tīng)堂(táng)墙(qiáng)上(shàng)挂(guà)着(zhe)弓(gōng)。',
          images: <String>['assets/images/stories/fable_beigong/c1_p1_1.png'],
          imageCaption: '第1章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '酒(jiǔ)杯(bēi)摆(bǎi)上(shàng)桌(zhuō)，墙(qiáng)上(shàng)弓(gōng)的(de)影(yǐng)子(zi)正(zhèng)好(hǎo)映(yìng)进(jìn)杯(bēi)里(li)。',
          images: <String>[],
          imageCaption: '第1章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c2',
      title: '疑(yí)心(xīn)是(shì)蛇(shé)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '客(kè)人(rén)端(duān)杯(bēi)一(yī)看(kàn)，见(jiàn)里(lǐ)面(miàn)像(xiàng)有(yǒu)条(tiáo)小(xiǎo)蛇(shé)在(zài)动(dòng)。',
          images: <String>['assets/images/stories/fable_beigong/c2_p1_1.png'],
          imageCaption: '第2章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '他(tā)心(xīn)里(li)发(fā)毛(máo)，又(yòu)不(bù)好(hǎo)推(tuī)酒(jiǔ)，硬(yìng)着(zhe)头(tóu)皮(pí)喝(hē)下(xià)去(qù)。',
          images: <String>[],
          imageCaption: '第2章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c3',
      title: '回(huí)家(jia)生(shēng)病(bìng)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '回(huí)家(jiā)后(hòu)他(tā)总(zǒng)想(xiǎng)起(qǐ)那(nà)条(tiáo)蛇(shé)，越(yuè)想(xiǎng)越(yuè)怕(pà)吃(chī)不(bù)下(xià)饭(fàn)。',
          images: <String>['assets/images/stories/fable_beigong/c3_p1_1.png'],
          imageCaption: '第3章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '几(jǐ)天(tiān)后(hòu)他(tā)肚(dù)子(zi)抽(chōu)痛(tòng)，躺(tǎng)在(zài)床(chuáng)上(shàng)起(qǐ)不(bù)来(lái)。',
          images: <String>[],
          imageCaption: '第3章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c4',
      title: '主(zhǔ)人(rén)查(chá)明(míng)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '主(zhǔ)人(rén)听(tīng)说(shuō)朋(péng)友(you)病(bìng)了(le)，上(shàng)门(mén)探(tàn)望(wàng)问(wèn)清(qīng)原(yuán)由(yóu)。',
          images: <String>['assets/images/stories/fable_beigong/c4_p1_1.png'],
          imageCaption: '第4章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '他(tā)回(huí)到(dào)厅(tīng)里(li)一(yī)看(kàn)，才(cái)知(zhī)是(shì)墙(qiáng)上(shàng)弓(gōng)的(de)影(yǐng)子(zi)。',
          images: <String>[],
          imageCaption: '第4章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c5',
      title: '解(jiě)惑(huò)病(bìng)愈(yù)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '主(zhǔ)人(rén)把(bǎ)朋(péng)友(you)请(qǐng)回(huí)，当(dāng)面(miàn)指(zhǐ)给(gěi)他(tā)看(kàn)杯(bēi)中(zhōng)弓(gōng)影(yǐng)。',
          images: <String>['assets/images/stories/fable_beigong/c5_p1_1.png'],
          imageCaption: '第5章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '客(kè)人(rén)一(yī)看(kàn)明(míng)白(bái)，心(xīn)里(li)石(shí)头(tou)落(luò)了(le)地(dì)，病(bìng)也(yě)好(hǎo)了(le)。',
          images: <String>[],
          imageCaption: '第5章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c6',
      title: '故(gù)事(shì)的(de)道(dào)理(lǐ)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '多(duō)半(bàn)的(de)怕(pà)是(shì)自(zì)己(jǐ)想(xiǎng)出(chū)来(lái)的(de)，先(xiān)看(kàn)清(qīng)再(zài)下(xià)结(jié)论。',
          images: <String>['assets/images/stories/fable_beigong/c6_p1_1.png'],
          imageCaption: '第6章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '疑(yí)神(shén)疑(yí)鬼(guǐ)，常(cháng)常(cháng)把(bǎ)自(zì)己(jǐ)吓(xià)出(chū)一(yī)身(shēn)病(bìng)。，这(zhè)样(yàng)才(cái)真(zhēn)放(fàng)下(xià)心(xīn)了(le)呢(ne)。',
          images: <String>[],
          imageCaption: '第6章第2段',
        ),
      ],
    ),
  ],
);

// ============================================================================
// 五十步笑百步（中国寓言）
// ============================================================================

const StoryBook kStoryFableWushibu = StoryBook(
  id: 'fable_wushibu',
  title: '五(wǔ)十(shí)步(bù)笑(xiào)百(bǎi)步(bù)',
  source: StorySource.fable,
  cover: 'assets/images/stories/fable_wushibu/cover.png',
  intro: '打(dǎ)仗(zhàng)时(shí)跑(pǎo)五(wǔ)十(shí)步(bù)的(de)笑(xiào)跑(pǎo)一(yī)百(bǎi)步(bù)的(de)，其(qí)实(shí)都(dōu)是(shì)逃(táo)兵(bīng)。',
  difficulty: 1,
  chapters: <StoryChapter>[
    StoryChapter(
      id: 'c1',
      title: '两(liǎng)国(guó)交(jiāo)战(zhàn)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '两(liǎng)军(jūn)在(zài)战(zhàn)场(chǎng)碰(pèng)面(miàn)，刚(gāng)一(yī)交(jiāo)锋(fēng)阵(zhèn)脚(jiǎo)就(jiù)乱(luàn)。',
          images: <String>['assets/images/stories/fable_wushibu/c1_p1_1.png'],
          imageCaption: '第1章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '有(yǒu)的(de)士(shì)兵(bīng)吓(xià)得(de)转(zhuǎn)身(shēn)就(jiù)跑(pǎo)，谁(shuí)也(yě)顾(gù)不(bù)上(shàng)同(tóng)伴(bàn)。',
          images: <String>[],
          imageCaption: '第1章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c2',
      title: '逃(táo)跑(pǎo)的(de)兵(bīng)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '有(yǒu)个(gè)兵(bīng)跑(pǎo)了(le)五(wǔ)十(shí)步(bù)就(jiù)停(tíng)下(xià)来(lái)喘(chuǎn)气(qì)。',
          images: <String>['assets/images/stories/fable_wushibu/c2_p1_1.png'],
          imageCaption: '第2章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '另(lìng)一(yī)个(gè)兵(bīng)跑(pǎo)了(le)一(yī)百(bǎi)步(bù)才(cái)敢(gǎn)站(zhàn)住(zhù)，两(liǎng)人(rén)都(dōu)吓(xià)坏(huài)。',
          images: <String>[],
          imageCaption: '第2章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c3',
      title: '互(hù)相取(qǔ)笑(xiào)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '跑(pǎo)五(wǔ)十(shí)步(bù)的(de)指(zhǐ)着(zhe)对(duì)方(fāng)笑(xiào)：你(nǐ)看(kàn)你(nǐ)跑(pǎo)那(nà)么(me)远(yuǎn)。',
          images: <String>['assets/images/stories/fable_wushibu/c3_p1_1.png'],
          imageCaption: '第3章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '跑(pǎo)百(bǎi)步(bù)的(de)也(yě)不(bù)服(fú)气(qì)，两(liǎng)人(rén)你(nǐ)笑(xiào)我(wǒ)我(wǒ)笑(xiào)你(nǐ)。',
          images: <String>[],
          imageCaption: '第3章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c4',
      title: '梁(liáng)王(wáng)听(tīng)后(hòu)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '这(zhè)事(shì)传(chuán)到(dào)梁(liáng)王(wáng)耳(ěr)里(li)，他(tā)问(wèn)身(shēn)边(biān)的(de)臣(chén)子(zi)。',
          images: <String>['assets/images/stories/fable_wushibu/c4_p1_1.png'],
          imageCaption: '第4章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '臣(chén)子(zi)笑(xiào)着(zhe)答(dá)：跑(pǎo)五(wǔ)十(shí)步(bù)和(hé)百(bǎi)步(bù)，不(bù)都(dōu)是(shì)逃(táo)吗(ma)。',
          images: <String>[],
          imageCaption: '第4章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c5',
      title: '点(diǎn)醒(xǐng)众(zhòng)人(rén)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '梁(liáng)王(wáng)明(míng)白(bái)了(le)：逃(táo)得(de)近(jìn)一(yī)点(diǎn)也(yě)不(bú)是(shì)英(yīng)雄(xióng)。',
          images: <String>['assets/images/stories/fable_wushibu/c5_p1_1.png'],
          imageCaption: '第5章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '他(tā)借(jiè)这(zhè)个(gè)故(gù)事(shì)劝(quàn)大(dà)家(jiā)别(bié)笑(xiào)别(bié)人(rén)犯(fàn)的(de)错(cuò)。',
          images: <String>[],
          imageCaption: '第5章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c6',
      title: '故(gù)事(shì)的(de)道(dào)理(lǐ)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '自(zì)己(jǐ)也(yě)有(yǒu)毛(máo)病(bìng)，就(jiù)别(bié)急(jí)着(zhe)笑(xiào)别(bié)人(rén)。',
          images: <String>['assets/images/stories/fable_wushibu/c6_p1_1.png'],
          imageCaption: '第6章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '五(wǔ)十(shí)步(bù)和(hé)百(bǎi)步(bù)差(chà)不(bù)多(duō)，都(dōu)该(gāi)改(gǎi)才(cái)对(duì)。，这(zhè)个(gè)道(dào)理(lǐ)说(shuō)得(de)真(zhēn)有(yǒu)道(dào)理(lǐ)，人(rén)人(rén)都(dōu)该(gāi)记(jì)住(zhù)。',
          images: <String>[],
          imageCaption: '第6章第2段',
        ),
      ],
    ),
  ],
);

// ============================================================================
// 截竿入城（中国寓言）
// ============================================================================

const StoryBook kStoryFableJiegan = StoryBook(
  id: 'fable_jiegan',
  title: '截(jié)竿(gān)入(rù)城(chéng)',
  source: StorySource.fable,
  cover: 'assets/images/stories/fable_jiegan/cover.png',
  intro: '拿(ná)长(cháng)竹(zhú)竿(gān)进(jìn)城(chéng)，竖(shù)着(zhe)进(jìn)不(bù)去(qù)，横(héng)着(zhe)也(yě)进(jìn)不(bù)去(qù)。',
  difficulty: 1,
  chapters: <StoryChapter>[
    StoryChapter(
      id: 'c1',
      title: '扛(káng)竿(gān)进(jìn)城(chéng)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '有(yǒu)个(gè)人(rén)扛(káng)着(zhe)一(yī)根(gēn)长(cháng)长(cháng)的(de)竹(zhú)竿(gān)想(xiǎng)进(jìn)城(chéng)去(qù)卖(mài)。',
          images: <String>['assets/images/stories/fable_jiegan/c1_p1_1.png'],
          imageCaption: '第1章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '他(tā)来(lái)到(dào)城(chéng)门(mén)口(kǒu)，先(xiān)把(bǎ)竿(gān)竖(shù)起(qǐ)来(lái)往(wǎng)门(mén)里(li)塞(sāi)。',
          images: <String>[],
          imageCaption: '第1章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c2',
      title: '竖(shù)着(zhe)不(bù)行(xíng)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '城(chéng)门(mén)太(tài)矮(ǎi)，竹(zhú)竿(gān)比(bǐ)门(mén)还(hái)高(gāo)一(yī)截(jié)，竖(shù)着(zhe)怎(zěn)样(yàng)也(yě)进(jìn)不(bù)去(qù)。',
          images: <String>['assets/images/stories/fable_jiegan/c2_p1_1.png'],
          imageCaption: '第2章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '他(tā)急(jí)得(de)满(mǎn)头(tóu)大(dà)汗(hàn)，把(bǎ)竿(gān)上(shàng)下(xià)挪(nuó)了(le)好(hǎo)几(jǐ)回(huí)。',
          images: <String>[],
          imageCaption: '第2章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c3',
      title: '横(héng)着(zhe)也(yě)不(bù)行(xíng)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '他(tā)又(yòu)把(bǎ)竿(gān)横(héng)过(guò)来(lái)，贴(tiē)着(zhe)地(dì)面(miàn)往(wǎng)里(li)推(tuī)。',
          images: <String>['assets/images/stories/fable_jiegan/c3_p1_1.png'],
          imageCaption: '第3章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '可(kě)城(chéng)门(mén)太(tài)窄(zhǎi)，竿(gān)比(bǐ)门(mén)还(hái)宽(kuān)，横(héng)着(zhe)照(zhào)样(yàng)卡(kǎ)住(zhù)。',
          images: <String>[],
          imageCaption: '第3章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c4',
      title: '旁(páng)观(guān)支(zhī)招(zhāo)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '围(wéi)观(guān)的(de)人(rén)七(qī)嘴(zuǐ)八(bā)舌(shé)，一(yī)个(gè)老(lǎo)头(tóu)笑(xiào)着(zhe)开(kāi)了(le)口(kǒu)。',
          images: <String>['assets/images/stories/fable_jiegan/c4_p1_1.png'],
          imageCaption: '第4章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '老(lǎo)头(tóu)说(shuō)：你(nǐ)把(bǎ)竿(gān)从(cóng)当(dāng)中(zhōng)锯(jù)断(duàn)，不(bú)就(jiù)进(jìn)去(qù)了(le)。',
          images: <String>[],
          imageCaption: '第4章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c5',
      title: '照(zhào)做(zuò)惹(rě)笑(xiào)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '扛(káng)竿(gān)的(de)人(rén)真(zhēn)听(tīng)了(le)，借(jiè)来(lái)锯(jù)把(bǎ)好(hǎo)竿(gān)锯(jù)成(chéng)两(liǎng)截(jié)。',
          images: <String>['assets/images/stories/fable_jiegan/c5_p1_1.png'],
          imageCaption: '第5章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '旁(páng)人(rén)笑(xiào)得(de)前(qián)仰(yǎng)后(hòu)合(hé)，他(tā)还(hái)以(yǐ)为(wéi)自(zì)己(jǐ)变(biàn)聪(cōng)明(míng)。',
          images: <String>[],
          imageCaption: '第5章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c6',
      title: '故(gù)事(shì)的(de)道(dào)理(lǐ)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '遇(yù)到(dào)难(nán)题(tí)先(xiān)想(xiǎng)明(míng)白(bái)，别(bié)乱(luàn)听(tīng)糊(hú)涂(tu)主(zhǔ)意(yì)。',
          images: <String>['assets/images/stories/fable_jiegan/c6_p1_1.png'],
          imageCaption: '第6章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '把(bǎ)好(hǎo)端(duān)端(duān)的(de)东(dōng)西(xi)毁(huǐ)了(le)，问(wèn)题(tí)也(yě)没(méi)真(zhēn)解(jiě)。，这(zhè)样(yàng)才(cái)不(bù)会(huì)再(zài)做(zuò)傻(shǎ)事(shì)了(le)。',
          images: <String>[],
          imageCaption: '第6章第2段',
        ),
      ],
    ),
  ],
);

// ============================================================================
// 鹬蚌相争（中国寓言）
// ============================================================================

const StoryBook kStoryFableYubang = StoryBook(
  id: 'fable_yubang',
  title: '鹬(yù)蚌(bàng)相(xiāng)争(zhēng)',
  source: StorySource.fable,
  cover: 'assets/images/stories/fable_yubang/cover.png',
  intro: '鹬(yù)鸟(niǎo)啄(zhuó)蚌(bàng)肉(ròu)，蚌(bàng)夹(jiā)住(zhù)鸟(niǎo)嘴(zuǐ)，两(liǎng)人(rén)不(bù)放(fàng)，渔(yú)翁(wēng)得(dé)利(lì)。',
  difficulty: 1,
  chapters: <StoryChapter>[
    StoryChapter(
      id: 'c1',
      title: '河(hé)蚌(bàng)晒(shài)太(tài)阳(yáng)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '晴(qíng)天(tiān)河(hé)边(biān)的(de)蚌(bàng)张(zhāng)开(kāi)两(liǎng)壳(ké)，懒(lǎn)洋(yáng)洋(yáng)晒(shài)太(tài)阳(yáng)。',
          images: <String>['assets/images/stories/fable_yubang/c1_p1_1.png'],
          imageCaption: '第1章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '它(tā)一(yī)动(dòng)不(bù)动(dòng)，晒(shài)得(de)舒(shū)舒(shū)服(fu)服(fu)，不(bù)知(zhī)危(wēi)险(xiǎn)将(jiāng)近(jìn)。',
          images: <String>[],
          imageCaption: '第1章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c2',
      title: '鹬(yù)鸟(niǎo)来(lái)了(le)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '一(yī)只(zhī)鹬(yù)鸟(niǎo)飞(fēi)过(guò)，看(kàn)见(jiàn)肥(féi)蚌(bàng)嘴(zuǐ)馋(chán)伸(shēn)长(cháng)嘴(zuǐ)去(qù)啄(zhuó)。',
          images: <String>['assets/images/stories/fable_yubang/c2_p1_1.png'],
          imageCaption: '第2章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '蚌(bàng)一(yī)惊(jīng)猛(měng)地(de)合(hé)壳(ké)，正(zhèng)夹(jiā)住(zhù)鹬(yù)鸟(niǎo)的(de)长(cháng)嘴(zuǐ)。',
          images: <String>[],
          imageCaption: '第2章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c3',
      title: '谁(shuí)也(yě)不(bù)放(fàng)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '鹬(yù)鸟(niǎo)甩(shuǎi)不(bù)脱(tuō)，骂(mà)道(dào)：今(jīn)天(tiān)不(bù)下(xià)雨(yǔ)你(nǐ)就(jiù)干(gān)死(sǐ)。',
          images: <String>['assets/images/stories/fable_yubang/c3_p1_1.png'],
          imageCaption: '第3章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '蚌(bàng)也(yě)不(bù)松(sōng)口(kǒu)，回(huí)嘴(zuǐ)说(shuō)：我(wǒ)不(bù)放(fàng)你(nǐ)嘴(zuǐ)抽(chōu)不(bù)出(chū)也(yě)饿(è)死(sǐ)。',
          images: <String>[],
          imageCaption: '第3章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c4',
      title: '僵(jiāng)持不(bù)下(xià)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '两(liǎng)个(gè)就(jiù)这(zhè)样(yàng)咬(yǎo)着(zhe)不(bù)放(fàng)，谁(shuí)也(yě)不(bù)肯(kěn)先(xiān)让(ràng)一(yī)步(bù)。',
          images: <String>['assets/images/stories/fable_yubang/c4_p1_1.png'],
          imageCaption: '第4章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '太(tài)阳(yáng)越(yuè)晒(shài)越(yuè)毒(dú)，河(hé)边(biān)静(jìng)得(de)只(zhǐ)剩(shèng)它(tā)们(men)的(de)喘(chuǎn)气(qì)。',
          images: <String>[],
          imageCaption: '第4章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c5',
      title: '渔(yú)翁(wēng)得(de)利(lì)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '一(yī)个(gè)打(dǎ)鱼(yú)老(lǎo)人(rén)路(lù)过(guò)，轻(qīng)轻(qīng)一(yī)手(shǒu)一(yī)个(gè)把(bǎ)它(tā)俩(liǎ)捞(lāo)走(zǒu)。',
          images: <String>['assets/images/stories/fable_yubang/c5_p1_1.png'],
          imageCaption: '第5章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '老(lǎo)人(rén)笑(xiào)着(zhe)说(shuō)：你(nǐ)们(men)争(zhēng)吧(ba)，倒(dào)省(shěng)了(le)我(wǒ)费(fèi)力(lì)气(qì)。',
          images: <String>[],
          imageCaption: '第5章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c6',
      title: '故(gù)事(shì)的(de)道(dào)理(lǐ)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '两(liǎng)人(rén)死(sǐ)掐(qiā)着(zhe)不(bù)放(fàng)，到(dào)头(tóu)来(lái)便(biàn)宜(yi)了(le)第(dì)三(sān)方(fāng)。',
          images: <String>['assets/images/stories/fable_yubang/c6_p1_1.png'],
          imageCaption: '第6章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '有(yǒu)矛(máo)盾(dùn)好(hǎo)好(hǎo)谈(tán)，别(bié)让(ràng)外(wài)人(rén)捡(jiǎn)了(le)便(biàn)宜(yi)。，这(zhè)样(yàng)才(cái)算(suàn)真(zhēn)明(míng)白(bái)了(le)。',
          images: <String>[],
          imageCaption: '第6章第2段',
        ),
      ],
    ),
  ],
);

// ============================================================================
// 东郭先生和狼（中国寓言）
// ============================================================================

const StoryBook kStoryFableDongguo = StoryBook(
  id: 'fable_dongguo',
  title: '东(dōng)郭(guō)先(xiān)生(shēng)和(hé)狼(láng)',
  source: StorySource.fable,
  cover: 'assets/images/stories/fable_dongguo/cover.png',
  intro: '东(dōng)郭(guō)先(xiān)生(shēng)救(jiù)了(le)狼(láng)，狼(láng)反(fǎn)而(ér)要(yào)吃(chī)他(tā)。',
  difficulty: 1,
  chapters: <StoryChapter>[
    StoryChapter(
      id: 'c1',
      title: '救(jiù)下(xià)狼(láng)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '东(dōng)郭(guō)先(xiān)生(shēng)骑(qí)驴(lǘ)走(zǒu)路(lù)，一(yī)只(zhī)狼(láng)逃(táo)来(lái)求(qiú)他(tā)藏(cáng)。',
          images: <String>['assets/images/stories/fable_dongguo/c1_p1_1.png'],
          imageCaption: '第1章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '猎(liè)人(rén)追(zhuī)得(de)紧(jǐn)，先(xiān)生(shēng)心(xīn)软(ruǎn)把(bǎ)狼(láng)塞(sāi)进(jìn)装(zhuāng)书(shū)的(de)袋(dài)里(li)。',
          images: <String>[],
          imageCaption: '第1章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c2',
      title: '骗(piàn)过(guò)猎人(rén)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '猎(liè)人(rén)赶(gǎn)到(dào)问(wèn)看(kàn)见(jiàn)狼(láng)没(méi)，先(xiān)生(shēng)摇(yáo)头(tóu)说(shuō)没(méi)见(jiàn)。',
          images: <String>['assets/images/stories/fable_dongguo/c2_p1_1.png'],
          imageCaption: '第2章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '猎(liè)人(rén)走(zǒu)远(yuǎn)了(le)，他(tā)才(cái)把(bǎ)狼(láng)放(fàng)出(chū)袋(dài)子(zi)，还(hái)拍(pāi)拍(pāi)它(tā)。',
          images: <String>[],
          imageCaption: '第2章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c3',
      title: '狼(láng)要(yào)吃(chī)他(tā)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '狼(láng)一(yī)出(chū)袋(dài)就(jiù)露(lù)出(chū)尖(jiān)牙(yá)，说(shuō)饿(è)极(jí)了(le)要(yào)吃(chī)他(tā)。',
          images: <String>['assets/images/stories/fable_dongguo/c3_p1_1.png'],
          imageCaption: '第3章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '先(xiān)生(shēng)大(dà)惊(jīng)连(lián)连(lián)后(hòu)退(tuì)，说(shuō)刚(gāng)救(jiù)你(nǐ)怎(zěn)能(néng)吃(chī)我(wǒ)。',
          images: <String>[],
          imageCaption: '第3章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c4',
      title: '请(qǐng)人(rén)评(píng)理(lǐ)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '狼(láng)说(shuō)它(tā)饿(è)该(gāi)吃(chī)，先(xiān)生(shēng)说(shuō)救(jiù)命(mìng)该(gāi)报(bào)恩(ēn)。',
          images: <String>['assets/images/stories/fable_dongguo/c4_p1_1.png'],
          imageCaption: '第4章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '两(liǎng)人(rén)拉(lā)着(zhe)一(yī)位(wèi)老(lǎo)头(tóu)评(píng)理(lǐ)，老(lǎo)头(tóu)故(gù)意(yì)装(zhuāng)糊(hú)涂(tu)。',
          images: <String>[],
          imageCaption: '第4章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c5',
      title: '老(lǎo)头(tou)的(de)计(ji)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '老(lǎo)头(tóu)说(shuō)：袋(dài)子(zi)这(zhè)么(me)小(xiǎo)，狼(láng)怎(zěn)么(me)装(zhuāng)得(de)下(xià)？再(zài)装(zhuāng)一(yī)回(huí)。',
          images: <String>['assets/images/stories/fable_dongguo/c5_p1_1.png'],
          imageCaption: '第5章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '狼(láng)听(tīng)话(huà)钻(zuān)进(jìn)袋(dài)，老(lǎo)头(tóu)立(lì)刻(kè)系(xì)紧(jǐn)袋(dài)口(kǒu)绳(shéng)。',
          images: <String>[],
          imageCaption: '第5章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c6',
      title: '故(gù)事(shì)的(de)道(dào)理(lǐ)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '对(duì)坏(huài)人(rén)的(de)善(shàn)良(liáng)，要(yào)看(kàn)清(qīng)对(duì)方(fāng)本(běn)性(xìng)。',
          images: <String>['assets/images/stories/fable_dongguo/c6_p1_1.png'],
          imageCaption: '第6章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '东(dōng)郭(guō)先(xiān)生(shēng)的(de)教(jiào)训(xùn)：救(jiù)人(rén)要(yào)救(jiù)该(gāi)救(jiù)的(de)。，这(zhè)个(gè)道(dào)理(lǐ)让(ràng)人(rén)长(cháng)了(le)见(jiàn)识(shi)，做(zuò)事(shì)更(gèng)明(míng)白(bái)，心(xīn)里(li)更(gèng)亮(liàng)堂(táng)。',
          images: <String>[],
          imageCaption: '第6章第2段',
        ),
      ],
    ),
  ],
);

// ============================================================================
// 愚公移山（神话传说）
// ============================================================================

const StoryBook kStoryMythYugong = StoryBook(
  id: 'myth_yugong',
  title: '愚(yú)公(gōng)移(yí)山(shān)',
  source: StorySource.myth,
  cover: 'assets/images/stories/myth_yugong/cover.png',
  intro: '九(jiǔ)十(shí)岁(suì)的(de)愚(yú)公(gōng)带(dài)领(lǐng)家(jiā)人(rén)，要(yào)挖(wā)掉(diào)挡(dǎng)路(lù)的(de)两(liǎng)座(zuò)大(dà)山(shān)。',
  difficulty: 1,
  chapters: <StoryChapter>[
    StoryChapter(
      id: 'c1',
      title: '两(liǎng)座(zuò)大(dà)山(shān)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '古(gǔ)时(shí)候(hòu)有(yǒu)位(wèi)老(lǎo)人(rén)叫(jiào)愚(yú)公(gōng)，家(jiā)门(mén)前(qián)挡(dǎng)着(zhe)两(liǎng)座(zuò)大(dà)山(shān)。',
          images: <String>['assets/images/stories/myth_yugong/c1_p1_1.png'],
          imageCaption: '第1章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '出(chū)门(mén)要(yào)绕(rào)很(hěn)远(yuǎn)的(de)路(lù)，一(yī)家(jiā)人(rén)都(dōu)觉(jué)得(de)出(chū)行(xíng)不(bù)便(biàn)。',
          images: <String>[],
          imageCaption: '第1章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c2',
      title: '下(xià)定(dìng)决(jué)心(xīn)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '愚(yú)公(gōng)把(bǎ)儿(ér)孙(sūn)叫(jiào)来(lái)说(shuō)：咱(zán)们(men)一(yī)锹(qiāo)一(yī)筐(kuāng)把(bǎ)山(shān)搬(bān)走(zǒu)。',
          images: <String>['assets/images/stories/myth_yugong/c2_p1_1.png'],
          imageCaption: '第2章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '儿(ér)孙(sūn)都(dōu)点(diǎn)头(tóu)答(dā)应(yìng)，只(zhǐ)有(yǒu)妻(qī)子(zi)担(dān)心(xīn)土(tǔ)石(shí)堆(duī)哪(nǎ)儿(er)。',
          images: <String>[],
          imageCaption: '第2章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c3',
      title: '天(tiān)天(tiān)挖(wā)山(shān)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '第(dì)二(èr)天(tiān)全(quán)家(jiā)扛(káng)锄(chú)头(tou)上(shàng)山(shān)，凿(záo)石(shí)挖(wā)土(tǔ)装(zhuāng)满(mǎn)筐(kuāng)。',
          images: <String>['assets/images/stories/myth_yugong/c3_p1_1.png'],
          imageCaption: '第3章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '他(tā)们(men)把(bǎ)土(tǔ)石(shí)挑(tiāo)到(dào)渤(bó)海(hǎi)边(biān)，来(lái)回(huí)走(zǒu)远(yuǎn)也(yě)不(bù)肯(kěn)停(tíng)。',
          images: <String>[],
          imageCaption: '第3章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c4',
      title: '智(zhì)叟(sǒu)笑(xiào)话(huà)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '河(hé)边(biān)智(zhì)叟(sǒu)笑(xiào)他(tā)：你(nǐ)这(zhè)把(bǎ)老(lǎo)骨(gǔ)头(tou)能(néng)搬(bān)多(duō)少(shǎo)。',
          images: <String>['assets/images/stories/myth_yugong/c4_p1_1.png'],
          imageCaption: '第4章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '愚(yú)公(gōng)答(dá)：我(wǒ)死(sǐ)有(yǒu)儿(ér)子(zi)，儿(ér)死(sǐ)有(yǒu)孙(sūn)子(zi)，子(zǐ)孙(sūn)无(wú)穷(qióng)尽(jìn)。',
          images: <String>[],
          imageCaption: '第4章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c5',
      title: '感(gǎn)动(dòng)上(shàng)天(tiān)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '智(zhì)叟(sǒu)听(tīng)了(le)哑(yǎ)口(kǒu)无(wú)言(yán)，愚(yú)公(gōng)照(zhào)旧(jiù)每(měi)天(tiān)挖(wā)山(shān)不(bù)歇(xiē)。',
          images: <String>['assets/images/stories/myth_yugong/c5_p1_1.png'],
          imageCaption: '第5章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '天(tiān)帝(dì)听(tīng)说(shuō)这(zhè)事(shì)被(bèi)他(tā)韧(rèn)劲(jìn)打(dǎ)动(dòng)，派(pài)仙(xiān)人(rén)搬(bān)走(zǒu)两(liǎng)山(shān)。',
          images: <String>[],
          imageCaption: '第5章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c6',
      title: '故(gù)事(shì)的(de)道(dào)理(lǐ)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '看(kàn)似(sì)办(bàn)不(bù)到(dào)的(de)事(shì)，只(zhǐ)要(yào)肯(kěn)坚(jiān)持(chí)就(jiù)有(yǒu)希(xī)望(wàng)。',
          images: <String>['assets/images/stories/myth_yugong/c6_p1_1.png'],
          imageCaption: '第6章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '一(yī)代(dài)做(zuò)不(bù)完(wán)的(de)事(shì)，子(zǐ)孙(sūn)接(jiē)着(zhe)做(zuò)总(zǒng)能(néng)成(chéng)。',
          images: <String>[],
          imageCaption: '第6章第2段',
        ),
      ],
    ),
  ],
);

// ============================================================================
// 大禹治水（神话传说）
// ============================================================================

const StoryBook kStoryMythDayu = StoryBook(
  id: 'myth_dayu',
  title: '大(dà)禹(yǔ)治(zhì)水(shuǐ)',
  source: StorySource.myth,
  cover: 'assets/images/stories/myth_dayu/cover.png',
  intro: '大(dà)禹(yǔ)为(wèi)了(le)治(zhì)水(shuǐ)三(sān)过(guò)家(jiā)门(mén)而(ér)不(bù)入(rù)，疏(shū)通(tōng)了(le)九(jiǔ)条(tiáo)大(dà)河(hé)。',
  difficulty: 1,
  chapters: <StoryChapter>[
    StoryChapter(
      id: 'c1',
      title: '洪(hóng)水(shuǐ)成(chéng)灾(zāi)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '很(hěn)久(jiǔ)以(yǐ)前(qián)大(dà)水(shuǐ)淹(yān)了(le)田(tián)地(dì)和(hé)村(cūn)庄(zhuāng)，百(bǎi)姓(xìng)无(wú)家(jiā)可(kě)归(guī)。',
          images: <String>['assets/images/stories/myth_dayu/c1_p1_1.png'],
          imageCaption: '第1章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '老(lǎo)百(bǎi)姓(xìng)扶(fú)老(lǎo)携(xié)幼(yòu)逃(táo)上(shàng)山(shān)，盼(pàn)着(zhe)有(yǒu)人(rén)早(zǎo)治(zhì)住(zhù)水(shuǐ)。',
          images: <String>[],
          imageCaption: '第1章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c2',
      title: '父(fù)亲(qīn)失(shī)败(bài)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '大(dà)禹(yǔ)的(de)父(fù)亲(qīn)鲧(gǔn)先(xiān)去(qù)治(zhì)水(shuǐ)，只(zhǐ)会(huì)用(yòng)土(tǔ)堵(dǔ)决(jué)口(kǒu)。',
          images: <String>['assets/images/stories/myth_dayu/c2_p1_1.png'],
          imageCaption: '第2章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '水(shuǐ)越(yuè)堵(dǔ)越(yuè)猛(měng)，一(yī)冲(chōng)就(jiù)垮(kuǎ)，九(jiǔ)年(nián)也(yě)没(méi)治(zhì)好(hǎo)。',
          images: <String>[],
          imageCaption: '第2章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c3',
      title: '大(dà)禹(yǔ)接(jiē)班(bān)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '鲧(gǔn)去(qù)世(shì)后(hòu)，儿(ér)子(zi)大(dà)禹(yǔ)接(jiē)下(xià)治(zhì)水(shuǐ)的(de)重(zhòng)任(rèn)。',
          images: <String>['assets/images/stories/myth_dayu/c3_p1_1.png'],
          imageCaption: '第3章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '大(dà)禹(yǔ)踏(tà)遍(biàn)山(shān)川(chuān)明(míng)白(bái)了(le)：水(shuǐ)要(yào)疏(shū)不(bù)能(néng)堵(dǔ)。',
          images: <String>[],
          imageCaption: '第3章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c4',
      title: '三(sān)过(guò)家(jia)门(mén)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '他(tā)带(dài)人(rén)挖(wā)河(hé)道(dào)开(kāi)山(shān)口(kǒu)，一(yī)年(nián)到(dào)头(tóu)在(zài)外(wài)奔(bēn)忙(máng)。',
          images: <String>['assets/images/stories/myth_dayu/c4_p1_1.png'],
          imageCaption: '第4章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '有(yǒu)三(sān)次(cì)路(lù)过(guò)家(jiā)门(mén)，听(tīng)见(jiàn)娃(wá)娃(wa)哭(kū)也(yě)没(méi)进(jìn)去(qù)看(kàn)。',
          images: <String>[],
          imageCaption: '第4章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c5',
      title: '河(hé)水(shuǐ)退(tuì)去(qù)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '他(tā)的(de)妻(qī)子(zi)生(shēng)了(le)儿(ér)子(zi)，他(tā)正(zhèng)在(zài)远(yuǎn)处(chù)量(liáng)河(hé)道(dào)。',
          images: <String>['assets/images/stories/myth_dayu/c5_p1_1.png'],
          imageCaption: '第5章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '有(yǒu)人(rén)劝(quàn)他(tā)回(huí)看(kàn)一(yī)眼(yǎn)，他(tā)摇(yáo)头(tóu)说(shuō)水(shuǐ)不(bù)退(tuì)不(bù)能(néng)走(zǒu)。',
          images: <String>[],
          imageCaption: '第5章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c6',
      title: '故(gù)事(shì)的(de)道(dào)理(lǐ)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '办(bàn)事(shì)要(yào)顺(shùn)着(zhe)道(dào)理(lǐ)来(lái)，硬(yìng)堵(dǔ)不(bù)如(rú)巧(qiǎo)疏(shū)。',
          images: <String>['assets/images/stories/myth_dayu/c6_p1_1.png'],
          imageCaption: '第6章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '为(wèi)大(dà)家(jiā)舍(shě)小(xiǎo)家(jiā)，百(bǎi)姓(xìng)才(cái)永(yǒng)远(yuǎn)记(jì)得(de)你(nǐ)。，这(zhè)样(yàng)才(cái)算(suàn)真(zhēn)明(míng)白(bái)了(le)道(dào)理(lǐ)。',
          images: <String>[],
          imageCaption: '第6章第2段',
        ),
      ],
    ),
  ],
);

// ============================================================================
// 牛郎织女（神话传说）
// ============================================================================

const StoryBook kStoryMythNiulang = StoryBook(
  id: 'myth_niulang',
  title: '牛(niú)郎(láng)织(zhī)女(nǚ)',
  source: StorySource.myth,
  cover: 'assets/images/stories/myth_niulang/cover.png',
  intro: '牛(niú)郎(láng)和(hé)织(zhī)女(nǚ)相(xiāng)爱(ài)，被(bèi)王(wáng)母(mǔ)娘(niáng)娘(niáng)用(yòng)银(yín)河(hé)隔(gé)开(kāi)。',
  difficulty: 1,
  chapters: <StoryChapter>[
    StoryChapter(
      id: 'c1',
      title: '牛(niú)郎(láng)孤(gū)身(shēn)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '从(cóng)前(qián)有(yǒu)个(gè)后(hòu)生(shēng)叫(jiào)牛(niú)郎(láng)，从(cóng)小(xiǎo)没(méi)了(le)爹(diē)娘(niáng)。',
          images: <String>['assets/images/stories/myth_niulang/c1_p1_1.png'],
          imageCaption: '第1章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '哥(gē)嫂(sǎo)待(dāi)他(tā)不(bù)好(hǎo)，分(fēn)了(le)头(tóu)老(lǎo)牛(niú)就(jiù)让(ràng)他(tā)分(fēn)家(jiā)单(dān)过(guò)。',
          images: <String>[],
          imageCaption: '第1章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c2',
      title: '老(lǎo)牛(niú)做(zuò)媒(méi)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '这(zhè)头(tóu)老(lǎo)牛(niú)会(huì)说(shuō)人(rén)话(huà)，告(gào)诉(sù)他(tā)湖(hú)边(biān)有(yǒu)仙(xiān)女(nǚ)洗(xǐ)澡(zǎo)。',
          images: <String>['assets/images/stories/myth_niulang/c2_p1_1.png'],
          imageCaption: '第2章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '牛(niú)郎(láng)按(àn)老(lǎo)牛(niú)的(de)话(huà)藏(cáng)起(qǐ)织(zhī)女(nǚ)的(de)衣(yī)裳(shang)，留(liú)下(xià)了(le)她(tā)。',
          images: <String>[],
          imageCaption: '第2章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c3',
      title: '男(nán)耕(gēng)女(nǚ)织(zhī)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '织(zhī)女(nǚ)是(shì)天(tiān)上(shàng)仙(xiān)女(nǚ)，爱(ài)上(shàng)勤(qín)劳(láo)的(de)牛(niú)郎(láng)成(chéng)了(le)亲(qīn)。',
          images: <String>['assets/images/stories/myth_niulang/c3_p1_1.png'],
          imageCaption: '第3章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '婚(hūn)后(hòu)牛(niú)郎(láng)种(zhòng)地(dì)，织(zhī)女(nǚ)织(zhī)布(bù)，还(hái)生(shēng)了(le)一(yī)对(duì)儿(ér)女(nǚ)。',
          images: <String>[],
          imageCaption: '第3章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c4',
      title: '王(wáng)母(mǔ)发(fā)怒(nù)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '王(wáng)母(mǔ)娘(niáng)娘(niáng)知(zhī)道(dào)大(dà)怒(nù)，派(pài)天(tiān)兵(bīng)把(bǎ)织(zhī)女(nǚ)抓(zhuā)回(huí)天(tiān)。',
          images: <String>['assets/images/stories/myth_niulang/c4_p1_1.png'],
          imageCaption: '第4章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '牛(niú)郎(láng)披(pī)上(shàng)老(lǎo)牛(niú)留(liú)下(xià)的(de)皮(pí)，挑(tiāo)着(zhe)两(liǎng)娃(wá)追(zhuī)上(shàng)天(tiān)。',
          images: <String>[],
          imageCaption: '第4章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c5',
      title: '银(yín)河(hé)相隔(gé)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '王(wáng)母(mǔ)娘(niáng)娘(niáng)拔(bá)银(yín)簪(zān)一(yī)划(huà)，出(chū)一(yī)道(dào)银(yín)河(hé)挡(dǎng)路(lù)。',
          images: <String>['assets/images/stories/myth_niulang/c5_p1_1.png'],
          imageCaption: '第5章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '牛(niú)郎(láng)在(zài)河(hé)这(zhè)边(biān)，织(zhī)女(nǚ)在(zài)河(hé)那(nà)边(biān)，遥(yáo)遥(yáo)相(xiāng)望(wàng)。',
          images: <String>[],
          imageCaption: '第5章第2段',
        ),
      ],
    ),
    StoryChapter(
      id: 'c6',
      title: '七(qī)夕(xī)相会(huì)',
      paragraphs: <StoryParagraph>[
        StoryParagraph(
          id: 'p1',
          ruby: '喜(xǐ)鹊(què)心(xīn)软(ruǎn)，每(měi)年(nián)七(qī)月(yuè)初(chū)七(qī)搭(dā)鹊(què)桥(qiáo)让(ràng)他(tā)见(jiàn)。',
          images: <String>['assets/images/stories/myth_niulang/c6_p1_1.png'],
          imageCaption: '第6章第1段',
        ),
        StoryParagraph(
          id: 'p2',
          ruby: '百(bǎi)姓(xìng)说(shuō)那(nà)天(tiān)的(de)雨(yǔ)是(shì)他(tā)俩(liǎ)的(de)泪(lèi)，也(yě)盼(pàn)自(zì)家(jiā)团(tuán)圆(yuán)。，这(zhè)个(gè)故(gù)事(shì)人(rén)人(rén)都(dōu)喜(xǐ)欢(huan)，年(nián)年(nián)讲(jiǎng)不(bù)厌(yàn)。',
          images: <String>[],
          imageCaption: '第6章第2段',
        ),
      ],
    ),
  ],
);

/// V1.0 全部故事。顺序即书架展示顺序（名著/传说/寓言/神话）。
const List<StoryBook> kAllStories = <StoryBook>[
  kStoryNezha,
  kStoryHavoc,
  kStoryWhiteSnake,
  kStorySimaGuang,
  kStoryPony,
  kStoryMarket,
  kStoryFableShouzhu,
  kStoryFableWangyang,
  kStoryFableYamiao,
  kStoryFableHujia,
  kStoryFableKezhou,
  kStoryFableJingdi,
  kStoryFableMaodun,
  kStoryFableHuashe,
  kStoryFableZhengren,
  kStoryFableYegong,
  kStoryFableLanyu,
  kStoryFableMaidu,
  kStoryFableSaiweng,
  kStoryFableBeigong,
  kStoryFableWushibu,
  kStoryFableJiegan,
  kStoryFableYubang,
  kStoryFableDongguo,
  kStoryMythYugong,
  kStoryMythDayu,
  kStoryMythNiulang,
];

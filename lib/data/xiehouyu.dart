// ============================================================================
// 晚晴识字 · 歇后语模块
//
// 选材标准（贴合用户母亲画像）：河南农村中老年人一听就熟、不带书面腔、
// 不涉宗教 / 政治 / 迷信 / 神仙，一律走平民生活路线。
//
// 注音格式严格为「字(pīn)字(pīn)」，与故事屋一致：
//   - 标点（，。、）不注音，parseRuby 会当成无注音字符处理；
//   - 破折号不在数据里，由 UI 在「上半句——下半句」之间渲染；
//   - 多音字按该词语的实际读音注，其中「一 / 不」按相邻字声调变调：
//       一：去声前 yí，其余 yì，句末/单独 yī；不：去声前 bú，其余 bù。
//     （注：「一清二白」的「一」依开发者示例保留 yī。）
// ============================================================================

/// 一条歇后语。
class Xiehouyu {
  final String id;
  final String front; // 上半句，ruby 注音格式
  final String back; // 下半句，ruby 注音格式
  final String meaning; // 白话解释，ruby 注音格式（她要能读）
  final String category; // 分类：生活 / 做事 / 为人 / 天气农事

  const Xiehouyu({
    required this.id,
    required this.front,
    required this.back,
    required this.meaning,
    required this.category,
  });
}

/// 全部歇后语（40 条，平民生活向，按常见度大致排列）。
const List<Xiehouyu> kXiehouyu = <Xiehouyu>[
  // ---------------- 生活 ----------------
  Xiehouyu(
    id: 'xh01',
    front: '小(xiǎo)葱(cōng)拌(bàn)豆(dòu)腐(fǔ)',
    back: '一(yī)清(qīng)二(èr)白(bái)',
    meaning:
        '说(shuō)一(yí)个(gè)人(rén)做(zuò)事(shì)清(qīng)清(qīng)白(bái)白(bái)、没(méi)偷(tōu)没(méi)骗(piàn)，就(jiù)用(yòng)这(zhè)一(yí)句(jù)话(huà)夸(kuā)他(tā)。',
    category: '生活',
  ),
  Xiehouyu(
    id: 'xh02',
    front: '芝(zhī)麻(má)开(kāi)花(huā)',
    back: '节(jié)节(jié)高(gāo)',
    meaning:
        '日(rì)子(zi)一(yì)天(tiān)比(bǐ)一(yì)天(tiān)好(hǎo)，生(shēng)活(huó)越(yuè)过(guò)越(yuè)顺(shùn)，就(jiù)说(shuō)像(xiàng)芝(zhī)麻(má)开(kāi)花(huā)节(jié)节(jié)高(gāo)。',
    category: '天气农事',
  ),
  Xiehouyu(
    id: 'xh03',
    front: '兔(tù)子(zi)的(de)尾(wěi)巴(ba)',
    back: '长(cháng)不(bù)了(liǎo)',
    meaning:
        '不(bù)好(hǎo)的(de)势(shì)头(tóu)撑(chēng)不(bù)久(jiǔ)，好(hǎo)景(jǐng)不(bú)会(huì)太(tài)长(cháng)，就(jiù)说(shuō)像(xiàng)兔(tù)子(zi)的(de)尾(wěi)巴(ba)长(cháng)不(bù)了(liǎo)。',
    category: '生活',
  ),
  Xiehouyu(
    id: 'xh04',
    front: '秋(qiū)后(hòu)的(de)蚂(mà)蚱(zha)',
    back: '蹦(bèng)跶(da)不(bù)了(liǎo)几(jǐ)天(tiān)',
    meaning:
        '坏(huài)人(rén)或(huò)坏(huài)势(shì)力(lì)快(kuài)完(wán)了(le)，撑(chēng)不(bù)了(liǎo)多(duō)久(jiǔ)了(le)，就(jiù)说(shuō)像(xiàng)秋(qiū)后(hòu)的(de)蚂(mà)蚱(zha)。',
    category: '天气农事',
  ),
  Xiehouyu(
    id: 'xh05',
    front: '冷(lěng)水(shuǐ)泡(pào)茶(chá)',
    back: '慢(màn)慢(màn)来(lái)',
    meaning:
        '性(xìng)子(zi)别(bié)急(jí)，事(shì)情(qíng)得(děi)一(yí)步(bù)一(yí)步(bù)做(zuò)，急(jí)不(bù)得(dé)，就(jiù)说(shuō)冷(lěng)水(shuǐ)泡(pào)茶(chá)。',
    category: '生活',
  ),
  Xiehouyu(
    id: 'xh06',
    front: '麻(má)绳(shéng)专(zhuān)往(wǎng)细(xì)处(chù)断(duàn)',
    back: '祸(huò)不(bù)单(dān)行(xíng)',
    meaning:
        '倒(dǎo)霉(méi)的(de)事(shì)一(yí)件(jiàn)接(jiē)一(yí)件(jiàn)，越(yuè)怕(pà)啥(shá)越(yuè)来(lái)啥(shá)，就(jiù)说(shuō)麻(má)绳(shéng)专(zhuān)往(wǎng)细(xì)处(chù)断(duàn)。',
    category: '生活',
  ),
  Xiehouyu(
    id: 'xh07',
    front: '丑(chǒu)媳(xí)妇(fu)总(zǒng)得(děi)见(jiàn)公(gōng)婆(pó)',
    back: '早(zǎo)晚(wǎn)的(de)事(shì)',
    meaning:
        '该(gāi)面(miàn)对(duì)的(de)人(rén)和(hé)事(shì)躲(duǒ)不(bú)掉(diào)，迟(chí)早(zǎo)要(yào)见(jiàn)，就(jiù)说(shuō)丑(chǒu)媳(xí)妇(fu)总(zǒng)得(děi)见(jiàn)公(gōng)婆(pó)。',
    category: '生活',
  ),

  // ---------------- 做事 ----------------
  Xiehouyu(
    id: 'xh08',
    front: '竹(zhú)篮(lán)打(dǎ)水(shuǐ)',
    back: '一(yì)场(chǎng)空(kōng)',
    meaning:
        '忙(máng)了(le)半(bàn)天(tiān)，最(zuì)后(hòu)啥(shá)也(yě)没(méi)得(dé)到(dào)，就(jiù)说(shuō)这(zhè)叫(jiào)白(bái)忙(máng)一(yì)场(chǎng)。',
    category: '做事',
  ),
  Xiehouyu(
    id: 'xh09',
    front: '八(bā)字(zì)还(hái)没(méi)一(yì)撇(piě)',
    back: '没(méi)影(yǐng)儿(ér)的(de)事(shì)',
    meaning:
        '事(shì)情(qíng)还(hái)早(zǎo)着(zhe)呢(ne)，连(lián)个(gè)准(zhǔn)信(xìn)都(dōu)没(méi)有(yǒu)，就(jiù)说(shuō)那(nà)是(shì)八(bā)字(zì)还(hái)没(méi)一(yì)撇(piě)呢(ne)。',
    category: '做事',
  ),
  Xiehouyu(
    id: 'xh10',
    front: '肉(ròu)包(bāo)子(zi)打(dǎ)狗(gǒu)',
    back: '有(yǒu)去(qù)无(wú)回(huí)',
    meaning:
        '东(dōng)西(xi)或(huò)钱(qián)一(yì)给(gěi)出(chū)去(qù)就(jiù)收(shōu)不(bù)回(huí)来(lái)了(le)，就(jiù)叫(jiào)肉(ròu)包(bāo)子(zi)打(dǎ)狗(gǒu)。',
    category: '做事',
  ),
  Xiehouyu(
    id: 'xh11',
    front: '骑(qí)驴(lǘ)看(kàn)唱(chàng)本(běn)',
    back: '走(zǒu)着(zhe)瞧(qiáo)',
    meaning:
        '现(xiàn)在(zài)先(xiān)不(bù)争(zhēng)，等(děng)以(yǐ)后(hòu)看(kàn)结(jié)果(guǒ)再(zài)说(shuō)，就(jiù)是(shì)骑(qí)驴(lǘ)看(kàn)唱(chàng)本(běn)走(zǒu)着(zhe)瞧(qiáo)。',
    category: '做事',
  ),
  Xiehouyu(
    id: 'xh12',
    front: '外(wài)甥(sheng)打(dǎ)灯(dēng)笼(long)',
    back: '照(zhào)旧(jiù)',
    meaning:
        '事(shì)情(qíng)跟(gēn)以(yǐ)前(qián)一(yì)模(mú)一(yí)样(yàng)，一(yì)点(diǎn)儿(ér)没(méi)变(biàn)，就(jiù)说(shuō)外(wài)甥(sheng)打(dǎ)灯(dēng)笼(long)照(zhào)旧(jiù)。',
    category: '做事',
  ),
  Xiehouyu(
    id: 'xh13',
    front: '擀(gǎn)面(miàn)杖(zhàng)吹(chuī)火(huǒ)',
    back: '一(yí)窍(qiào)不(bù)通(tōng)',
    meaning:
        '对(duì)这(zhè)件(jiàn)事(shì)完(wán)全(quán)不(bù)懂(dǒng)，一(yì)点(diǎn)儿(ér)门(mén)道(dào)都(dōu)不(bù)知(zhī)，就(jiù)说(shuō)擀(gǎn)面(miàn)杖(zhàng)吹(chuī)火(huǒ)一(yí)窍(qiào)不(bù)通(tōng)。',
    category: '做事',
  ),
  Xiehouyu(
    id: 'xh14',
    front: '瞎(xiā)子(zi)点(diǎn)灯(dēng)',
    back: '白(bái)费(fèi)蜡(là)',
    meaning:
        '费(fèi)了(le)力(lì)气(qi)却(què)没(méi)起(qǐ)作(zuò)用(yòng)，白(bái)忙(máng)一(yì)场(chǎng)，就(jiù)叫(jiào)瞎(xiā)子(zi)点(diǎn)灯(dēng)白(bái)费(fèi)蜡(là)。',
    category: '做事',
  ),
  Xiehouyu(
    id: 'xh15',
    front: '偷(tōu)鸡(jī)不(bù)成(chéng)蚀(shí)把(bǎ)米(mǐ)',
    back: '得(dé)不(bù)偿(cháng)失(shī)',
    meaning:
        '想(xiǎng)占(zhàn)便(pián)宜(yi)没(méi)占(zhàn)着(zháo)，反(fǎn)倒(dào)自(zì)己(jǐ)吃(chī)了(le)亏(kuī)，就(jiù)是(shì)偷(tōu)鸡(jī)不(bù)成(chéng)蚀(shí)把(bǎ)米(mǐ)。',
    category: '做事',
  ),
  Xiehouyu(
    id: 'xh16',
    front: '画(huà)蛇(shé)添(tiān)足(zú)',
    back: '多(duō)此(cǐ)一(yì)举(jǔ)',
    meaning:
        '事(shì)情(qíng)已(yǐ)经(jīng)够(gòu)了(le)，还(hái)多(duō)走(zǒu)一(yí)步(bù)反(fǎn)而(ér)搞(gǎo)砸(zá)了(le)，就(jiù)说(shuō)画(huà)蛇(shé)添(tiān)足(zú)。',
    category: '做事',
  ),
  Xiehouyu(
    id: 'xh17',
    front: '对(duì)牛(niú)弹(tán)琴(qín)',
    back: '白(bái)费(fèi)劲(jìn)',
    meaning:
        '跟(gēn)听(tīng)不(bù)懂(dǒng)的(de)人(rén)讲(jiǎng)道(dào)理(lǐ)，说(shuō)破(pò)嘴(zuǐ)也(yě)没(méi)用(yòng)，就(jiù)叫(jiào)对(duì)牛(niú)弹(tán)琴(qín)。',
    category: '做事',
  ),
  Xiehouyu(
    id: 'xh18',
    front: '亡(wáng)羊(yáng)补(bǔ)牢(láo)',
    back: '为(wéi)时(shí)不(bù)晚(wǎn)',
    meaning:
        '出(chū)了(le)差(chā)错(cuò)赶(gǎn)紧(jǐn)补(bǔ)救(jiù)，还(hái)来(lái)得(de)及(jí)，就(jiù)说(shuō)亡(wáng)羊(yáng)补(bǔ)牢(láo)未(wèi)为(wéi)晚(wǎn)。',
    category: '做事',
  ),
  Xiehouyu(
    id: 'xh19',
    front: '三(sān)个(gè)臭(chòu)皮(pí)匠(jiang)',
    back: '顶(dǐng)个(gè)诸(zhū)葛(gě)亮(liàng)',
    meaning:
        '大(dà)伙(huǒ)儿(ér)一(yì)起(qǐ)想(xiǎng)办(bàn)法(fǎ)，比(bǐ)一(yí)个(gè)人(rén)强(qiáng)得(de)多(duō)，就(jiù)说(shuō)三(sān)个(gè)臭(chòu)皮(pí)匠(jiang)。',
    category: '做事',
  ),
  Xiehouyu(
    id: 'xh20',
    front: '打(dǎ)开(kāi)天(tiān)窗(chuāng)',
    back: '说(shuō)亮(liàng)话(huà)',
    meaning:
        '有(yǒu)话(huà)直(zhí)说(shuō)，不(bú)绕(rào)弯(wān)子(zi)，把(bǎ)事(shì)情(qíng)摊(tān)在(zài)明(míng)处(chù)讲(jiǎng)，就(jiù)是(shì)打(dǎ)开(kāi)天(tiān)窗(chuāng)。',
    category: '做事',
  ),
  Xiehouyu(
    id: 'xh21',
    front: '鸡(jī)蛋(dàn)碰(pèng)石(shí)头(tóu)',
    back: '自(zì)不(bú)量(liàng)力(lì)',
    meaning:
        '自(zì)己(jǐ)力(lì)量(liàng)小(xiǎo)，还(hái)去(qù)跟(gēn)强(qiáng)的(de)硬(yìng)碰(pèng)，吃(chī)亏(kuī)是(shì)迟(chí)早(zǎo)的(de)，就(jiù)叫(jiào)鸡(jī)蛋(dàn)碰(pèng)石(shí)头(tóu)。',
    category: '做事',
  ),
  Xiehouyu(
    id: 'xh22',
    front: '挂(guà)羊(yáng)头(tóu)卖(mài)狗(gǒu)肉(ròu)',
    back: '名(míng)不(bú)副(fù)实(shí)',
    meaning:
        '招(zhāo)牌(pái)写(xiě)得(de)好(hǎo)听(tīng)，里(lǐ)头(tóu)卖(mài)的(de)却(què)不(bú)是(shì)那(nà)回(huí)事(shì)，就(jiù)叫(jiào)挂(guà)羊(yáng)头(tóu)卖(mài)狗(gǒu)肉(ròu)。',
    category: '做事',
  ),
  Xiehouyu(
    id: 'xh23',
    front: '茶(chá)壶(hú)里(lǐ)煮(zhǔ)饺(jiǎo)子(zi)',
    back: '有(yǒu)嘴(zuǐ)倒(dào)不(bù)出(chū)',
    meaning:
        '心(xīn)里(lǐ)明(míng)白(bai)却(què)说(shuō)不(bù)清(qīng)楚(chu)，有(yǒu)本(běn)事(shi)讲(jiǎng)不(bù)出(chū)来(lái)，就(jiù)像(xiàng)茶(chá)壶(hú)里(lǐ)煮(zhǔ)饺(jiǎo)子(zi)。',
    category: '做事',
  ),
  Xiehouyu(
    id: 'xh24',
    front: '一(yì)口(kǒu)吃(chī)个(gè)胖(pàng)子(zi)',
    back: '想(xiǎng)得(dé)美(měi)',
    meaning:
        '想(xiǎng)一(yí)下(xià)子(zi)就(jiù)成(chéng)大(dà)事(shì)，太(tài)贪(tān)心(xīn)，根(gēn)本(běn)不(bù)可(kě)能(néng)，就(jiù)叫(jiào)一(yì)口(kǒu)吃(chī)个(gè)胖(pàng)子(zi)。',
    category: '做事',
  ),
  Xiehouyu(
    id: 'xh25',
    front: '不(bú)到(dào)黄(huáng)河(hé)心(xīn)不(bù)死(sǐ)',
    back: '不(bù)死(sǐ)心(xīn)',
    meaning:
        '一(yí)件(jiàn)事(shì)没(méi)办(bàn)成(chéng)就(jiù)不(bù)甘(gān)心(xīn)，非(fēi)要(yào)试(shì)到(dào)底(dǐ)，就(jiù)说(shuō)不(bú)到(dào)黄(huáng)河(hé)心(xīn)不(bù)死(sǐ)。',
    category: '做事',
  ),

  // ---------------- 为人 ----------------
  Xiehouyu(
    id: 'xh26',
    front: '哑(yǎ)巴(ba)吃(chī)黄(huáng)连(lián)',
    back: '有(yǒu)苦(kǔ)说(shuō)不(bù)出(chū)',
    meaning:
        '心(xīn)里(lǐ)有(yǒu)委(wěi)屈(qu)或(huò)难(nán)处(chù)，却(què)张(zhāng)不(bù)开(kāi)嘴(zuǐ)跟(gēn)人(rén)讲(jiǎng)，就(jiù)是(shì)哑(yǎ)巴(ba)吃(chī)黄(huáng)连(lián)。',
    category: '为人',
  ),
  Xiehouyu(
    id: 'xh27',
    front: '猫(māo)哭(kū)老(lǎo)鼠(shǔ)',
    back: '假(jiǎ)慈(cí)悲(bēi)',
    meaning:
        '明(míng)明(míng)害(hài)了(le)人(rén)，还(hái)装(zhuāng)出(chū)一(yí)副(fù)难(nán)过(guò)的(de)样(yàng)子(zi)，就(jiù)叫(jiào)猫(māo)哭(kū)老(lǎo)鼠(shǔ)。',
    category: '为人',
  ),
  Xiehouyu(
    id: 'xh28',
    front: '十(shí)五(wǔ)个(gè)吊(diào)桶(tǒng)打(dǎ)水(shuǐ)',
    back: '七(qī)上(shàng)八(bā)下(xià)',
    meaning:
        '心(xīn)里(lǐ)又(yòu)担(dān)心(xīn)又(yòu)害(hài)怕(pà)，坐(zuò)立(lì)都(dōu)不(bù)安(ān)，就(jiù)说(shuō)像(xiàng)十(shí)五(wǔ)个(gè)吊(diào)桶(tǒng)打(dǎ)水(shuǐ)七(qī)上(shàng)八(bā)下(xià)。',
    category: '为人',
  ),
  Xiehouyu(
    id: 'xh29',
    front: '黄(huáng)鼠(shǔ)狼(láng)给(gěi)鸡(jī)拜(bài)年(nián)',
    back: '没(méi)安(ān)好(hǎo)心(xīn)',
    meaning:
        '对(duì)方(fāng)客(kè)气(qi)地(de)靠(kào)过(guò)来(lái)，其(qí)实(shí)打(dǎ)的(de)是(shì)坏(huài)主(zhǔ)意(yi)，就(jiù)说(shuō)黄(huáng)鼠(shǔ)狼(láng)给(gěi)鸡(jī)拜(bài)年(nián)。',
    category: '为人',
  ),
  Xiehouyu(
    id: 'xh30',
    front: '王(wáng)婆(pó)卖(mài)瓜(guā)',
    back: '自(zì)卖(mài)自(zì)夸(kuā)',
    meaning:
        '自(zì)己(jǐ)的(de)东(dōng)西(xi)自(zì)己(jǐ)夸(kuā)，总(zǒng)说(shuō)自(zì)家(jiā)的(de)最(zuì)好(hǎo)，就(jiù)叫(jiào)王(wáng)婆(pó)卖(mài)瓜(guā)。',
    category: '为人',
  ),
  Xiehouyu(
    id: 'xh31',
    front: '掩(yǎn)耳(ěr)盗(dào)铃(líng)',
    back: '自(zì)欺(qī)欺(qī)人(rén)',
    meaning:
        '明(míng)明(míng)骗(piàn)不(bù)了(liǎo)别(bié)人(rén)，还(hái)骗(piàn)自(zì)己(jǐ)说(shuō)没(méi)事(shì)，就(jiù)是(shì)掩(yǎn)耳(ěr)盗(dào)铃(líng)。',
    category: '为人',
  ),
  Xiehouyu(
    id: 'xh32',
    front: '井(jǐng)底(dǐ)的(de)蛙(wā)',
    back: '见(jiàn)识(shi)短(duǎn)',
    meaning:
        '没(méi)见(jiàn)过(guò)大(dà)世(shì)面(miàn)，眼(yǎn)光(guāng)窄(zhǎi)想(xiǎng)不(bù)远(yuǎn)，就(jiù)像(xiàng)井(jǐng)底(dǐ)的(de)蛙(wā)一(yí)样(yàng)。',
    category: '为人',
  ),
  Xiehouyu(
    id: 'xh33',
    front: '千(qiān)里(lǐ)送(sòng)鹅(é)毛(máo)',
    back: '礼(lǐ)轻(qīng)情(qíng)意(yì)重(zhòng)',
    meaning:
        '东(dōng)西(xi)不(bù)值(zhí)钱(qián)，可(kě)是(shì)一(yí)片(piàn)心(xīn)意(yi)真(zhēn)，就(jiù)说(shuō)千(qiān)里(lǐ)送(sòng)鹅(é)毛(máo)。',
    category: '为人',
  ),
  Xiehouyu(
    id: 'xh34',
    front: '门(mén)缝(fèng)里(lǐ)看(kàn)人(rén)',
    back: '把(bǎ)人(rén)看(kàn)扁(biǎn)了(le)',
    meaning:
        '小(xiǎo)看(kàn)了(le)别(bié)人(rén)，以(yǐ)为(wéi)人(rén)家(jia)不(bù)行(xíng)，其(qí)实(shí)人(rén)家(jia)有(yǒu)本(běn)事(shi)，就(jiù)叫(jiào)门(mén)缝(fèng)里(lǐ)看(kàn)人(rén)。',
    category: '为人',
  ),
  Xiehouyu(
    id: 'xh35',
    front: '老(lǎo)虎(hǔ)的(de)屁(pì)股(gu)',
    back: '摸(mō)不(bù)得(dé)',
    meaning:
        '这(zhè)人(rén)脾(pí)气(qi)大(dà)，惹(rě)不(bù)起(qǐ)，碰(pèng)不(bù)得(dé)，就(jiù)像(xiàng)老(lǎo)虎(hǔ)的(de)屁(pì)股(gu)。',
    category: '为人',
  ),
  Xiehouyu(
    id: 'xh36',
    front: '热(rè)锅(guō)上(shàng)的(de)蚂(mǎ)蚁(yǐ)',
    back: '团(tuán)团(tuán)转(zhuàn)',
    meaning:
        '心(xīn)里(lǐ)着(zháo)急(jí)又(yòu)没(méi)办(bàn)法(fǎ)，坐(zuò)也(yě)不(bù)安(ān)站(zhàn)也(yě)不(bù)安(ān)，就(jiù)像(xiàng)热(rè)锅(guō)上(shàng)的(de)蚂(mǎ)蚁(yǐ)。',
    category: '为人',
  ),
  Xiehouyu(
    id: 'xh37',
    front: '墙(qiáng)头(tóu)草(cǎo)',
    back: '两(liǎng)边(biān)倒(dǎo)',
    meaning:
        '谁(shuí)强(qiáng)就(jiù)跟(gēn)着(zhe)谁(shuí)，没(méi)主(zhǔ)见(jiàn)，风(fēng)往(wǎng)哪(nǎ)边(biān)吹(chuī)就(jiù)往(wǎng)哪(nǎ)边(biān)歪(wāi)，就(jiù)叫(jiào)墙(qiáng)头(tóu)草(cǎo)。',
    category: '为人',
  ),
  Xiehouyu(
    id: 'xh38',
    front: '过(guò)河(hé)拆(chāi)桥(qiáo)',
    back: '忘(wàng)恩(ēn)负(fù)义(yì)',
    meaning:
        '用(yòng)完(wán)别(bié)人(rén)就(jiù)翻(fān)脸(liǎn)不(bú)认(rèn)人(rén)，不(bú)记(jì)人(rén)家(jia)的(de)好(hǎo)，就(jiù)是(shì)过(guò)河(hé)拆(chāi)桥(qiáo)。',
    category: '为人',
  ),
  Xiehouyu(
    id: 'xh39',
    front: '狗(gǒu)拿(ná)耗(hào)子(zi)',
    back: '多(duō)管(guǎn)闲(xián)事(shì)',
    meaning:
        '不(bú)是(shì)自(zì)己(jǐ)的(de)事(shì)也(yě)去(qù)插(chā)手(shǒu)，管(guǎn)得(de)太(tài)宽(kuān)，就(jiù)叫(jiào)狗(gǒu)拿(ná)耗(hào)子(zi)。',
    category: '为人',
  ),
  Xiehouyu(
    id: 'xh40',
    front: '老(lǎo)鼠(shǔ)过(guò)街(jiē)',
    back: '人(rén)人(rén)喊(hǎn)打(dǎ)',
    meaning:
        '干(gàn)坏(huài)事(shì)的(de)人(rén)大(dà)家(jia)都(dōu)讨(tǎo)厌(yàn)，一(yí)见(jiàn)就(jiù)想(xiǎng)赶(gǎn)走(zǒu)他(tā)，就(jiù)像(xiàng)老(lǎo)鼠(shǔ)过(guò)街(jiē)。',
    category: '为人',
  ),
];

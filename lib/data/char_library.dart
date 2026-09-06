import 'char_card.dart';
export 'char_card.dart';

/// 晚晴识字 · 字库本体（V1.0 首批 60 字 = 20 课 × 3 字）。
///
/// 排序原则：**先给能立刻用上的字**（第 1 课就能组成「你好」「我好」），
/// 生活起居 → 衣食住行 → 出行社交 → 抽象常用。
/// 全部为成人生活刚需高频字，剔除「日月山水」式儿童抽象字。
///
/// 🔴 [CharCard.pinyin] 仅用于 `Text` 展示，**禁止**进入 TTS 调用链。
/// 🔴 [CharCard.picFile] 暂为 null（配图方案待拍板），UI 层按约定走文字卡兜底，
///    绝不显示空图位；拍板后只需把文件名填进来 + 放图到 `assets/images/chars/`。
///
/// 笔画数已与 `assets/strokes.json`（hanzi-writer-data）逐字核对一致。
const Map<String, CharCard> kCharLibrary = <String, CharCard>{
  // ---------------- 第 1 课 · 我 你 好 ----------------
  '我': CharCard(
    char: '我',
    pinyin: 'wǒ',
    meaning: '称自己',
    words: <String>['我们', '我的'],
    sentence: '我们回家。',
    picFile: 'wo.png',
    strokeNames: <String>['撇', '横', '竖钩', '提', '斜钩', '撇', '点'],
    lessonId: 1,
    category: '人称',
  ),
  '你': CharCard(
    char: '你',
    pinyin: 'nǐ',
    meaning: '称对方',
    words: <String>['你好', '你们'],
    sentence: '你好。',
    picFile: 'ni.png',
    strokeNames: <String>['撇', '竖', '撇', '横钩', '竖钩', '撇', '点'],
    lessonId: 1,
    category: '人称',
  ),
  '好': CharCard(
    char: '好',
    pinyin: 'hǎo',
    meaning: '不错，让人满意',
    words: <String>['你好', '好吃'],
    sentence: '好吃。',
    picFile: 'hao.png',
    strokeNames: <String>['撇点', '撇', '横', '横撇', '竖钩', '横'],
    lessonId: 1,
    category: '常用',
  ),

  // ---------------- 第 2 课 · 人 口 手 ----------------
  '人': CharCard(
    char: '人',
    pinyin: 'rén',
    meaning: '人类；别人',
    words: <String>['大人', '人们'],
    sentence: '家里有人。',
    picFile: 'ren.png',
    strokeNames: <String>['撇', '捺'],
    lessonId: 2,
    category: '身体',
  ),
  '口': CharCard(
    char: '口',
    pinyin: 'kǒu',
    meaning: '嘴巴；也作量词',
    words: <String>['人口', '开口'],
    sentence: '一家三口。',
    picFile: 'kou.png',
    strokeNames: <String>['竖', '横折', '横'],
    lessonId: 2,
    category: '身体',
  ),
  '手': CharCard(
    char: '手',
    pinyin: 'shǒu',
    meaning: '胳膊前端能拿东西的部分',
    words: <String>['手心', '手指'],
    sentence: '手洗干净了。',
    picFile: 'shou.png',
    strokeNames: <String>['撇', '横', '横', '竖钩'],
    lessonId: 2,
    category: '身体',
  ),

  // ---------------- 第 3 课 · 大 小 多 ----------------
  '大': CharCard(
    char: '大',
    pinyin: 'dà',
    meaning: '不小，超过一般',
    words: <String>['大人', '大门'],
    sentence: '这个瓜大。',
    picFile: 'da.png',
    strokeNames: <String>['横', '撇', '捺'],
    lessonId: 3,
    category: '常用',
  ),
  '小': CharCard(
    char: '小',
    pinyin: 'xiǎo',
    meaning: '不大',
    words: <String>['小孩', '小路'],
    sentence: '这只碗小。',
    picFile: 'xiao.png',
    strokeNames: <String>['竖钩', '撇', '点'],
    lessonId: 3,
    category: '常用',
  ),
  '多': CharCard(
    char: '多',
    pinyin: 'duō',
    meaning: '数量大',
    words: <String>['多少', '很多'],
    sentence: '人很多。',
    picFile: 'duo.png',
    strokeNames: <String>['撇', '横撇', '点', '撇', '横撇', '点'],
    lessonId: 3,
    category: '常用',
  ),

  // ---------------- 第 4 课 · 一 二 三 ----------------
  '一': CharCard(
    char: '一',
    pinyin: 'yī',
    meaning: '数字 1',
    words: <String>['一个', '第一'],
    sentence: '一个人。',
    picFile: 'yi.png',
    strokeNames: <String>['横'],
    lessonId: 4,
    category: '数字',
  ),
  '二': CharCard(
    char: '二',
    pinyin: 'èr',
    meaning: '数字 2',
    words: <String>['二月', '第二'],
    sentence: '二月初二。',
    picFile: 'er.png',
    strokeNames: <String>['横', '横'],
    lessonId: 4,
    category: '数字',
  ),
  '三': CharCard(
    char: '三',
    pinyin: 'sān',
    meaning: '数字 3',
    words: <String>['三个', '三月'],
    sentence: '三个人。',
    picFile: 'san.png',
    strokeNames: <String>['横', '横', '横'],
    lessonId: 4,
    category: '数字',
  ),

  // ---------------- 第 5 课 · 上 下 中 ----------------
  '上': CharCard(
    char: '上',
    pinyin: 'shàng',
    meaning: '位置在高处',
    words: <String>['上面', '上车'],
    sentence: '上车。',
    picFile: 'shang.png',
    strokeNames: <String>['竖', '横', '横'],
    lessonId: 5,
    category: '方位',
  ),
  '下': CharCard(
    char: '下',
    pinyin: 'xià',
    meaning: '位置在低处',
    words: <String>['下面', '下雨'],
    sentence: '下雨了。',
    picFile: 'xia.png',
    strokeNames: <String>['横', '竖', '点'],
    lessonId: 5,
    category: '方位',
  ),
  '中': CharCard(
    char: '中',
    pinyin: 'zhōng',
    meaning: '中间；也指中国',
    words: <String>['中间', '中午'],
    sentence: '中午。',
    picFile: 'zhong.png',
    strokeNames: <String>['竖', '横折', '横', '竖'],
    lessonId: 5,
    category: '方位',
  ),

  // ---------------- 第 6 课 · 天 日 月 ----------------
  '天': CharCard(
    char: '天',
    pinyin: 'tiān',
    meaning: '天空；也指一昼夜',
    words: <String>['今天', '天气'],
    sentence: '今天。',
    picFile: 'tian.png',
    strokeNames: <String>['横', '横', '撇', '捺'],
    lessonId: 6,
    category: '自然',
  ),
  '日': CharCard(
    char: '日',
    pinyin: 'rì',
    meaning: '太阳；也指日子',
    words: <String>['日子', '生日'],
    sentence: '好日子。',
    picFile: 'ri.png',
    strokeNames: <String>['竖', '横折', '横', '横'],
    lessonId: 6,
    category: '自然',
  ),
  '月': CharCard(
    char: '月',
    pinyin: 'yuè',
    meaning: '月亮；也指月份',
    words: <String>['月亮', '一月'],
    sentence: '一月。',
    picFile: 'yue.png',
    strokeNames: <String>['撇', '横折钩', '横', '横'],
    lessonId: 6,
    category: '自然',
  ),

  // ---------------- 第 7 课 · 家 门 开 ----------------
  '家': CharCard(
    char: '家',
    pinyin: 'jiā',
    meaning: '住的地方；也指一家人',
    words: <String>['回家', '家人'],
    sentence: '回家。',
    picFile: 'jia.png',
    strokeNames: <String>['点', '点', '横撇', '横', '撇', '弯钩', '撇', '撇', '撇', '捺'],
    lessonId: 7,
    category: '居家',
  ),
  '门': CharCard(
    char: '门',
    pinyin: 'mén',
    meaning: '房屋的出入口',
    words: <String>['大门', '开门'],
    sentence: '开门。',
    picFile: 'men.png',
    strokeNames: <String>['点', '竖', '横折钩'],
    lessonId: 7,
    category: '居家',
  ),
  '开': CharCard(
    char: '开',
    pinyin: 'kāi',
    meaning: '打开；使关闭的东西打开',
    words: <String>['开门', '开车'],
    sentence: '开门。',
    picFile: 'kai.png',
    strokeNames: <String>['横', '横', '撇', '竖'],
    lessonId: 7,
    category: '居家',
  ),

  // ---------------- 第 8 课 · 关 出 入 ----------------
  '关': CharCard(
    char: '关',
    pinyin: 'guān',
    meaning: '合上；使开着的东西闭上',
    words: <String>['关门', '关灯'],
    sentence: '关门。',
    picFile: 'guan.png',
    strokeNames: <String>['点', '撇', '横', '横', '撇', '捺'],
    lessonId: 8,
    category: '居家',
  ),
  '出': CharCard(
    char: '出',
    pinyin: 'chū',
    meaning: '从里到外',
    words: <String>['出门', '出去'],
    sentence: '出门。',
    picFile: 'chu.png',
    strokeNames: <String>['竖折', '竖', '竖', '竖折', '竖'],
    lessonId: 8,
    category: '动作',
  ),
  '入': CharCard(
    char: '入',
    pinyin: 'rù',
    meaning: '进来，进去',
    words: <String>['入口', '入门'],
    sentence: '入口。',
    picFile: 'ru.png',
    strokeNames: <String>['撇', '捺'],
    lessonId: 8,
    category: '动作',
  ),

  // ---------------- 第 9 课 · 来 去 回 ----------------
  '来': CharCard(
    char: '来',
    pinyin: 'lái',
    meaning: '从别处到这儿',
    words: <String>['回来', '来到'],
    sentence: '回来。',
    picFile: 'lai.png',
    strokeNames: <String>['横', '点', '撇', '横', '竖', '撇', '捺'],
    lessonId: 9,
    category: '动作',
  ),
  '去': CharCard(
    char: '去',
    pinyin: 'qù',
    meaning: '离开这里到别处',
    words: <String>['出去', '回去'],
    sentence: '出去。',
    picFile: 'qu.png',
    strokeNames: <String>['横', '竖', '横', '撇折', '点'],
    lessonId: 9,
    category: '动作',
  ),
  '回': CharCard(
    char: '回',
    pinyin: 'huí',
    meaning: '回来，回到原处',
    words: <String>['回家', '回来'],
    sentence: '回家。',
    picFile: 'hui.png',
    strokeNames: <String>['竖', '横折', '竖', '横折', '横', '横'],
    lessonId: 9,
    category: '动作',
  ),

  // ---------------- 第 10 课 · 吃 饭 水 ----------------
  '吃': CharCard(
    char: '吃',
    pinyin: 'chī',
    meaning: '把食物放进嘴里嚼咽',
    words: <String>['吃饭', '好吃'],
    sentence: '吃饭。',
    picFile: 'chi.png',
    strokeNames: <String>['竖', '横折', '横', '撇', '横', '横折弯钩'],
    lessonId: 10,
    category: '饮食',
  ),
  '饭': CharCard(
    char: '饭',
    pinyin: 'fàn',
    meaning: '煮熟的米面食物',
    words: <String>['米饭', '吃饭'],
    sentence: '吃饭。',
    picFile: 'fan.png',
    strokeNames: <String>['撇', '横撇', '竖提', '撇', '撇', '横撇', '捺'],
    lessonId: 10,
    category: '饮食',
  ),
  '水': CharCard(
    char: '水',
    pinyin: 'shuǐ',
    meaning: '无色无味的液体',
    words: <String>['喝水', '开水'],
    sentence: '喝水。',
    picFile: 'shui.png',
    strokeNames: <String>['竖钩', '横撇', '撇', '捺'],
    lessonId: 10,
    category: '饮食',
  ),

  // ---------------- 第 11 课 · 喝 米 面 ----------------
  '喝': CharCard(
    char: '喝',
    pinyin: 'hē',
    meaning: '把液体咽下去',
    words: <String>['喝水', '喝茶'],
    sentence: '喝水。',
    picFile: 'he.png',
    strokeNames: <String>[
      '竖', '横折', '横', '竖', '横折', '横', '横', '撇', '横折钩', '撇', '点', '竖折'
    ],
    lessonId: 11,
    category: '饮食',
  ),
  '米': CharCard(
    char: '米',
    pinyin: 'mǐ',
    meaning: '去了壳的谷粒',
    words: <String>['大米', '米饭'],
    sentence: '大米。',
    picFile: 'mi.png',
    strokeNames: <String>['点', '撇', '横', '竖', '撇', '捺'],
    lessonId: 11,
    category: '饮食',
  ),
  '面': CharCard(
    char: '面',
    pinyin: 'miàn',
    meaning: '面粉；也指面条',
    words: <String>['面条', '白面'],
    sentence: '面条。',
    picFile: 'mian.png',
    strokeNames: <String>['横', '撇', '竖', '横折钩', '竖', '横', '横', '横', '横'],
    lessonId: 11,
    category: '饮食',
  ),

  // ---------------- 第 12 课 · 菜 肉 汤 ----------------
  '菜': CharCard(
    char: '菜',
    pinyin: 'cài',
    meaning: '蔬菜；做好的副食',
    words: <String>['买菜', '白菜'],
    sentence: '买菜。',
    picFile: 'cai.png',
    strokeNames: <String>['横', '竖', '竖', '撇', '点', '点', '撇', '横', '竖', '撇', '捺'],
    lessonId: 12,
    category: '饮食',
  ),
  '肉': CharCard(
    char: '肉',
    pinyin: 'ròu',
    meaning: '动物的肉',
    words: <String>['猪肉', '吃肉'],
    sentence: '吃肉。',
    picFile: 'rou.png',
    strokeNames: <String>['竖', '横折钩', '撇', '点', '撇', '点'],
    lessonId: 12,
    category: '饮食',
  ),
  '汤': CharCard(
    char: '汤',
    pinyin: 'tāng',
    meaning: '有汁能喝的食品',
    words: <String>['喝汤', '米汤'],
    sentence: '喝汤。',
    picFile: 'tang.png',
    strokeNames: <String>['点', '点', '提', '横折折折钩', '撇', '撇'],
    lessonId: 12,
    category: '饮食',
  ),

  // ---------------- 第 13 课 · 碗 筷 锅 ----------------
  '碗': CharCard(
    char: '碗',
    pinyin: 'wǎn',
    meaning: '盛饭盛菜用的器具',
    words: <String>['饭碗', '一碗'],
    sentence: '一碗饭。',
    picFile: 'wan.png',
    strokeNames: <String>[
      '横', '撇', '竖', '横折', '横', '点', '点', '横撇', '撇', '横撇', '点', '横折钩', '竖弯钩'
    ],
    lessonId: 13,
    category: '餐具',
  ),
  '筷': CharCard(
    char: '筷',
    pinyin: 'kuài',
    meaning: '夹饭菜用的筷子',
    words: <String>['筷子', '碗筷'],
    sentence: '筷子。',
    picFile: 'kuai.png',
    strokeNames: <String>[
      '撇', '横', '点', '撇', '横', '点', '点', '点', '竖', '横折', '横', '撇', '捺'
    ],
    lessonId: 13,
    category: '餐具',
  ),
  '锅': CharCard(
    char: '锅',
    pinyin: 'guō',
    meaning: '做饭做菜用的器具',
    words: <String>['饭锅', '锅里'],
    sentence: '锅里。',
    picFile: 'guo.png',
    strokeNames: <String>[
      '撇', '横', '横', '横', '竖提', '竖', '横折', '横', '竖', '横折钩', '撇', '点'
    ],
    lessonId: 13,
    category: '餐具',
  ),

  // ---------------- 第 14 课 · 衣 鞋 帽 ----------------
  '衣': CharCard(
    char: '衣',
    pinyin: 'yī',
    meaning: '衣服',
    words: <String>['衣服', '上衣'],
    sentence: '衣服。',
    picFile: 'yi2.png',
    strokeNames: <String>['点', '横', '撇', '竖提', '撇', '捺'],
    lessonId: 14,
    category: '穿戴',
  ),
  '鞋': CharCard(
    char: '鞋',
    pinyin: 'xié',
    meaning: '穿在脚上走路用的',
    words: <String>['布鞋', '鞋子'],
    sentence: '鞋子。',
    picFile: 'xie.png',
    strokeNames: <String>[
      '横', '竖', '竖', '横', '竖', '横折', '横', '横', '竖', '横', '竖', '横', '横', '竖', '横'
    ],
    lessonId: 14,
    category: '穿戴',
  ),
  '帽': CharCard(
    char: '帽',
    pinyin: 'mào',
    meaning: '戴在头上保暖遮阳的',
    words: <String>['帽子', '草帽'],
    sentence: '帽子。',
    picFile: 'mao.png',
    strokeNames: <String>[
      '竖', '横折钩', '竖', '竖', '横折', '横', '横', '竖', '横折', '横', '横', '横'
    ],
    lessonId: 14,
    category: '穿戴',
  ),

  // ---------------- 第 15 课 · 洗 脸 牙 ----------------
  '洗': CharCard(
    char: '洗',
    pinyin: 'xǐ',
    meaning: '用水去掉脏东西',
    words: <String>['洗手', '洗脸'],
    sentence: '洗手。',
    picFile: 'xi.png',
    strokeNames: <String>['点', '点', '提', '撇', '横', '竖', '横', '撇', '竖弯钩'],
    lessonId: 15,
    category: '洗漱',
  ),
  '脸': CharCard(
    char: '脸',
    pinyin: 'liǎn',
    meaning: '头的前部，面孔',
    words: <String>['洗脸', '脸面'],
    sentence: '洗脸。',
    picFile: 'lian.png',
    strokeNames: <String>[
      '撇', '横折钩', '横', '横', '撇', '捺', '横', '点', '点', '撇', '横'
    ],
    lessonId: 15,
    category: '洗漱',
  ),
  '牙': CharCard(
    char: '牙',
    pinyin: 'yá',
    meaning: '嘴里嚼东西的牙齿',
    words: <String>['牙齿', '白牙'],
    sentence: '白牙。',
    picFile: 'ya.png',
    strokeNames: <String>['横', '竖折', '竖钩', '撇'],
    lessonId: 15,
    category: '洗漱',
  ),

  // ---------------- 第 16 课 · 睡 起 床 ----------------
  '睡': CharCard(
    char: '睡',
    pinyin: 'shuì',
    meaning: '闭眼休息',
    words: <String>['睡觉', '睡着'],
    sentence: '睡觉。',
    picFile: 'shui2.png',
    strokeNames: <String>[
      '竖', '横折', '横', '横', '横', '撇', '横', '竖', '横', '竖', '竖', '横', '横'
    ],
    lessonId: 16,
    category: '起居',
  ),
  '起': CharCard(
    char: '起',
    pinyin: 'qǐ',
    meaning: '由躺而坐、由坐而站',
    words: <String>['起床', '起来'],
    sentence: '起床。',
    picFile: 'qi.png',
    strokeNames: <String>[
      '横', '竖', '横', '竖', '横', '撇', '捺', '横折', '横', '竖弯钩'
    ],
    lessonId: 16,
    category: '起居',
  ),
  '床': CharCard(
    char: '床',
    pinyin: 'chuáng',
    meaning: '睡觉用的家具',
    words: <String>['起床', '床上'],
    sentence: '起床。',
    picFile: 'chuang.png',
    strokeNames: <String>['点', '横', '撇', '横', '竖', '撇', '捺'],
    lessonId: 16,
    category: '起居',
  ),

  // ---------------- 第 17 课 · 走 路 车 ----------------
  '走': CharCard(
    char: '走',
    pinyin: 'zǒu',
    meaning: '步行，脚向前移动',
    words: <String>['走路', '走开'],
    sentence: '走路。',
    picFile: 'zou.png',
    strokeNames: <String>['横', '竖', '横', '竖', '横', '撇', '捺'],
    lessonId: 17,
    category: '出行',
  ),
  '路': CharCard(
    char: '路',
    pinyin: 'lù',
    meaning: '供人车通行的道路',
    words: <String>['马路', '小路'],
    sentence: '马路。',
    picFile: 'lu.png',
    strokeNames: <String>[
      '竖', '横折', '横', '竖', '横', '撇', '捺', '撇', '横撇', '捺', '竖', '横折', '横'
    ],
    lessonId: 17,
    category: '出行',
  ),
  '车': CharCard(
    char: '车',
    pinyin: 'chē',
    meaning: '陆地上有轮子的交通工具',
    words: <String>['汽车', '上车'],
    sentence: '上车。',
    picFile: 'che.png',
    strokeNames: <String>['横', '撇折', '横', '竖'],
    lessonId: 17,
    category: '出行',
  ),

  // ---------------- 第 18 课 · 买 钱 给 ----------------
  '买': CharCard(
    char: '买',
    pinyin: 'mǎi',
    meaning: '用钱换东西',
    words: <String>['买菜', '买米'],
    sentence: '买菜。',
    picFile: 'mai.png',
    strokeNames: <String>['横撇', '点', '点', '横撇', '撇', '点'],
    lessonId: 18,
    category: '买卖',
  ),
  '钱': CharCard(
    char: '钱',
    pinyin: 'qián',
    meaning: '买东西用的货币',
    words: <String>['多少钱', '有钱'],
    sentence: '多少钱。',
    picFile: 'qian.png',
    strokeNames: <String>['撇', '横', '横', '横', '竖提', '横', '横', '斜钩', '撇', '点'],
    lessonId: 18,
    category: '买卖',
  ),
  '给': CharCard(
    char: '给',
    pinyin: 'gěi',
    meaning: '交付，使别人得到',
    words: <String>['给你', '给我'],
    sentence: '给你。',
    picFile: 'gei.png',
    strokeNames: <String>['撇折', '撇折', '提', '撇', '捺', '横', '竖', '横折', '横'],
    lessonId: 18,
    category: '买卖',
  ),

  // ---------------- 第 19 课 · 看 听 说 ----------------
  '看': CharCard(
    char: '看',
    pinyin: 'kàn',
    meaning: '用眼睛瞧',
    words: <String>['好看', '看书'],
    sentence: '好看。',
    picFile: 'kan.png',
    strokeNames: <String>['撇', '横', '横', '撇', '竖', '横折', '横', '横', '横'],
    lessonId: 19,
    category: '感知',
  ),
  '听': CharCard(
    char: '听',
    pinyin: 'tīng',
    meaning: '用耳朵接收声音',
    words: <String>['好听', '听话'],
    sentence: '好听。',
    picFile: 'ting.png',
    strokeNames: <String>['竖', '横折', '横', '撇', '撇', '横', '竖'],
    lessonId: 19,
    category: '感知',
  ),
  '说': CharCard(
    char: '说',
    pinyin: 'shuō',
    meaning: '用话表达意思',
    words: <String>['说话', '听说'],
    sentence: '说话。',
    picFile: 'shuo.png',
    strokeNames: <String>['点', '横折提', '点', '撇', '竖', '横折', '横', '撇', '竖弯钩'],
    lessonId: 19,
    category: '感知',
  ),

  // ---------------- 第 20 课 · 是 不 有 ----------------
  '是': CharCard(
    char: '是',
    pinyin: 'shì',
    meaning: '表示判断、肯定',
    words: <String>['是的', '不是'],
    sentence: '是的。',
    picFile: 'shi.png',
    strokeNames: <String>['竖', '横折', '横', '横', '横', '竖', '横', '撇', '捺'],
    lessonId: 20,
    category: '常用',
  ),
  '不': CharCard(
    char: '不',
    pinyin: 'bù',
    meaning: '表示否定',
    words: <String>['不是', '不要'],
    sentence: '不是。',
    picFile: 'bu.png',
    strokeNames: <String>['横', '撇', '竖', '点'],
    lessonId: 20,
    category: '常用',
  ),
  '有': CharCard(
    char: '有',
    pinyin: 'yǒu',
    meaning: '具有；存在',
    words: <String>['有人', '有钱'],
    sentence: '有人。',
    picFile: 'you.png',
    strokeNames: <String>['横', '撇', '竖', '横折钩', '横', '横'],
    lessonId: 20,
    category: '常用',
  ),

  // ============ 以下为 V1.7 扩字典：再添 40 课 × 3 字 = 120 字（总 180 字） ============
  // 面向「母亲已认得 90%、只是不会写」的实际情况，新增字偏向农村生活、家庭、自然、感官、
  // 方位、情绪等日常刚需字；单字不配图（用户明确：单字不必加图，现有 60 张图保留）。
  // 笔画名仅作「笔画顺序」辅助展示，描红范字走 Text 浅色字，不依赖此字段。

  // ---------------- 第 21 课 · 田 地 农 ----------------
  '田': CharCard(char: '田', pinyin: 'tián', meaning: '种庄稼的地', words: <String>['田地', '农田'], sentence: '田地。', strokeNames: <String>['竖', '横折', '横', '竖', '横'], lessonId: 21, category: '农事'),
  '地': CharCard(char: '地', pinyin: 'dì', meaning: '地面；土', words: <String>['土地', '地上'], sentence: '地上。', strokeNames: <String>['横', '竖', '提', '横折钩', '竖', '竖弯钩'], lessonId: 21, category: '农事'),
  '农': CharCard(char: '农', pinyin: 'nóng', meaning: '种地的活儿', words: <String>['农民', '农活'], sentence: '农民。', strokeNames: <String>['点', '横撇', '撇', '竖提', '撇', '捺'], lessonId: 21, category: '农事'),

  // ---------------- 第 22 课 · 牛 羊 鸡 ----------------
  '牛': CharCard(char: '牛', pinyin: 'niú', meaning: '耕田的牲畜', words: <String>['牛马', '水牛'], sentence: '水牛。', strokeNames: <String>['撇', '横', '横', '竖'], lessonId: 22, category: '家畜'),
  '羊': CharCard(char: '羊', pinyin: 'yáng', meaning: '吃草的牲畜', words: <String>['羊群', '山羊'], sentence: '山羊。', strokeNames: <String>['点', '撇', '横', '横', '横', '竖'], lessonId: 22, category: '家畜'),
  '鸡': CharCard(char: '鸡', pinyin: 'jī', meaning: '家禽，会下蛋', words: <String>['鸡蛋', '母鸡'], sentence: '母鸡。', strokeNames: <String>['横撇', '点', '撇', '横撇', '点', '竖', '横折', '横'], lessonId: 22, category: '家畜'),

  // ---------------- 第 23 课 · 狗 猫 鱼 ----------------
  '狗': CharCard(char: '狗', pinyin: 'gǒu', meaning: '看家的家畜', words: <String>['小狗', '狗叫'], sentence: '小狗。', strokeNames: <String>['撇', '弯钩', '撇', '撇', '横折钩', '竖', '横折', '横'], lessonId: 23, category: '家畜'),
  '猫': CharCard(char: '猫', pinyin: 'māo', meaning: '会抓老鼠的宠物', words: <String>['小猫', '花猫'], sentence: '花猫。', strokeNames: <String>['撇', '弯钩', '撇', '横', '竖', '竖', '竖', '横折', '横', '竖', '横', '横'], lessonId: 23, category: '家畜'),
  '鱼': CharCard(char: '鱼', pinyin: 'yú', meaning: '水里的动物', words: <String>['小鱼', '钓鱼'], sentence: '钓鱼。', strokeNames: <String>['撇', '横撇', '竖', '横折', '横', '竖', '横', '横'], lessonId: 23, category: '饮食'),

  // ---------------- 第 24 课 · 花 草 木 ----------------
  '花': CharCard(char: '花', pinyin: 'huā', meaning: '植物的花', words: <String>['花草', '开花'], sentence: '开花。', strokeNames: <String>['横', '竖', '竖', '撇', '竖', '撇', '竖弯钩'], lessonId: 24, category: '植物'),
  '草': CharCard(char: '草', pinyin: 'cǎo', meaning: '野生的草', words: <String>['草地', '小草'], sentence: '小草。', strokeNames: <String>['横', '竖', '竖', '竖', '横折', '横', '横', '横', '竖'], lessonId: 24, category: '植物'),
  '木': CharCard(char: '木', pinyin: 'mù', meaning: '树；木头', words: <String>['木头', '树木'], sentence: '树木。', strokeNames: <String>['横', '竖', '撇', '捺'], lessonId: 24, category: '植物'),

  // ---------------- 第 25 课 · 风 雨 雪 ----------------
  '风': CharCard(char: '风', pinyin: 'fēng', meaning: '空气流动', words: <String>['大风', '风筝'], sentence: '大风。', strokeNames: <String>['撇', '横折弯钩', '撇', '点'], lessonId: 25, category: '自然'),
  '雨': CharCard(char: '雨', pinyin: 'yǔ', meaning: '从云落下的水', words: <String>['下雨', '雨水'], sentence: '下雨。', strokeNames: <String>['横', '竖', '横折钩', '竖', '点', '点', '点', '点'], lessonId: 25, category: '自然'),
  '雪': CharCard(char: '雪', pinyin: 'xuě', meaning: '天上落的白花', words: <String>['下雪', '雪花'], sentence: '下雪。', strokeNames: <String>['横', '竖', '横折钩', '竖', '点', '点', '点', '点', '横折', '横', '横'], lessonId: 25, category: '自然'),

  // ---------------- 第 26 课 · 云 电 光 ----------------
  '云': CharCard(char: '云', pinyin: 'yún', meaning: '天上的水汽', words: <String>['白云', '云彩'], sentence: '白云。', strokeNames: <String>['横', '横', '撇折', '点'], lessonId: 26, category: '自然'),
  '电': CharCard(char: '电', pinyin: 'diàn', meaning: '一种能量', words: <String>['电灯', '电话'], sentence: '电灯。', strokeNames: <String>['竖', '横折', '横', '横', '竖弯钩'], lessonId: 26, category: '自然'),
  '光': CharCard(char: '光', pinyin: 'guāng', meaning: '亮；照明', words: <String>['阳光', '灯光'], sentence: '阳光。', strokeNames: <String>['竖', '点', '撇', '横', '撇', '竖弯钩'], lessonId: 26, category: '自然'),

  // ---------------- 第 27 课 · 春 夏 秋 ----------------
  '春': CharCard(char: '春', pinyin: 'chūn', meaning: '一年开头', words: <String>['春天', '春节'], sentence: '春天。', strokeNames: <String>['横', '横', '横', '撇', '捺', '竖', '横折', '横', '横'], lessonId: 27, category: '季节'),
  '夏': CharCard(char: '夏', pinyin: 'xià', meaning: '热天', words: <String>['夏天', '夏季'], sentence: '夏天。', strokeNames: <String>['横', '撇', '竖', '横折', '横', '横', '横', '撇', '横撇', '捺'], lessonId: 27, category: '季节'),
  '秋': CharCard(char: '秋', pinyin: 'qiū', meaning: '收庄稼的季节', words: <String>['秋天', '秋风'], sentence: '秋天。', strokeNames: <String>['撇', '横', '竖', '撇', '点', '点', '撇', '撇', '捺'], lessonId: 27, category: '季节'),

  // ---------------- 第 28 课 · 冬 年 岁 ----------------
  '冬': CharCard(char: '冬', pinyin: 'dōng', meaning: '冷天', words: <String>['冬天', '过冬'], sentence: '冬天。', strokeNames: <String>['撇', '横撇', '捺', '点', '点'], lessonId: 28, category: '季节'),
  '年': CharCard(char: '年', pinyin: 'nián', meaning: '地球绕日一周', words: <String>['过年', '年头'], sentence: '过年。', strokeNames: <String>['撇', '横', '横', '竖', '横', '竖'], lessonId: 28, category: '时间'),
  '岁': CharCard(char: '岁', pinyin: 'suì', meaning: '年龄单位', words: <String>['岁数', '几岁'], sentence: '几岁。', strokeNames: <String>['竖', '竖折', '竖', '撇', '横撇', '点'], lessonId: 28, category: '时间'),

  // ---------------- 第 29 课 · 早 晚 夜 ----------------
  '早': CharCard(char: '早', pinyin: 'zǎo', meaning: '清早', words: <String>['早上', '早饭'], sentence: '早上。', strokeNames: <String>['竖', '横折', '横', '横', '竖', '横'], lessonId: 29, category: '时间'),
  '晚': CharCard(char: '晚', pinyin: 'wǎn', meaning: '日落以后', words: <String>['晚上', '晚饭'], sentence: '晚上。', strokeNames: <String>['竖', '横折', '横', '横', '撇', '横撇', '竖', '横折', '横', '横', '撇', '竖弯钩'], lessonId: 29, category: '时间'),
  '夜': CharCard(char: '夜', pinyin: 'yè', meaning: '从天黑到天亮', words: <String>['夜里', '半夜'], sentence: '夜里。', strokeNames: <String>['点', '横', '撇', '竖', '横撇', '横撇', '捺', '点', '点', '横', '撇', '捺'], lessonId: 29, category: '时间'),

  // ---------------- 第 30 课 · 热 冷 暖 ----------------
  '热': CharCard(char: '热', pinyin: 'rè', meaning: '温度高', words: <String>['热天', '热水'], sentence: '热水。', strokeNames: <String>['横', '竖', '横', '竖', '横折', '横', '竖', '横折', '横', '点', '点', '点', '点', '点'], lessonId: 30, category: '温度'),
  '冷': CharCard(char: '冷', pinyin: 'lěng', meaning: '温度低', words: <String>['冷水', '天冷'], sentence: '天冷。', strokeNames: <String>['撇', '点', '提', '撇', '捺', '点', '横撇', '点'], lessonId: 30, category: '温度'),
  '暖': CharCard(char: '暖', pinyin: 'nuǎn', meaning: '不冷', words: <String>['暖和', '温暖'], sentence: '暖和。', strokeNames: <String>['竖', '横折', '横', '横', '撇', '点', '点', '撇', '横', '横', '撇', '捺'], lessonId: 30, category: '温度'),

  // ---------------- 第 31 课 · 红 绿 黄 ----------------
  '红': CharCard(char: '红', pinyin: 'hóng', meaning: '一种颜色', words: <String>['红色', '红花'], sentence: '红色。', strokeNames: <String>['撇折', '撇折', '提', '横', '竖', '横'], lessonId: 31, category: '颜色'),
  '绿': CharCard(char: '绿', pinyin: 'lǜ', meaning: '草和叶的颜色', words: <String>['绿色', '绿叶'], sentence: '绿色。', strokeNames: <String>['撇折', '撇折', '提', '横折', '横', '横', '竖', '点', '横', '竖', '撇', '捺'], lessonId: 31, category: '颜色'),
  '黄': CharCard(char: '黄', pinyin: 'huáng', meaning: '一种颜色', words: <String>['黄色', '黄河'], sentence: '黄色。', strokeNames: <String>['横', '竖', '竖', '横', '竖', '横折', '横', '竖', '横', '撇', '点'], lessonId: 31, category: '颜色'),

  // ---------------- 第 32 课 · 蓝 白 黑 ----------------
  '蓝': CharCard(char: '蓝', pinyin: 'lán', meaning: '天和海的颜色', words: <String>['蓝色', '蓝天'], sentence: '蓝色。', strokeNames: <String>['横', '竖', '竖', '竖', '竖', '撇', '横', '点', '竖', '横折', '竖', '竖', '横'], lessonId: 32, category: '颜色'),
  '白': CharCard(char: '白', pinyin: 'bái', meaning: '雪的颜色', words: <String>['白色', '白天'], sentence: '白天。', strokeNames: <String>['撇', '竖', '横折', '横', '横'], lessonId: 32, category: '颜色'),
  '黑': CharCard(char: '黑', pinyin: 'hēi', meaning: '墨的颜色', words: <String>['黑色', '天黑'], sentence: '天黑。', strokeNames: <String>['竖', '横折', '点', '撇', '横', '竖', '横', '横', '点', '点', '点', '点', '点'], lessonId: 32, category: '颜色'),

  // ---------------- 第 33 课 · 香 甜 苦 ----------------
  '香': CharCard(char: '香', pinyin: 'xiāng', meaning: '好闻的气味', words: <String>['香味', '花香'], sentence: '花香。', strokeNames: <String>['撇', '横', '竖', '撇', '捺', '竖', '横折', '横', '横'], lessonId: 33, category: '味觉'),
  '甜': CharCard(char: '甜', pinyin: 'tián', meaning: '像糖的味道', words: <String>['甜味', '甜瓜'], sentence: '甜瓜。', strokeNames: <String>['撇', '横', '竖', '竖', '横折', '横', '竖', '横', '横', '竖', '竖', '横', '横'], lessonId: 33, category: '味觉'),
  '苦': CharCard(char: '苦', pinyin: 'kǔ', meaning: '像药的味道', words: <String>['苦药', '辛苦'], sentence: '辛苦。', strokeNames: <String>['横', '竖', '竖', '横', '竖', '竖', '横折', '横'], lessonId: 33, category: '味觉'),

  // ---------------- 第 34 课 · 酸 咸 淡 ----------------
  '酸': CharCard(char: '酸', pinyin: 'suān', meaning: '像醋的味道', words: <String>['酸味', '酸甜'], sentence: '酸甜。', strokeNames: <String>['横', '竖', '横折', '撇', '竖折', '横', '横', '撇折', '点', '撇', '捺', '横', '竖', '横折', '横'], lessonId: 34, category: '味觉'),
  '咸': CharCard(char: '咸', pinyin: 'xián', meaning: '像盐的味道', words: <String>['咸菜', '咸蛋'], sentence: '咸菜。', strokeNames: <String>['横', '撇', '横', '竖', '横折', '横', '斜钩', '撇', '点'], lessonId: 34, category: '味觉'),
  '淡': CharCard(char: '淡', pinyin: 'dàn', meaning: '味道薄', words: <String>['清淡', '淡水'], sentence: '清淡。', strokeNames: <String>['点', '点', '提', '点', '撇', '撇', '点', '点', '横', '撇', '捺'], lessonId: 34, category: '味觉'),

  // ---------------- 第 35 课 · 轻 重 快 ----------------
  '轻': CharCard(char: '轻', pinyin: 'qīng', meaning: '分量小', words: <String>['轻轻', '轻重'], sentence: '轻轻。', strokeNames: <String>['横', '撇折', '竖', '提', '横折', '横', '横', '竖', '提', '点', '横', '竖', '横'], lessonId: 35, category: '形容'),
  '重': CharCard(char: '重', pinyin: 'zhòng', meaning: '分量大', words: <String>['轻重', '重要'], sentence: '重要。', strokeNames: <String>['撇', '横', '竖', '横折', '横', '横', '竖', '横', '横'], lessonId: 35, category: '形容'),
  '快': CharCard(char: '快', pinyin: 'kuài', meaning: '速度高', words: <String>['快慢', '快点'], sentence: '快点。', strokeNames: <String>['点', '点', '提', '横折', '横', '撇', '捺'], lessonId: 35, category: '形容'),

  // ---------------- 第 36 课 · 慢 远 近 ----------------
  '慢': CharCard(char: '慢', pinyin: 'màn', meaning: '速度低', words: <String>['快慢', '慢点'], sentence: '慢点。', strokeNames: <String>['点', '点', '提', '竖', '横折', '横', '横', '横', '竖', '横折', '横', '横', '竖', '横折', '撇', '点'], lessonId: 36, category: '形容'),
  '远': CharCard(char: '远', pinyin: 'yuǎn', meaning: '距离长', words: <String>['远近', '远处'], sentence: '远处。', strokeNames: <String>['横', '横', '撇', '竖折', '点', '横折折撇', '捺'], lessonId: 36, category: '方位'),
  '近': CharCard(char: '近', pinyin: 'jìn', meaning: '距离短', words: <String>['远近', '近处'], sentence: '近处。', strokeNames: <String>['撇', '竖', '横折', '横', '竖', '点', '横折折撇', '捺'], lessonId: 36, category: '方位'),

  // ---------------- 第 37 课 · 高 矮 胖 ----------------
  '高': CharCard(char: '高', pinyin: 'gāo', meaning: '上下距离大', words: <String>['高低', '高兴'], sentence: '高兴。', strokeNames: <String>['点', '横', '竖', '横折', '横', '竖', '横折', '横', '竖', '横折', '横'], lessonId: 37, category: '形容'),
  '矮': CharCard(char: '矮', pinyin: 'ǎi', meaning: '不高', words: <String>['高矮', '矮小'], sentence: '矮小。', strokeNames: <String>['撇', '横', '竖', '撇', '点', '撇', '横', '竖', '撇', '捺', '横', '竖', '横', '横', '横'], lessonId: 37, category: '形容'),
  '胖': CharCard(char: '胖', pinyin: 'pàng', meaning: '肉多', words: <String>['胖瘦', '胖子'], sentence: '胖子。', strokeNames: <String>['撇', '横折钩', '横', '横', '竖', '横', '横', '竖'], lessonId: 37, category: '形容'),

  // ---------------- 第 38 课 · 瘦 老 少 ----------------
  '瘦': CharCard(char: '瘦', pinyin: 'shòu', meaning: '肉少', words: <String>['瘦小', '瘦了'], sentence: '瘦了。', strokeNames: <String>['撇', '横折钩', '横', '横', '撇', '竖', '横', '横', '横', '竖', '点', '横', '竖', '横折', '横', '横', '撇', '捺'], lessonId: 38, category: '形容'),
  '老': CharCard(char: '老', pinyin: 'lǎo', meaning: '年岁大', words: <String>['老人', '老伴'], sentence: '老人。', strokeNames: <String>['横', '竖', '横', '撇', '撇', '竖弯钩'], lessonId: 38, category: '人称'),
  '少': CharCard(char: '少', pinyin: 'shǎo', meaning: '数量小', words: <String>['多少', '老少'], sentence: '多少。', strokeNames: <String>['竖', '撇', '点', '撇'], lessonId: 38, category: '形容'),

  // ---------------- 第 39 课 · 男 女 孩 ----------------
  '男': CharCard(char: '男', pinyin: 'nán', meaning: '男人', words: <String>['男人', '男孩'], sentence: '男孩。', strokeNames: <String>['竖', '横折', '横', '竖', '横', '横', '横折钩', '撇'], lessonId: 39, category: '人称'),
  '女': CharCard(char: '女', pinyin: 'nǚ', meaning: '女人', words: <String>['女人', '女孩'], sentence: '女孩。', strokeNames: <String>['撇点', '撇', '横'], lessonId: 39, category: '人称'),
  '孩': CharCard(char: '孩', pinyin: 'hái', meaning: '小孩', words: <String>['小孩', '男孩'], sentence: '小孩。', strokeNames: <String>['横撇', '竖钩', '横', '点', '横', '撇', '撇', '点', '点'], lessonId: 39, category: '人称'),

  // ---------------- 第 40 课 · 哥 弟 姐 ----------------
  '哥': CharCard(char: '哥', pinyin: 'gē', meaning: '兄长', words: <String>['哥哥', '大哥'], sentence: '大哥。', strokeNames: <String>['横', '竖', '横折', '横', '竖钩', '横', '竖', '横折', '横', '竖钩'], lessonId: 40, category: '亲属'),
  '弟': CharCard(char: '弟', pinyin: 'dì', meaning: '同辈年幼男子', words: <String>['弟弟', '兄弟'], sentence: '兄弟。', strokeNames: <String>['点', '撇', '横折', '横', '竖', '撇', '横折弯钩', '竖', '竖弯钩'], lessonId: 40, category: '亲属'),
  '姐': CharCard(char: '姐', pinyin: 'jiě', meaning: '同辈年长女子', words: <String>['姐姐', '大姐'], sentence: '大姐。', strokeNames: <String>['撇点', '撇', '横', '竖', '横折', '横', '横', '横'], lessonId: 40, category: '亲属'),

  // ---------------- 第 41 课 · 妹 父 母 ----------------
  '妹': CharCard(char: '妹', pinyin: 'mèi', meaning: '同辈年幼女子', words: <String>['妹妹', '姐妹'], sentence: '姐妹。', strokeNames: <String>['撇点', '撇', '横', '横', '横', '竖', '撇', '捺'], lessonId: 41, category: '亲属'),
  '父': CharCard(char: '父', pinyin: 'fù', meaning: '爸爸', words: <String>['父母', '父亲'], sentence: '父亲。', strokeNames: <String>['撇', '点', '撇', '捺'], lessonId: 41, category: '亲属'),
  '母': CharCard(char: '母', pinyin: 'mǔ', meaning: '妈妈', words: <String>['父母', '母亲'], sentence: '母亲。', strokeNames: <String>['竖折', '横折钩', '点', '横', '点', '横'], lessonId: 41, category: '亲属'),

  // ---------------- 第 42 课 · 爷 奶 公 ----------------
  '爷': CharCard(char: '爷', pinyin: 'yé', meaning: '父亲的父亲', words: <String>['爷爷', '老爷'], sentence: '爷爷。', strokeNames: <String>['撇', '捺', '撇', '点', '横折钩', '竖'], lessonId: 42, category: '亲属'),
  '奶': CharCard(char: '奶', pinyin: 'nǎi', meaning: '父亲的母亲', words: <String>['奶奶', '牛奶'], sentence: '奶奶。', strokeNames: <String>['撇点', '撇', '横折折折钩', '撇'], lessonId: 42, category: '亲属'),
  '公': CharCard(char: '公', pinyin: 'gōng', meaning: '丈夫的父亲；也指男性', words: <String>['公公', '公平'], sentence: '公平。', strokeNames: <String>['撇', '捺', '撇折', '点'], lessonId: 42, category: '亲属'),

  // ---------------- 第 43 课 · 婆 夫 妻 ----------------
  '婆': CharCard(char: '婆', pinyin: 'pó', meaning: '丈夫的母亲', words: <String>['婆婆', '外婆'], sentence: '外婆。', strokeNames: <String>['点', '点', '横撇', '竖', '横折', '横', '竖', '横折', '横', '竖', '横折', '横', '撇点', '撇', '横'], lessonId: 43, category: '亲属'),
  '夫': CharCard(char: '夫', pinyin: 'fū', meaning: '男人；丈夫', words: <String>['夫妇', '夫妻'], sentence: '夫妻。', strokeNames: <String>['横', '横', '撇', '捺'], lessonId: 43, category: '亲属'),
  '妻': CharCard(char: '妻', pinyin: 'qī', meaning: '女人；妻子', words: <String>['夫妻', '妻子'], sentence: '妻子。', strokeNames: <String>['横', '横', '横', '竖', '横折', '撇', '横', '横', '竖'], lessonId: 43, category: '亲属'),

  // ---------------- 第 44 课 · 前 后 左 ----------------
  '前': CharCard(char: '前', pinyin: 'qián', meaning: '面对的方向', words: <String>['前后', '前面'], sentence: '前面。', strokeNames: <String>['点', '撇', '横', '竖', '竖', '横折', '横', '竖', '横折', '横', '横', '竖', '竖'], lessonId: 44, category: '方位'),
  '后': CharCard(char: '后', pinyin: 'hòu', meaning: '背对的方向', words: <String>['前后', '后面'], sentence: '后面。', strokeNames: <String>['撇', '撇', '横', '竖', '横折', '横'], lessonId: 44, category: '方位'),
  '左': CharCard(char: '左', pinyin: 'zuǒ', meaning: '面向南时的东边', words: <String>['左右', '左边'], sentence: '左边。', strokeNames: <String>['横', '撇', '横', '竖', '横'], lessonId: 44, category: '方位'),

  // ---------------- 第 45 课 · 右 东 西 ----------------
  '右': CharCard(char: '右', pinyin: 'yòu', meaning: '面向南时的西边', words: <String>['左右', '右边'], sentence: '右边。', strokeNames: <String>['横', '撇', '竖', '横折', '横'], lessonId: 45, category: '方位'),
  '东': CharCard(char: '东', pinyin: 'dōng', meaning: '太阳升起的方向', words: <String>['东西', '东方'], sentence: '东方。', strokeNames: <String>['横', '撇折', '竖钩', '撇', '点'], lessonId: 45, category: '方位'),
  '西': CharCard(char: '西', pinyin: 'xī', meaning: '太阳落下的方向', words: <String>['东西', '西方'], sentence: '西方。', strokeNames: <String>['横', '竖', '横折', '撇', '横折', '横', '横', '横'], lessonId: 45, category: '方位'),

  // ---------------- 第 46 课 · 南 北 里 ----------------
  '南': CharCard(char: '南', pinyin: 'nán', meaning: '方向之一', words: <String>['南北', '南方'], sentence: '南方。', strokeNames: <String>['横', '竖', '竖', '横折', '点', '撇', '横', '横', '竖', '横折', '竖', '竖', '横折', '横', '横', '横'], lessonId: 46, category: '方位'),
  '北': CharCard(char: '北', pinyin: 'běi', meaning: '方向之一', words: <String>['南北', '北方'], sentence: '北方。', strokeNames: <String>['竖', '横', '提', '撇', '竖弯钩'], lessonId: 46, category: '方位'),
  '里': CharCard(char: '里', pinyin: 'lǐ', meaning: '内部；长度单位', words: <String>['里外', '里面'], sentence: '里面。', strokeNames: <String>['竖', '横折', '横', '横', '竖', '横', '横'], lessonId: 46, category: '方位'),

  // ---------------- 第 47 课 · 外 旁 间 ----------------
  '外': CharCard(char: '外', pinyin: 'wài', meaning: '外边', words: <String>['里外', '外面'], sentence: '外面。', strokeNames: <String>['撇', '横撇', '点', '竖', '点'], lessonId: 47, category: '方位'),
  '旁': CharCard(char: '旁', pinyin: 'páng', meaning: '边侧', words: <String>['旁边', '路旁'], sentence: '旁边。', strokeNames: <String>['点', '横', '点', '撇', '点', '横撇', '点', '横', '横', '竖', '横折', '横'], lessonId: 47, category: '方位'),
  '间': CharCard(char: '间', pinyin: 'jiān', meaning: '中间', words: <String>['中间', '房间'], sentence: '中间。', strokeNames: <String>['点', '竖', '横折钩', '竖', '横折', '横', '横'], lessonId: 47, category: '方位'),

  // ---------------- 第 48 课 · 顶 底 头 ----------------
  '顶': CharCard(char: '顶', pinyin: 'dǐng', meaning: '最高最上的部分', words: <String>['头顶', '山顶'], sentence: '头顶。', strokeNames: <String>['横', '竖钩', '横', '撇', '竖', '横折', '撇', '点'], lessonId: 48, category: '身体'),
  '底': CharCard(char: '底', pinyin: 'dǐ', meaning: '最下的部分', words: <String>['海底', '底下'], sentence: '底下。', strokeNames: <String>['点', '横', '撇', '撇', '竖提', '横', '竖', '横折', '横', '点', '撇', '横撇', '捺'], lessonId: 48, category: '身体'),
  '头': CharCard(char: '头', pinyin: 'tóu', meaning: '人身最上部分', words: <String>['头发', '头顶'], sentence: '头发。', strokeNames: <String>['点', '点', '横', '撇', '点'], lessonId: 48, category: '身体'),

  // ---------------- 第 49 课 · 脚 眼 耳 ----------------
  '脚': CharCard(char: '脚', pinyin: 'jiǎo', meaning: '腿的下端', words: <String>['脚丫', '手脚'], sentence: '手脚。', strokeNames: <String>['撇', '横折钩', '横', '横', '横', '竖', '横', '竖', '横折', '横', '竖', '竖钩'], lessonId: 49, category: '身体'),
  '眼': CharCard(char: '眼', pinyin: 'yǎn', meaning: '看东西的器官', words: <String>['眼睛', '眼泪'], sentence: '眼睛。', strokeNames: <String>['竖', '横折', '横', '横', '横', '撇折', '横', '横', '竖提', '撇', '捺'], lessonId: 49, category: '身体'),
  '耳': CharCard(char: '耳', pinyin: 'ěr', meaning: '听声音的器官', words: <String>['耳朵', '耳机'], sentence: '耳朵。', strokeNames: <String>['横', '竖', '竖', '横', '横', '横'], lessonId: 49, category: '身体'),

  // ---------------- 第 50 课 · 鼻 舌 心 ----------------
  '鼻': CharCard(char: '鼻', pinyin: 'bí', meaning: '闻气味的器官', words: <String>['鼻子', '鼻涕'], sentence: '鼻子。', strokeNames: <String>['撇', '竖', '横折', '横', '横', '横', '竖', '横折', '横', '竖', '横', '横', '撇', '竖', '横折', '撇', '竖弯钩', '横', '竖'], lessonId: 50, category: '身体'),
  '舌': CharCard(char: '舌', pinyin: 'shé', meaning: '尝味道的器官', words: <String>['舌头', '舌尖'], sentence: '舌头。', strokeNames: <String>['撇', '横', '竖', '竖', '横折', '横'], lessonId: 50, category: '身体'),
  '心': CharCard(char: '心', pinyin: 'xīn', meaning: '管血的内脏', words: <String>['心里', '开心'], sentence: '开心。', strokeNames: <String>['点', '卧钩', '点', '点'], lessonId: 50, category: '身体'),

  // ---------------- 第 51 课 · 肚 背 皮 ----------------
  '肚': CharCard(char: '肚', pinyin: 'dù', meaning: '腹部的统称', words: <String>['肚子', '肚皮'], sentence: '肚子。', strokeNames: <String>['撇', '横折钩', '横', '横', '横', '竖', '横折', '横'], lessonId: 51, category: '身体'),
  '背': CharCard(char: '背', pinyin: 'bèi', meaning: '胸的后部', words: <String>['背后', '背书'], sentence: '背后。', strokeNames: <String>['竖', '横', '提', '撇', '竖弯钩', '撇', '横折钩', '横', '横'], lessonId: 51, category: '身体'),
  '皮': CharCard(char: '皮', pinyin: 'pí', meaning: '身体表面', words: <String>['皮肉', '树皮'], sentence: '树皮。', strokeNames: <String>['横撇', '竖', '横撇', '竖', '横撇', '捺'], lessonId: 51, category: '身体'),

  // ---------------- 第 52 课 · 毛 血 汗 ----------------
  '毛': CharCard(char: '毛', pinyin: 'máo', meaning: '身上的细丝', words: <String>['毛衣', '毛发'], sentence: '毛衣。', strokeNames: <String>['撇', '横', '横', '竖弯钩'], lessonId: 52, category: '身体'),
  '血': CharCard(char: '血', pinyin: 'xiě', meaning: '红色液体', words: <String>['血汗', '流血'], sentence: '流血。', strokeNames: <String>['撇', '竖', '横折', '竖', '竖', '横'], lessonId: 52, category: '身体'),
  '汗': CharCard(char: '汗', pinyin: 'hàn', meaning: '皮排出的水', words: <String>['汗水', '出汗'], sentence: '出汗。', strokeNames: <String>['点', '点', '提', '点', '点', '横', '竖'], lessonId: 52, category: '身体'),

  // ---------------- 第 53 课 · 病 痛 药 ----------------
  '病': CharCard(char: '病', pinyin: 'bìng', meaning: '身体不适', words: <String>['生病', '病人'], sentence: '生病。', strokeNames: <String>['点', '横', '撇', '点', '横', '撇', '捺', '横', '竖', '横折', '横', '竖', '竖', '横折', '横'], lessonId: 53, category: '健康'),
  '痛': CharCard(char: '痛', pinyin: 'tòng', meaning: '身体难受', words: <String>['头痛', '病痛'], sentence: '头痛。', strokeNames: <String>['点', '横', '撇', '点', '横撇', '捺', '横', '竖', '横折', '横', '竖', '竖', '横折', '横'], lessonId: 53, category: '健康'),
  '药': CharCard(char: '药', pinyin: 'yào', meaning: '治病的东西', words: <String>['吃药', '药店'], sentence: '吃药。', strokeNames: <String>['横', '竖', '竖', '撇折', '横折', '点', '撇', '横折钩', '点'], lessonId: 53, category: '健康'),

  // ---------------- 第 54 课 · 针 死 活 ----------------
  '针': CharCard(char: '针', pinyin: 'zhēn', meaning: '治病扎穴的工具', words: <String>['打针', '针线'], sentence: '打针。', strokeNames: <String>['撇', '横', '横', '横', '竖提', '横', '竖'], lessonId: 54, category: '健康'),
  '死': CharCard(char: '死', pinyin: 'sǐ', meaning: '生命停止', words: <String>['死活', '死了'], sentence: '死了。', strokeNames: <String>['横', '撇', '横撇', '点', '撇', '横撇', '点'], lessonId: 54, category: '状态'),
  '活': CharCard(char: '活', pinyin: 'huó', meaning: '有生命', words: <String>['活人', '生活'], sentence: '生活。', strokeNames: <String>['点', '点', '提', '撇', '横', '竖', '竖', '横折', '横'], lessonId: 54, category: '状态'),

  // ---------------- 第 55 课 · 生 养 教 ----------------
  '生': CharCard(char: '生', pinyin: 'shēng', meaning: '长出来；活着', words: <String>['生活', '生气'], sentence: '生活。', strokeNames: <String>['撇', '横', '横', '竖', '横'], lessonId: 55, category: '状态'),
  '养': CharCard(char: '养', pinyin: 'yǎng', meaning: '照料长大', words: <String>['养大', '收养'], sentence: '收养。', strokeNames: <String>['点', '撇', '横', '横', '横', '撇', '捺', '竖', '横折', '横', '竖', '横折', '横', '横', '横'], lessonId: 55, category: '状态'),
  '教': CharCard(char: '教', pinyin: 'jiāo', meaning: '把知识给人', words: <String>['教书', '教人'], sentence: '教人。', strokeNames: <String>['横', '竖', '横', '撇', '横撇', '竖', '横折', '横', '点', '横', '撇', '横', '竖', '横折', '横', '竖弯钩'], lessonId: 55, category: '学习'),

  // ---------------- 第 56 课 · 学 问 答 ----------------
  '学': CharCard(char: '学', pinyin: 'xué', meaning: '读书识字', words: <String>['学习', '学生'], sentence: '学习。', strokeNames: <String>['点', '点', '撇', '点', '横撇', '横', '竖', '横折', '横'], lessonId: 56, category: '学习'),
  '问': CharCard(char: '问', pinyin: 'wèn', meaning: '请人解答', words: <String>['问题', '问好'], sentence: '问好。', strokeNames: <String>['点', '竖', '横折钩', '竖', '横折', '横', '横'], lessonId: 56, category: '学习'),
  '答': CharCard(char: '答', pinyin: 'dá', meaning: '回话', words: <String>['回答', '答应'], sentence: '回答。', strokeNames: <String>['撇', '横', '点', '撇', '横', '点', '撇', '捺', '横', '竖', '横折', '横'], lessonId: 56, category: '学习'),

  // ---------------- 第 57 课 · 想 知 忘 ----------------
  '想': CharCard(char: '想', pinyin: 'xiǎng', meaning: '动脑筋', words: <String>['想法', '想想'], sentence: '想想。', strokeNames: <String>['横', '竖', '撇', '点', '竖', '横折', '横', '横', '横', '点', '横撇', '点', '斜钩', '点', '点'], lessonId: 57, category: '心理'),
  '知': CharCard(char: '知', pinyin: 'zhī', meaning: '明白', words: <String>['知道', '知了'], sentence: '知道。', strokeNames: <String>['撇', '横', '横', '竖', '横折', '横', '竖', '横折', '横'], lessonId: 57, category: '心理'),
  '忘': CharCard(char: '忘', pinyin: 'wàng', meaning: '记不住', words: <String>['忘记', '忘了'], sentence: '忘了。', strokeNames: <String>['点', '横', '竖折', '点', '点', '斜钩', '点', '点'], lessonId: 57, category: '心理'),

  // ---------------- 第 58 课 · 记 懂 会 ----------------
  '记': CharCard(char: '记', pinyin: 'jì', meaning: '把事留在脑子', words: <String>['记得', '记住'], sentence: '记得。', strokeNames: <String>['点', '横折提', '横折', '横', '竖弯钩'], lessonId: 58, category: '心理'),
  '懂': CharCard(char: '懂', pinyin: 'dǒng', meaning: '明白', words: <String>['懂得', '懂了'], sentence: '懂了。', strokeNames: <String>['撇', '横', '点', '撇', '横', '点', '横', '竖', '竖', '撇', '横', '竖', '横折', '横', '横', '竖', '横折', '横', '横', '横'], lessonId: 58, category: '心理'),
  '会': CharCard(char: '会', pinyin: 'huì', meaning: '能；懂得', words: <String>['会写', '开会'], sentence: '会写。', strokeNames: <String>['撇', '捺', '横', '横', '撇折', '点'], lessonId: 58, category: '能力'),

  // ---------------- 第 59 课 · 能 要 爱 ----------------
  '能': CharCard(char: '能', pinyin: 'néng', meaning: '有本事', words: <String>['不能', '能力'], sentence: '不能。', strokeNames: <String>['撇折', '点', '竖', '横折', '横', '横', '撇', '横折钩', '撇', '竖弯钩'], lessonId: 59, category: '能力'),
  '要': CharCard(char: '要', pinyin: 'yào', meaning: '想要', words: <String>['要写', '不要'], sentence: '不要。', strokeNames: <String>['横', '竖', '横折', '竖', '竖', '横', '撇点', '撇', '横'], lessonId: 59, category: '意愿'),
  '爱': CharCard(char: '爱', pinyin: 'ài', meaning: '喜欢', words: <String>['爱人', '关爱'], sentence: '关爱。', strokeNames: <String>['撇', '点', '点', '撇', '点', '横撇', '横', '撇', '捺', '点', '卧钩', '点', '点'], lessonId: 59, category: '意愿'),

  // ---------------- 第 60 课 · 喜 怒 哀 ----------------
  '喜': CharCard(char: '喜', pinyin: 'xǐ', meaning: '高兴', words: <String>['喜欢', '欢喜'], sentence: '喜欢。', strokeNames: <String>['横', '竖', '横', '竖', '横折', '横', '点', '撇', '横', '竖', '横折', '横', '竖', '横折', '横'], lessonId: 60, category: '情绪'),
  '怒': CharCard(char: '怒', pinyin: 'nù', meaning: '生气', words: <String>['发怒', '怒气'], sentence: '发怒。', strokeNames: <String>['横折', '撇', '横', '竖钩', '撇', '捺', '点', '卧钩', '点', '点'], lessonId: 60, category: '情绪'),
  '哀': CharCard(char: '哀', pinyin: 'āi', meaning: '伤心', words: <String>['哀求', '悲哀'], sentence: '悲哀。', strokeNames: <String>['点', '横', '竖', '横折', '横', '撇', '横折', '撇', '捺'], lessonId: 60, category: '情绪'),

  // ============ V1.10 扩字典：再添 15 课 × 3 字 = 45 字（总 225 字） ============
  // 面向母亲农村生活与日常刚需，补充农事/自然/饮食/居家/学习/社交/出行等场景字。
  // 单字不配图（沿用 v1.7 决定），笔画名仅作顺序辅助展示，描红范字走 Text 浅色字。

  // ---------------- 第 61 课 · 麦 豆 瓜 ----------------
  '麦': CharCard(char: '麦', pinyin: 'mài', meaning: '做面食的庄稼', words: <String>['麦子', '麦田'], sentence: '麦田。', strokeNames: <String>['横', '横', '竖', '横', '撇', '横撇', '撇', '捺'], lessonId: 61, category: '农事'),
  '豆': CharCard(char: '豆', pinyin: 'dòu', meaning: '豆类的统称', words: <String>['黄豆', '豆子'], sentence: '豆子。', strokeNames: <String>['横', '竖', '横折', '横', '点', '撇', '横', '竖', '横'], lessonId: 61, category: '农事'),
  '瓜': CharCard(char: '瓜', pinyin: 'guā', meaning: '瓜类，如西瓜', words: <String>['西瓜', '冬瓜'], sentence: '西瓜。', strokeNames: <String>['撇', '撇', '竖提', '点', '竖', '捺'], lessonId: 61, category: '农事'),

  // ---------------- 第 62 课 · 土 树 叶 ----------------
  '土': CharCard(char: '土', pinyin: 'tǔ', meaning: '泥土；地面', words: <String>['土地', '泥土'], sentence: '土地。', strokeNames: <String>['横', '竖', '横'], lessonId: 62, category: '农事'),
  '树': CharCard(char: '树', pinyin: 'shù', meaning: '木本植物', words: <String>['大树', '果树'], sentence: '大树。', strokeNames: <String>['横', '竖', '撇', '捺', '横撇', '捺', '横', '竖钩', '点'], lessonId: 62, category: '植物'),
  '叶': CharCard(char: '叶', pinyin: 'yè', meaning: '植物的叶子', words: <String>['树叶', '叶子'], sentence: '树叶。', strokeNames: <String>['竖', '横折', '横', '横', '竖'], lessonId: 62, category: '植物'),

  // ---------------- 第 63 课 · 山 河 石 ----------------
  '山': CharCard(char: '山', pinyin: 'shān', meaning: '高起的地貌', words: <String>['大山', '山上'], sentence: '山上。', strokeNames: <String>['竖', '竖折', '竖'], lessonId: 63, category: '自然'),
  '河': CharCard(char: '河', pinyin: 'hé', meaning: '天然的大水道', words: <String>['小河', '河水'], sentence: '河水。', strokeNames: <String>['点', '点', '提', '横', '竖', '横折', '横', '竖钩'], lessonId: 63, category: '自然'),
  '石': CharCard(char: '石', pinyin: 'shí', meaning: '石头', words: <String>['石头', '石子'], sentence: '石头。', strokeNames: <String>['横', '撇', '竖', '横折', '横'], lessonId: 63, category: '自然'),

  // ---------------- 第 64 课 · 果 油 茶 ----------------
  '果': CharCard(char: '果', pinyin: 'guǒ', meaning: '水果；果实', words: <String>['水果', '苹果'], sentence: '水果。', strokeNames: <String>['竖', '横折', '横', '横', '横', '竖', '撇', '捺'], lessonId: 64, category: '饮食'),
  '油': CharCard(char: '油', pinyin: 'yóu', meaning: '炒菜用的油', words: <String>['香油', '油瓶'], sentence: '香油。', strokeNames: <String>['点', '点', '提', '竖', '横折', '横', '竖', '横'], lessonId: 64, category: '饮食'),
  '茶': CharCard(char: '茶', pinyin: 'chá', meaning: '泡着喝的叶子', words: <String>['茶水', '喝茶'], sentence: '喝茶。', strokeNames: <String>['横', '竖', '竖', '撇', '捺', '横', '竖', '撇', '捺'], lessonId: 64, category: '饮食'),

  // ---------------- 第 65 课 · 酒 杯 饱 ----------------
  '酒': CharCard(char: '酒', pinyin: 'jiǔ', meaning: '粮食酿的饮料', words: <String>['喝酒', '酒杯'], sentence: '喝酒。', strokeNames: <String>['点', '点', '提', '横', '竖', '横折', '撇', '竖折', '横', '横'], lessonId: 65, category: '饮食'),
  '杯': CharCard(char: '杯', pinyin: 'bēi', meaning: '盛水的杯子', words: <String>['茶杯', '杯子'], sentence: '杯子。', strokeNames: <String>['横', '竖', '撇', '捺', '横', '撇', '竖', '点'], lessonId: 65, category: '餐具'),
  '饱': CharCard(char: '饱', pinyin: 'bǎo', meaning: '吃够了', words: <String>['吃饱', '饱了'], sentence: '吃饱。', strokeNames: <String>['撇', '横撇', '竖提', '撇', '横折钩', '横折', '横', '竖弯钩'], lessonId: 65, category: '饮食'),

  // ---------------- 第 66 课 · 灯 扫 抹 ----------------
  '灯': CharCard(char: '灯', pinyin: 'dēng', meaning: '照明的器具', words: <String>['电灯', '台灯'], sentence: '电灯。', strokeNames: <String>['点', '撇', '撇', '捺', '横', '竖钩'], lessonId: 66, category: '居家'),
  '扫': CharCard(char: '扫', pinyin: 'sǎo', meaning: '用笤帚清理', words: <String>['扫地', '打扫'], sentence: '扫地。', strokeNames: <String>['横', '竖钩', '提', '横折', '横', '横'], lessonId: 66, category: '居家'),
  '抹': CharCard(char: '抹', pinyin: 'mā', meaning: '用布擦', words: <String>['抹布', '抹桌'], sentence: '抹桌。', strokeNames: <String>['横', '竖钩', '提', '横', '横', '竖', '撇', '捺'], lessonId: 66, category: '居家'),

  // ---------------- 第 67 课 · 房 院 包 ----------------
  '房': CharCard(char: '房', pinyin: 'fáng', meaning: '住人的屋子', words: <String>['房子', '房间'], sentence: '房子。', strokeNames: <String>['点', '横折', '横', '撇', '点', '横', '横折钩', '撇', '横'], lessonId: 67, category: '居家'),
  '院': CharCard(char: '院', pinyin: 'yuàn', meaning: '院子；场所', words: <String>['院子', '庭院'], sentence: '院子。', strokeNames: <String>['横折折折钩', '竖', '点', '点', '横撇', '横', '横', '撇', '竖弯钩'], lessonId: 67, category: '居家'),
  '包': CharCard(char: '包', pinyin: 'bāo', meaning: '装东西的布袋', words: <String>['书包', '包袱'], sentence: '书包。', strokeNames: <String>['撇', '横折钩', '横折', '横', '竖弯钩'], lessonId: 67, category: '居家'),

  // ---------------- 第 68 课 · 笔 纸 书 ----------------
  '笔': CharCard(char: '笔', pinyin: 'bǐ', meaning: '写字的工具', words: <String>['毛笔', '铅笔'], sentence: '铅笔。', strokeNames: <String>['撇', '横', '点', '撇', '横', '点', '撇', '横', '横', '竖弯钩'], lessonId: 68, category: '学习'),
  '纸': CharCard(char: '纸', pinyin: 'zhǐ', meaning: '写字的纸张', words: <String>['白纸', '纸张'], sentence: '白纸。', strokeNames: <String>['撇折', '撇折', '提', '撇', '竖提', '横', '斜钩', '点'], lessonId: 68, category: '学习'),
  '书': CharCard(char: '书', pinyin: 'shū', meaning: '书本；写字', words: <String>['看书', '书本'], sentence: '看书。', strokeNames: <String>['横折', '横折钩', '竖', '点'], lessonId: 68, category: '学习'),

  // ---------------- 第 69 课 · 字 画 歌 ----------------
  '字': CharCard(char: '字', pinyin: 'zì', meaning: '汉字', words: <String>['写字', '汉字'], sentence: '写字。', strokeNames: <String>['点', '点', '横撇', '横撇', '竖钩', '横'], lessonId: 69, category: '学习'),
  '画': CharCard(char: '画', pinyin: 'huà', meaning: '画图画', words: <String>['画画', '图画'], sentence: '画画。', strokeNames: <String>['横', '竖', '横折', '横', '竖', '横', '竖折', '竖'], lessonId: 69, category: '学习'),
  '歌': CharCard(char: '歌', pinyin: 'gē', meaning: '唱的曲子', words: <String>['唱歌', '歌曲'], sentence: '唱歌。', strokeNames: <String>['横', '竖', '横折', '横', '竖钩', '横', '竖', '横折', '横', '竖钩', '撇', '横撇', '撇', '捺'], lessonId: 69, category: '学习'),

  // ---------------- 第 70 课 · 笑 哭 怕 ----------------
  '笑': CharCard(char: '笑', pinyin: 'xiào', meaning: '高兴出声', words: <String>['笑话', '微笑'], sentence: '微笑。', strokeNames: <String>['撇', '横', '点', '撇', '横', '点', '撇', '横', '撇', '捺'], lessonId: 70, category: '情绪'),
  '哭': CharCard(char: '哭', pinyin: 'kū', meaning: '流泪出声', words: <String>['哭声', '哭了'], sentence: '哭了。', strokeNames: <String>['竖', '横折', '横', '竖', '横折', '横', '横', '撇', '捺', '点', '点'], lessonId: 70, category: '情绪'),
  '怕': CharCard(char: '怕', pinyin: 'pà', meaning: '心里害怕', words: <String>['害怕', '不怕'], sentence: '害怕。', strokeNames: <String>['点', '点', '竖', '撇', '竖', '横折', '横', '横'], lessonId: 70, category: '心理'),

  // ---------------- 第 71 课 · 医 健 康 ----------------
  '医': CharCard(char: '医', pinyin: 'yī', meaning: '治病的人', words: <String>['医生', '医院'], sentence: '医生。', strokeNames: <String>['横', '撇', '横', '横', '撇', '点', '竖折', '竖弯钩'], lessonId: 71, category: '健康'),
  '健': CharCard(char: '健', pinyin: 'jiàn', meaning: '身体好', words: <String>['健康', '强健'], sentence: '健康。', strokeNames: <String>['撇', '竖', '横折', '横', '横', '横', '横', '竖', '横折折撇', '捺'], lessonId: 71, category: '健康'),
  '康': CharCard(char: '康', pinyin: 'kāng', meaning: '平安无病', words: <String>['健康', '安康'], sentence: '安康。', strokeNames: <String>['点', '横', '撇', '横折', '横', '横', '竖钩', '点', '提', '撇', '捺'], lessonId: 71, category: '健康'),

  // ---------------- 第 72 课 · 友 客 邻 ----------------
  '友': CharCard(char: '友', pinyin: 'yǒu', meaning: '亲近的人', words: <String>['朋友', '友好'], sentence: '朋友。', strokeNames: <String>['横', '撇', '横撇', '捺'], lessonId: 72, category: '人称'),
  '客': CharCard(char: '客', pinyin: 'kè', meaning: '来访的人', words: <String>['客人', '请客'], sentence: '客人。', strokeNames: <String>['点', '点', '横撇', '撇', '横撇', '捺', '竖', '横折', '横'], lessonId: 72, category: '人称'),
  '邻': CharCard(char: '邻', pinyin: 'lín', meaning: '挨着住的人', words: <String>['邻居', '邻里'], sentence: '邻居。', strokeNames: <String>['撇', '捺', '点', '横撇', '点', '横折折折钩', '竖'], lessonId: 72, category: '人称'),

  // ---------------- 第 73 课 · 工 店 兵 ----------------
  '工': CharCard(char: '工', pinyin: 'gōng', meaning: '做活儿的人', words: <String>['工人', '工作'], sentence: '工人。', strokeNames: <String>['横', '竖', '横'], lessonId: 73, category: '职业'),
  '店': CharCard(char: '店', pinyin: 'diàn', meaning: '卖东西的铺子', words: <String>['商店', '店铺'], sentence: '商店。', strokeNames: <String>['点', '横', '撇', '竖', '横折', '横', '竖', '横'], lessonId: 73, category: '买卖'),
  '兵': CharCard(char: '兵', pinyin: 'bīng', meaning: '当兵的人', words: <String>['当兵', '士兵'], sentence: '士兵。', strokeNames: <String>['撇', '竖', '横', '竖', '横', '撇', '点'], lessonId: 73, category: '职业'),

  // ---------------- 第 74 课 · 市 票 借 ----------------
  '市': CharCard(char: '市', pinyin: 'shì', meaning: '买卖的地方', words: <String>['集市', '市场'], sentence: '集市。', strokeNames: <String>['点', '横', '竖', '横折钩', '竖'], lessonId: 74, category: '买卖'),
  '票': CharCard(char: '票', pinyin: 'piào', meaning: '车船入门的纸', words: <String>['车票', '门票'], sentence: '车票。', strokeNames: <String>['横', '竖', '横折', '竖', '竖', '横', '横', '竖钩', '撇', '点'], lessonId: 74, category: '买卖'),
  '借': CharCard(char: '借', pinyin: 'jiè', meaning: '暂时用别人的', words: <String>['借书', '借钱'], sentence: '借书。', strokeNames: <String>['撇', '竖', '横', '竖', '竖', '横', '竖', '横折', '横', '横'], lessonId: 74, category: '买卖'),

  // ---------------- 第 75 课 · 拿 飞 船 ----------------
  '拿': CharCard(char: '拿', pinyin: 'ná', meaning: '用手取', words: <String>['拿来', '拿住'], sentence: '拿来。', strokeNames: <String>['撇', '捺', '横', '竖', '横折', '横', '撇', '横', '横', '竖钩'], lessonId: 75, category: '动作'),
  '飞': CharCard(char: '飞', pinyin: 'fēi', meaning: '在空中动', words: <String>['飞机', '飞鸟'], sentence: '飞机。', strokeNames: <String>['横斜钩', '撇', '点'], lessonId: 75, category: '出行'),
  '船': CharCard(char: '船', pinyin: 'chuán', meaning: '水上的交通工具', words: <String>['坐船', '小船'], sentence: '坐船。', strokeNames: <String>['撇', '撇', '横折钩', '点', '横', '点', '撇', '横折弯钩'], lessonId: 75, category: '出行'),

  '了': CharCard(char: '了', pinyin: 'le', meaning: '表示完结', words: <String>['来了', '走了'], sentence: '他来了。', strokeNames: <String>['横撇', '竖钩'], lessonId: 76, category: '常用'),

  '的': CharCard(char: '的', pinyin: 'de', meaning: '表明所属', words: <String>['我的', '好的'], sentence: '这是我的。', strokeNames: <String>['撇', '竖', '横折', '横', '横', '撇', '横折钩', '点'], lessonId: 76, category: '常用'),

  '他': CharCard(char: '他', pinyin: 'tā', meaning: '称别的男人', words: <String>['他们', '他家'], sentence: '他们在家。', strokeNames: <String>['撇', '竖', '横折钩', '竖', '竖弯钩'], lessonId: 76, category: '人称'),

  '子': CharCard(char: '子', pinyin: 'zi', meaning: '孩子；也作词尾', words: <String>['儿子', '孩子'], sentence: '他有儿子。', strokeNames: <String>['横撇', '竖钩', '横'], lessonId: 77, category: '常用'),

  '着': CharCard(char: '着', pinyin: 'zhe', meaning: '动作正在进行', words: <String>['看着', '听着'], sentence: '看着书。', strokeNames: <String>['点', '撇', '横', '横', '横', '撇', '竖', '横折', '横', '横', '横'], lessonId: 77, category: '动作'),

  '个': CharCard(char: '个', pinyin: 'gè', meaning: '通用量词', words: <String>['一个', '几个'], sentence: '一个人。', strokeNames: <String>['撇', '捺', '竖'], lessonId: 77, category: '量词'),

  '得': CharCard(char: '得', pinyin: 'de', meaning: '补语的记号', words: <String>['觉得', '记得'], sentence: '我觉得好。', strokeNames: <String>['撇', '撇', '竖', '竖', '横折', '横', '横', '横', '横', '竖钩', '点'], lessonId: 78, category: '常用'),

  '在': CharCard(char: '在', pinyin: 'zài', meaning: '存在的地方', words: <String>['现在', '在家'], sentence: '我在家。', strokeNames: <String>['横', '撇', '竖', '横', '竖', '横'], lessonId: 78, category: '常用'),

  '事': CharCard(char: '事', pinyin: 'shi', meaning: '事情', words: <String>['事情', '办事'], sentence: '这是小事。', strokeNames: <String>['横', '竖', '横折', '横', '横折', '横', '横', '竖钩'], lessonId: 78, category: '抽象'),

  '把': CharCard(char: '把', pinyin: 'bǎ', meaning: '手拿；介词', words: <String>['把手', '把门'], sentence: '把门关上。', strokeNames: <String>['横', '竖钩', '提', '横折', '竖', '横', '竖弯钩'], lessonId: 79, category: '常用'),

  '道': CharCard(char: '道', pinyin: 'dào', meaning: '路；说', words: <String>['道路', '知道'], sentence: '知道路。', strokeNames: <String>['点', '撇', '横', '撇', '竖', '横折', '横', '横', '横', '点', '横折折撇', '捺'], lessonId: 79, category: '常用'),

  '这': CharCard(char: '这', pinyin: 'zhè', meaning: '指近处', words: <String>['这里', '这个'], sentence: '这里好。', strokeNames: <String>['点', '横', '撇', '点', '点', '横折折撇', '捺'], lessonId: 79, category: '指示'),

  '过': CharCard(char: '过', pinyin: 'guò', meaning: '经过；曾经', words: <String>['过桥', '走过'], sentence: '走过桥。', strokeNames: <String>['横', '竖钩', '点', '点', '横折折撇', '捺'], lessonId: 80, category: '动作'),

  '就': CharCard(char: '就', pinyin: 'jiù', meaning: '立刻；正是', words: <String>['就来', '就是'], sentence: '我就来。', strokeNames: <String>['点', '横', '竖', '横折', '横', '竖钩', '撇', '点', '横', '撇', '竖弯钩', '点'], lessonId: 80, category: '常用'),

  '到': CharCard(char: '到', pinyin: 'dào', meaning: '抵达', words: <String>['到家', '到了'], sentence: '我到家。', strokeNames: <String>['横', '撇折', '点', '横', '竖', '提', '竖', '竖钩'], lessonId: 80, category: '动作'),

  '也': CharCard(char: '也', pinyin: 'yě', meaning: '同样', words: <String>['也是', '也好'], sentence: '我也要。', strokeNames: <String>['横折钩', '竖', '竖弯钩'], lessonId: 81, category: '常用'),

  '真': CharCard(char: '真', pinyin: 'zhēn', meaning: '确实', words: <String>['真的', '真好'], sentence: '真好。', strokeNames: <String>['横', '竖', '竖', '横折', '横', '横', '横', '横', '撇', '点'], lessonId: 81, category: '抽象'),

  '理': CharCard(char: '理', pinyin: 'lǐ', meaning: '道理；管', words: <String>['道理', '说理'], sentence: '有道理。', strokeNames: <String>['横', '横', '竖', '提', '竖', '横折', '横', '横', '竖', '横', '横'], lessonId: 81, category: '抽象'),

  '只': CharCard(char: '只', pinyin: 'zhī', meaning: '量词；仅', words: <String>['一只', '只好'], sentence: '一只猫。', strokeNames: <String>['竖', '横折', '横', '撇', '点'], lessonId: 82, category: '量词'),

  '跑': CharCard(char: '跑', pinyin: 'pǎo', meaning: '快步移动', words: <String>['跑步', '跑开'], sentence: '他跑开。', strokeNames: <String>['竖', '横折', '横', '竖', '横', '竖', '提', '撇', '横折钩', '横折', '横', '竖弯钩'], lessonId: 82, category: '动作'),

  '进': CharCard(char: '进', pinyin: 'jìn', meaning: '入内', words: <String>['进门', '进去'], sentence: '进门来。', strokeNames: <String>['横', '横', '撇', '竖', '点', '横折折撇', '捺'], lessonId: 82, category: '动作'),

  '龙': CharCard(char: '龙', pinyin: 'lóng', meaning: '传说神兽', words: <String>['龙王', '龙船'], sentence: '赛龙船。', strokeNames: <String>['横', '撇', '竖弯钩', '撇', '点'], lessonId: 83, category: '动物'),

  '马': CharCard(char: '马', pinyin: 'mǎ', meaning: '家畜', words: <String>['马车', '马儿'], sentence: '骑马走。', strokeNames: <String>['横折', '竖折折钩', '横'], lessonId: 83, category: '动物'),

  '才': CharCard(char: '才', pinyin: 'cái', meaning: '刚刚；才能', words: <String>['才来', '才干'], sentence: '他才来。', strokeNames: <String>['横', '竖钩', '撇'], lessonId: 83, category: '常用'),

  '那': CharCard(char: '那', pinyin: 'nà', meaning: '指远处', words: <String>['那里', '那个'], sentence: '那里远。', strokeNames: <String>['横折钩', '横', '横', '撇', '横折折折钩', '竖'], lessonId: 84, category: '指示'),

  '还': CharCard(char: '还', pinyin: 'hái', meaning: '仍旧；更', words: <String>['还在', '还好'], sentence: '还在家。', strokeNames: <String>['横', '撇', '竖', '点', '点', '横折折撇', '捺'], lessonId: 84, category: '常用'),

  '两': CharCard(char: '两', pinyin: 'liǎng', meaning: '数字二', words: <String>['两个', '两天'], sentence: '两个人。', strokeNames: <String>['横', '竖', '横折钩', '撇', '点', '撇', '点'], lessonId: 84, category: '数量'),

  '边': CharCard(char: '边', pinyin: 'biān', meaning: '旁侧', words: <String>['河边', '身边'], sentence: '在身边。', strokeNames: <String>['横折钩', '撇', '点', '横折折撇', '捺'], lessonId: 85, category: '方位'),

  '又': CharCard(char: '又', pinyin: 'yòu', meaning: '再次', words: <String>['又来', '又要'], sentence: '他又来。', strokeNames: <String>['横撇', '捺'], lessonId: 85, category: '常用'),

  '没': CharCard(char: '没', pinyin: 'méi', meaning: '无；未', words: <String>['没有', '没了'], sentence: '没有钱。', strokeNames: <String>['点', '点', '提', '撇', '横折折', '横撇', '捺'], lessonId: 85, category: '常用'),

  '见': CharCard(char: '见', pinyin: 'jiàn', meaning: '看到', words: <String>['看见', '见面'], sentence: '见一面。', strokeNames: <String>['竖', '横折', '撇', '竖弯钩'], lessonId: 86, category: '动作'),

  '娘': CharCard(char: '娘', pinyin: 'niáng', meaning: '母亲', words: <String>['娘家', '爹娘'], sentence: '娘来了。', strokeNames: <String>['撇点', '撇', '横', '点', '横折', '横', '横', '竖提', '撇', '捺'], lessonId: 86, category: '人称'),

  '自': CharCard(char: '自', pinyin: 'zì', meaning: '自己', words: <String>['自己', '自在'], sentence: '靠自己。', strokeNames: <String>['撇', '竖', '横折', '横', '横', '横'], lessonId: 86, category: '人称'),

  '都': CharCard(char: '都', pinyin: 'dōu', meaning: '全', words: <String>['都是', '都好'], sentence: '都好。', strokeNames: <String>['横', '竖', '横', '撇', '竖', '横折', '横', '横', '横折折折钩', '竖'], lessonId: 87, category: '常用'),

  '故': CharCard(char: '故', pinyin: 'gù', meaning: '旧；原因', words: <String>['故事', '故人'], sentence: '讲故事。', strokeNames: <String>['横', '竖', '竖', '横折', '横', '撇', '横', '撇', '捺'], lessonId: 87, category: '抽象'),

  '住': CharCard(char: '住', pinyin: 'zhù', meaning: '居留', words: <String>['住房', '住下'], sentence: '住下吧。', strokeNames: <String>['撇', '竖', '点', '横', '横', '竖', '横'], lessonId: 87, category: '动作'),

  '样': CharCard(char: '样', pinyin: 'yàng', meaning: '样子', words: <String>['样子', '这样'], sentence: '这样好。', strokeNames: <String>['横', '竖', '撇', '点', '点', '撇', '横', '横', '横', '竖'], lessonId: 88, category: '抽象'),

  '百': CharCard(char: '百', pinyin: 'bǎi', meaning: '数字一百', words: <String>['一百', '百姓'], sentence: '百姓多。', strokeNames: <String>['横', '撇', '竖', '横折', '横', '横'], lessonId: 88, category: '数量'),

  '蛇': CharCard(char: '蛇', pinyin: 'shé', meaning: '长虫', words: <String>['蛇皮', '打蛇'], sentence: '蛇来了。', strokeNames: <String>['竖', '横折', '横', '竖', '横', '点', '点', '点', '横撇', '撇', '竖弯钩'], lessonId: 88, category: '动物'),

  '明': CharCard(char: '明', pinyin: 'míng', meaning: '亮；次日', words: <String>['明天', '明白'], sentence: '明天见。', strokeNames: <String>['竖', '横折', '横', '横', '撇', '横折钩', '横', '横'], lessonId: 89, category: '抽象'),

  '儿': CharCard(char: '儿', pinyin: 'er', meaning: '小孩', words: <String>['儿子', '女儿'], sentence: '小女儿。', strokeNames: <String>['撇', '竖弯钩'], lessonId: 89, category: '人称'),

  '己': CharCard(char: '己', pinyin: 'jǐ', meaning: '自己', words: <String>['自己', '知己'], sentence: '为自己。', strokeNames: <String>['横折', '横', '竖弯钩'], lessonId: 89, category: '人称'),

  '长': CharCard(char: '长', pinyin: 'cháng', meaning: '两端距离大', words: <String>['长短', '长发'], sentence: '头发长。', strokeNames: <String>['撇', '横', '竖提', '捺'], lessonId: 90, category: '常用'),

  '太': CharCard(char: '太', pinyin: 'tài', meaning: '极；过度', words: <String>['太大', '太好'], sentence: '太大了。', strokeNames: <String>['横', '撇', '捺', '点'], lessonId: 90, category: '程度'),

  '王': CharCard(char: '王', pinyin: 'wáng', meaning: '君主；大', words: <String>['大王', '国王'], sentence: '国王到。', strokeNames: <String>['横', '横', '竖', '横'], lessonId: 90, category: '人称'),

  '仙': CharCard(char: '仙', pinyin: 'xiān', meaning: '神异的人', words: <String>['神仙', '仙女'], sentence: '像神仙。', strokeNames: <String>['撇', '竖', '竖', '竖弯', '竖'], lessonId: 91, category: '称谓'),

  '步': CharCard(char: '步', pinyin: 'bù', meaning: '行走', words: <String>['脚步', '散步'], sentence: '散散步。', strokeNames: <String>['竖', '横', '竖', '横', '竖', '撇', '撇'], lessonId: 91, category: '动作'),

  '先': CharCard(char: '先', pinyin: 'xiān', meaning: '前头', words: <String>['先生', '先走'], sentence: '你先走。', strokeNames: <String>['撇', '横', '竖', '横', '撇', '竖弯钩'], lessonId: 91, category: '时间'),

  '海': CharCard(char: '海', pinyin: 'hǎi', meaning: '大洋边的水', words: <String>['大海', '海边'], sentence: '去海边。', strokeNames: <String>['点', '点', '提', '撇', '横', '竖弯', '横折钩', '点', '横', '点'], lessonId: 92, category: '自然'),

  '气': CharCard(char: '气', pinyin: 'qì', meaning: '空气；怒', words: <String>['天气', '生气'], sentence: '天气好。', strokeNames: <String>['撇', '横', '横', '横斜钩'], lessonId: 92, category: '自然'),

  '从': CharCard(char: '从', pinyin: 'cóng', meaning: '自；跟随', words: <String>['从来', '从前'], sentence: '从前来。', strokeNames: <String>['撇', '点', '撇', '捺'], lessonId: 92, category: '常用'),

  '别': CharCard(char: '别', pinyin: 'bié', meaning: '不要；离', words: <String>['别人', '别走'], sentence: '别走开。', strokeNames: <String>['竖', '横折', '横', '横折钩', '撇', '竖', '竖钩'], lessonId: 93, category: '常用'),

  '狼': CharCard(char: '狼', pinyin: 'láng', meaning: '野兽', words: <String>['狼狗', '野狼'], sentence: '狼来了。', strokeNames: <String>['撇', '弯钩', '撇', '点', '横折', '横', '横', '竖提', '撇', '捺'], lessonId: 93, category: '动物'),

  '做': CharCard(char: '做', pinyin: 'zuò', meaning: '干；作', words: <String>['做事', '做饭'], sentence: '做饭吃。', strokeNames: <String>['撇', '竖', '横', '竖', '竖', '横折', '横', '撇', '横', '撇', '捺'], lessonId: 93, category: '动作'),

  '和': CharCard(char: '和', pinyin: 'hé', meaning: '跟；平和', words: <String>['和我', '和气'], sentence: '和我走。', strokeNames: <String>['撇', '横', '竖', '撇', '点', '竖', '横折', '横'], lessonId: 94, category: '常用'),

  '苗': CharCard(char: '苗', pinyin: 'miáo', meaning: '初生的草', words: <String>['禾苗', '树苗'], sentence: '树苗长。', strokeNames: <String>['横', '竖', '竖', '竖', '横折', '横', '竖', '横'], lessonId: 94, category: '植物'),

  '叫': CharCard(char: '叫', pinyin: 'jiào', meaning: '呼；唤', words: <String>['叫人', '叫门'], sentence: '叫开门。', strokeNames: <String>['竖', '横折', '横', '竖提', '竖'], lessonId: 94, category: '动作'),

  '条': CharCard(char: '条', pinyin: 'tiáo', meaning: '长物量词', words: <String>['一条', '纸条'], sentence: '一条鱼。', strokeNames: <String>['撇', '横撇', '捺', '横', '竖钩', '撇', '点'], lessonId: 95, category: '量词'),

  '放': CharCard(char: '放', pinyin: 'fàng', meaning: '搁；释', words: <String>['放下', '放心'], sentence: '放下心。', strokeNames: <String>['点', '横', '横折钩', '撇', '撇', '横', '撇', '捺'], lessonId: 95, category: '动作'),

  '打': CharCard(char: '打', pinyin: 'dǎ', meaning: '击', words: <String>['打开', '打水'], sentence: '打水去。', strokeNames: <String>['横', '竖钩', '提', '横', '竖钩'], lessonId: 95, category: '动作'),

  '吓': CharCard(char: '吓', pinyin: 'xià', meaning: '使害怕', words: <String>['吓人', '惊吓'], sentence: '吓一跳。', strokeNames: <String>['竖', '横折', '横', '横', '竖', '点'], lessonId: 96, category: '动作'),

  '哪': CharCard(char: '哪', pinyin: 'nǎ', meaning: '疑问处所', words: <String>['哪里', '哪个'], sentence: '去哪里？', strokeNames: <String>['竖', '横折', '横', '横折钩', '横', '横', '撇', '横折折折钩', '竖'], lessonId: 96, category: '疑问'),

  '为': CharCard(char: '为', pinyin: 'wèi', meaning: '替；因', words: <String>['为了', '为何'], sentence: '为了家。', strokeNames: <String>['点', '撇', '横折钩', '点'], lessonId: 96, category: '常用'),

  '身': CharCard(char: '身', pinyin: 'shēn', meaning: '躯体', words: <String>['身体', '身上'], sentence: '身体好。', strokeNames: <String>['撇', '竖', '横折钩', '横', '横', '横', '撇'], lessonId: 97, category: '身体'),

  '救': CharCard(char: '救', pinyin: 'jiù', meaning: '援助脱险', words: <String>['救人', '救命'], sentence: '快救人！', strokeNames: <String>['横', '竖钩', '点', '提', '撇', '点', '点', '撇', '横', '撇', '捺'], lessonId: 97, category: '动作'),

  '正': CharCard(char: '正', pinyin: 'zhèng', meaning: '不偏；恰', words: <String>['正好', '正路'], sentence: '正好到。', strokeNames: <String>['横', '竖', '横', '竖', '横'], lessonId: 97, category: '抽象'),

  '卖': CharCard(char: '卖', pinyin: 'mài', meaning: '售出', words: <String>['卖货', '卖菜'], sentence: '卖菜去。', strokeNames: <String>['横', '竖', '横撇', '点', '点', '横', '撇', '点'], lessonId: 98, category: '买卖'),

  '它': CharCard(char: '它', pinyin: 'tā', meaning: '指物', words: <String>['它们', '它家'], sentence: '它跑了。', strokeNames: <String>['点', '点', '横撇', '撇', '竖弯钩'], lessonId: 98, category: '人称'),

  '丢': CharCard(char: '丢', pinyin: 'diū', meaning: '遗失；抛', words: <String>['丢了', '丢弃'], sentence: '钱丢了。', strokeNames: <String>['撇', '横', '竖', '横', '撇折', '点'], lessonId: 98, category: '动作'),

  '珠': CharCard(char: '珠', pinyin: 'zhū', meaning: '圆粒珍物', words: <String>['珍珠', '水珠'], sentence: '水珠落。', strokeNames: <String>['横', '横', '竖', '提', '撇', '横', '横', '竖', '撇', '捺'], lessonId: 99, category: '物品'),

  '孙': CharCard(char: '孙', pinyin: 'sūn', meaning: '儿之子', words: <String>['孙子', '孙女'], sentence: '孙子笑。', strokeNames: <String>['横撇', '竖钩', '提', '竖钩', '撇', '点'], lessonId: 99, category: '人称'),

  '位': CharCard(char: '位', pinyin: 'wèi', meaning: '人的量词', words: <String>['一位', '座位'], sentence: '一位客。', strokeNames: <String>['撇', '竖', '点', '横', '点', '撇', '横'], lessonId: 99, category: '量词'),

  // ================ 第 100–119 课 · 新增 60 字（难度上调，生活刚需）================
  // ---------------- 第 100 课 ----------------
  '豫': CharCard(
    char: '豫',
    pinyin: 'yù',
    meaning: '河南的简称，车牌上就是这个',
    words: <String>['豫剧', '豫南'],
    sentence: '车牌上的“豫”是咱河南。',
    picFile: null,
    strokeNames: <String>['横撇', '点', '横撇', '竖钩', '撇', '横撇', '竖', '横折', '横', '撇', '弯钩', '撇', '撇', '撇', '捺'],
    lessonId: 100,
    category: '常用',
  ),
  '晋': CharCard(
    char: '晋',
    pinyin: 'jìn',
    meaning: '山西的简称，晋剧好看',
    words: <String>['晋剧', '山西'],
    sentence: '山西的晋剧好看。',
    picFile: null,
    strokeNames: <String>['横', '竖', '竖', '点', '撇', '横', '竖', '横折', '横', '横'],
    lessonId: 100,
    category: '常用',
  ),
  '鲁': CharCard(
    char: '鲁',
    pinyin: 'lǔ',
    meaning: '山东的简称，鲁菜香',
    words: <String>['鲁菜', '山东'],
    sentence: '山东的鲁菜香。',
    picFile: null,
    strokeNames: <String>['撇', '横撇', '竖', '横折', '横', '竖', '横', '横', '竖', '横折', '横', '横'],
    lessonId: 100,
    category: '常用',
  ),
  // ---------------- 第 101 课 ----------------
  '冀': CharCard(
    char: '冀',
    pinyin: 'jì',
    meaning: '河北的简称，挨着咱河南',
    words: <String>['河北', '冀南'],
    sentence: '河北挨着咱河南。',
    picFile: null,
    strokeNames: <String>['竖', '横', '提', '撇', '竖弯钩', '竖', '横折', '横', '竖', '横', '横', '竖', '竖', '横', '撇', '点'],
    lessonId: 101,
    category: '常用',
  ),
  '苏': CharCard(
    char: '苏',
    pinyin: 'sū',
    meaning: '江苏的简称，苏州园子好',
    words: <String>['苏州', '江苏'],
    sentence: '苏州的园子好看。',
    picFile: null,
    strokeNames: <String>['横', '竖', '竖', '横折钩', '撇', '点', '点'],
    lessonId: 101,
    category: '常用',
  ),
  '浙': CharCard(
    char: '浙',
    pinyin: 'zhè',
    meaning: '浙江的简称，温州生意多',
    words: <String>['浙江', '温州'],
    sentence: '浙江的温州生意多。',
    picFile: null,
    strokeNames: <String>['点', '点', '提', '横', '竖钩', '提', '撇', '撇', '横', '竖'],
    lessonId: 101,
    category: '常用',
  ),
  // ---------------- 第 102 课 ----------------
  '皖': CharCard(
    char: '皖',
    pinyin: 'wǎn',
    meaning: '安徽的简称，皖南茶好',
    words: <String>['皖南', '安徽'],
    sentence: '皖南的茶好喝。',
    picFile: null,
    strokeNames: <String>['撇', '竖', '横折', '横', '横', '点', '点', '横撇', '横', '横', '撇', '竖弯钩'],
    lessonId: 102,
    category: '常用',
  ),
  '赣': CharCard(
    char: '赣',
    pinyin: 'gàn',
    meaning: '江西的简称，赣江流过',
    words: <String>['赣江', '江西'],
    sentence: '赣江水流过江西。',
    picFile: null,
    strokeNames: <String>['点', '横', '点', '撇', '横', '竖', '横折', '横', '横', '横', '竖', '撇', '横撇', '捺', '横', '竖', '横', '竖', '横折', '撇', '点'],
    lessonId: 102,
    category: '常用',
  ),
  '鄂': CharCard(
    char: '鄂',
    pinyin: 'è',
    meaning: '湖北的简称，湖北有长江',
    words: <String>['湖北', '鄂州'],
    sentence: '湖北有条长江。',
    picFile: null,
    strokeNames: <String>['竖', '横折', '横', '竖', '横折', '横', '横', '横', '竖折折钩', '横折折折钩', '竖'],
    lessonId: 102,
    category: '常用',
  ),
  // ---------------- 第 103 课 ----------------
  '挂': CharCard(
    char: '挂',
    pinyin: 'guà',
    meaning: '钩在墙上；看病先挂号',
    words: <String>['挂号', '挂水'],
    sentence: '看病要先挂号。',
    picFile: null,
    strokeNames: <String>['横', '竖钩', '提', '横', '竖', '横', '横', '竖', '横'],
    lessonId: 103,
    category: '健康',
  ),
  '诊': CharCard(
    char: '诊',
    pinyin: 'zhěn',
    meaning: '去医院让医生看病',
    words: <String>['诊所', '诊病'],
    sentence: '去诊所让医生诊病。',
    picFile: null,
    strokeNames: <String>['点', '横折提', '撇', '捺', '撇', '撇', '撇'],
    lessonId: 103,
    category: '健康',
  ),
  '输': CharCard(
    char: '输',
    pinyin: 'shū',
    meaning: '打点滴，药水输进血管',
    words: <String>['输液', '输血'],
    sentence: '生病输液好得快。',
    picFile: null,
    strokeNames: <String>['横', '撇折', '竖', '提', '撇', '捺', '横', '竖', '横折钩', '横', '横', '竖', '竖钩'],
    lessonId: 103,
    category: '健康',
  ),
  // ---------------- 第 104 课 ----------------
  '体': CharCard(
    char: '体',
    pinyin: 'tǐ',
    meaning: '身体，浑身上下都叫体',
    words: <String>['身体', '体温'],
    sentence: '身体不舒服要看病。',
    picFile: null,
    strokeNames: <String>['撇', '竖', '横', '竖', '撇', '捺', '横'],
    lessonId: 104,
    category: '健康',
  ),
  '液': CharCard(
    char: '液',
    pinyin: 'yè',
    meaning: '药水汗水这类稀东西',
    words: <String>['输液', '液体'],
    sentence: '药水是液体。',
    picFile: null,
    strokeNames: <String>['点', '点', '提', '点', '横', '撇', '竖', '撇', '横撇', '点', '捺'],
    lessonId: 104,
    category: '健康',
  ),
  '症': CharCard(
    char: '症',
    pinyin: 'zhèng',
    meaning: '病的样子，比如感冒病症',
    words: <String>['病症', '症状'],
    sentence: '感冒是个小病症。',
    picFile: null,
    strokeNames: <String>['点', '横', '撇', '点', '提', '横', '竖', '横', '竖', '横'],
    lessonId: 104,
    category: '健康',
  ),
  // ---------------- 第 105 课 ----------------
  '疼': CharCard(
    char: '疼',
    pinyin: 'téng',
    meaning: '肉里难受，哪儿发疼',
    words: <String>['头疼', '肚子疼'],
    sentence: '我头疼得厉害。',
    picFile: null,
    strokeNames: <String>['点', '横', '撇', '点', '提', '撇', '横撇', '捺', '点', '点'],
    lessonId: 105,
    category: '健康',
  ),
  '痒': CharCard(
    char: '痒',
    pinyin: 'yǎng',
    meaning: '长痦子虫子爬会发痒',
    words: <String>['发痒', '痒了'],
    sentence: '腿上发痒要挠挠。',
    picFile: null,
    strokeNames: <String>['点', '横', '撇', '点', '提', '点', '撇', '横', '横', '横', '竖'],
    lessonId: 105,
    category: '健康',
  ),
  '胶': CharCard(
    char: '胶',
    pinyin: 'jiāo',
    meaning: '胶囊，药外面那层皮',
    words: <String>['胶囊', '胶水'],
    sentence: '吃药要吞胶囊。',
    picFile: null,
    strokeNames: <String>['撇', '横折钩', '横', '横', '点', '横', '撇', '点', '撇', '捺'],
    lessonId: 105,
    category: '健康',
  ),
  // ---------------- 第 106 课 ----------------
  '囊': CharCard(
    char: '囊',
    pinyin: 'náng',
    meaning: '胶囊，装药粉的小壳',
    words: <String>['胶囊', '胶囊药'],
    sentence: '胶囊里装的是药粉。',
    picFile: null,
    strokeNames: <String>['横', '竖', '横折', '横', '竖', '点', '横撇', '竖', '横折', '横', '竖', '横折', '横', '横', '横', '竖', '竖', '横', '撇', '竖提', '撇', '捺'],
    lessonId: 106,
    category: '健康',
  ),
  '储': CharCard(
    char: '储',
    pinyin: 'chǔ',
    meaning: '把钱存起来，储蓄',
    words: <String>['储蓄', '存储'],
    sentence: '把钱储蓄起来。',
    picFile: null,
    strokeNames: <String>['撇', '竖', '点', '横折提', '横', '竖', '横', '撇', '竖', '横折', '横', '横'],
    lessonId: 106,
    category: '买卖',
  ),
  '蓄': CharCard(
    char: '蓄',
    pinyin: 'xù',
    meaning: '攒着存着，蓄点钱',
    words: <String>['储蓄', '积蓄'],
    sentence: '平时蓄点钱应急。',
    picFile: null,
    strokeNames: <String>['横', '竖', '竖', '点', '横', '撇折', '撇折', '点', '竖', '横折', '横', '竖', '横'],
    lessonId: 106,
    category: '买卖',
  ),
  // ---------------- 第 107 课 ----------------
  '账': CharCard(
    char: '账',
    pinyin: 'zhàng',
    meaning: '记花的钱，算账账单',
    words: <String>['账单', '算账'],
    sentence: '买菜要算清账。',
    picFile: null,
    strokeNames: <String>['竖', '横折', '撇', '点', '撇', '横', '竖提', '捺'],
    lessonId: 107,
    category: '买卖',
  ),
  '缴': CharCard(
    char: '缴',
    pinyin: 'jiǎo',
    meaning: '交钱，缴电费话费',
    words: <String>['缴费', '缴税'],
    sentence: '月底要缴电费。',
    picFile: null,
    strokeNames: <String>['撇折', '撇折', '提', '撇', '竖', '横折', '横', '横', '点', '横', '横折钩', '撇', '撇', '横', '撇', '捺'],
    lessonId: 107,
    category: '买卖',
  ),
  '费': CharCard(
    char: '费',
    pinyin: 'fèi',
    meaning: '要交的钱，电话费',
    words: <String>['电话费', '医药费'],
    sentence: '电话费该交了。',
    picFile: null,
    strokeNames: <String>['横折', '横', '竖折折钩', '撇', '竖', '竖', '横折', '撇', '点'],
    lessonId: 107,
    category: '买卖',
  ),
  // ---------------- 第 108 课 ----------------
  '验': CharCard(
    char: '验',
    pinyin: 'yàn',
    meaning: '查一查，化验验血',
    words: <String>['化验', '验血'],
    sentence: '抽血化验要验血。',
    picFile: null,
    strokeNames: <String>['横折', '竖折折钩', '提', '撇', '捺', '横', '点', '点', '撇', '横'],
    lessonId: 108,
    category: '买卖',
  ),
  '签': CharCard(
    char: '签',
    pinyin: 'qiān',
    meaning: '写名字，签名签字',
    words: <String>['签名', '签字'],
    sentence: '取钱要签名。',
    picFile: null,
    strokeNames: <String>['撇', '横', '点', '撇', '横', '点', '撇', '捺', '横', '点', '点', '撇', '横'],
    lessonId: 108,
    category: '买卖',
  ),
  '辆': CharCard(
    char: '辆',
    pinyin: 'liàng',
    meaning: '车的数法，一辆车',
    words: <String>['车辆', '一辆车'],
    sentence: '村口停着一辆车。',
    picFile: null,
    strokeNames: <String>['横', '撇折', '竖', '提', '横', '竖', '横折钩', '撇', '点', '撇', '点'],
    lessonId: 108,
    category: '买卖',
  ),
  // ---------------- 第 109 课 ----------------
  '额': CharCard(
    char: '额',
    pinyin: 'é',
    meaning: '数目，金额总数',
    words: <String>['金额', '数额'],
    sentence: '这月花销总额大。',
    picFile: null,
    strokeNames: <String>['点', '点', '横撇', '撇', '横撇', '点', '竖', '横折', '横', '横', '撇', '竖', '横折', '撇', '点'],
    lessonId: 109,
    category: '买卖',
  ),
  '站': CharCard(
    char: '站',
    pinyin: 'zhàn',
    meaning: '等车的地方，火车站',
    words: <String>['车站', '火车站'],
    sentence: '到火车站等车。',
    picFile: null,
    strokeNames: <String>['点', '横', '点', '撇', '提', '竖', '横', '竖', '横折', '横'],
    lessonId: 109,
    category: '出行',
  ),
  '候': CharCard(
    char: '候',
    pinyin: 'hòu',
    meaning: '等着，候车等候',
    words: <String>['候车', '等候'],
    sentence: '在站台候车。',
    picFile: null,
    strokeNames: <String>['撇', '竖', '竖', '横折', '横', '撇', '横', '横', '撇', '捺'],
    lessonId: 109,
    category: '出行',
  ),
  // ---------------- 第 110 课 ----------------
  '乘': CharCard(
    char: '乘',
    pinyin: 'chéng',
    meaning: '坐车坐船，乘车',
    words: <String>['乘车', '乘坐'],
    sentence: '乘车去县城。',
    picFile: null,
    strokeNames: <String>['撇', '横', '竖', '竖', '横', '提', '撇', '竖弯钩', '撇', '捺'],
    lessonId: 110,
    category: '出行',
  ),
  '换': CharCard(
    char: '换',
    pinyin: 'huàn',
    meaning: '倒车子，换车',
    words: <String>['换车', '换乘'],
    sentence: '到镇上换车。',
    picFile: null,
    strokeNames: <String>['横', '竖钩', '提', '撇', '横撇', '竖', '横折', '横', '撇', '捺'],
    lessonId: 110,
    category: '出行',
  ),
  '桥': CharCard(
    char: '桥',
    pinyin: 'qiáo',
    meaning: '河上过河的路，大桥',
    words: <String>['大桥', '桥梁'],
    sentence: '过大桥到对岸。',
    picFile: null,
    strokeNames: <String>['横', '竖', '撇', '点', '撇', '横', '撇', '捺', '撇', '竖'],
    lessonId: 110,
    category: '出行',
  ),
  // ---------------- 第 111 课 ----------------
  '隧': CharCard(
    char: '隧',
    pinyin: 'suì',
    meaning: '山里钻过去的洞',
    words: <String>['隧道', '隧洞'],
    sentence: '火车钻过隧道。',
    picFile: null,
    strokeNames: <String>['横折折折钩', '竖', '点', '撇', '横', '撇', '弯钩', '撇', '撇', '撇', '点', '点', '横折折撇', '捺'],
    lessonId: 111,
    category: '出行',
  ),
  '警': CharCard(
    char: '警',
    pinyin: 'jǐng',
    meaning: '管安全的，警察',
    words: <String>['警察', '民警'],
    sentence: '有事找警察。',
    picFile: null,
    strokeNames: <String>['横', '竖', '竖', '撇', '横折钩', '竖', '横折', '横', '撇', '横', '撇', '捺', '点', '横', '横', '横', '竖', '横折', '横'],
    lessonId: 111,
    category: '出行',
  ),
  '酱': CharCard(
    char: '酱',
    pinyin: 'jiàng',
    meaning: '咸稠的调料，豆瓣酱',
    words: <String>['酱菜', '豆瓣酱'],
    sentence: '蒸馍蘸豆瓣酱。',
    picFile: null,
    strokeNames: <String>['点', '提', '竖', '撇', '横撇', '点', '横', '竖', '横折', '撇', '竖弯', '横', '横'],
    lessonId: 111,
    category: '饮食',
  ),
  // ---------------- 第 112 课 ----------------
  '醋': CharCard(
    char: '醋',
    pinyin: 'cù',
    meaning: '酸酸的调料，蘸饺子',
    words: <String>['米醋', '香醋'],
    sentence: '饺子蘸醋好吃。',
    picFile: null,
    strokeNames: <String>['横', '竖', '横折', '撇', '竖弯', '横', '横', '横', '竖', '竖', '横', '竖', '横折', '横', '横'],
    lessonId: 112,
    category: '饮食',
  ),
  '蒜': CharCard(
    char: '蒜',
    pinyin: 'suàn',
    meaning: '紫皮的，炒菜提味',
    words: <String>['大蒜', '蒜苗'],
    sentence: '炒肉放点大蒜。',
    picFile: null,
    strokeNames: <String>['横', '竖', '竖', '横', '横', '竖钩', '撇', '点', '横', '横', '竖钩', '撇', '点'],
    lessonId: 112,
    category: '饮食',
  ),
  '椒': CharCard(
    char: '椒',
    pinyin: 'jiāo',
    meaning: '辣的，辣椒',
    words: <String>['辣椒', '花椒'],
    sentence: '辣椒炒鸡蛋香。',
    picFile: null,
    strokeNames: <String>['横', '竖', '撇', '点', '竖', '横', '横', '竖钩', '撇', '点', '横撇', '捺'],
    lessonId: 112,
    category: '饮食',
  ),
  // ---------------- 第 113 课 ----------------
  '罐': CharCard(
    char: '罐',
    pinyin: 'guàn',
    meaning: '装东西的坛子，罐头',
    words: <String>['罐头', '罐子'],
    sentence: '咸菜装罐子里。',
    picFile: null,
    strokeNames: <String>['撇', '横', '横', '竖', '竖弯', '竖', '横', '竖', '竖', '竖', '横折', '横', '竖', '横折', '横', '撇', '竖', '点', '横', '横', '横', '竖', '横'],
    lessonId: 113,
    category: '饮食',
  ),
  '腌': CharCard(
    char: '腌',
    pinyin: 'yān',
    meaning: '用盐泡存，腌咸菜',
    words: <String>['腌菜', '腌蛋'],
    sentence: '冬天腌点咸菜。',
    picFile: null,
    strokeNames: <String>['撇', '横折钩', '横', '横', '横', '撇', '捺', '竖', '横折', '横', '横', '竖弯钩'],
    lessonId: 113,
    category: '饮食',
  ),
  '蒸': CharCard(
    char: '蒸',
    pinyin: 'zhēng',
    meaning: '冒热气熟饭，蒸馍',
    words: <String>['蒸馍', '蒸饭'],
    sentence: '锅里蒸馍熟了。',
    picFile: null,
    strokeNames: <String>['横', '竖', '竖', '横撇', '竖钩', '横撇', '撇', '捺', '横', '点', '点', '点', '点'],
    lessonId: 113,
    category: '饮食',
  ),
  // ---------------- 第 114 课 ----------------
  '煮': CharCard(
    char: '煮',
    pinyin: 'zhǔ',
    meaning: '放水里烧熟，煮面',
    words: <String>['煮面', '煮饭'],
    sentence: '灶上煮面条。',
    picFile: null,
    strokeNames: <String>['横', '竖', '横', '撇', '竖', '横折', '横', '横', '点', '点', '点', '点'],
    lessonId: 114,
    category: '饮食',
  ),
  '炖': CharCard(
    char: '炖',
    pinyin: 'dùn',
    meaning: '小火慢熬，炖肉',
    words: <String>['炖肉', '炖汤'],
    sentence: '砂锅炖肉香。',
    picFile: null,
    strokeNames: <String>['点', '撇', '撇', '点', '横', '竖弯', '竖', '竖弯钩'],
    lessonId: 114,
    category: '饮食',
  ),
  '耕': CharCard(
    char: '耕',
    pinyin: 'gēng',
    meaning: '牛拉犁翻地，耕田',
    words: <String>['耕田', '耕地'],
    sentence: '开春要耕田。',
    picFile: null,
    strokeNames: <String>['横', '横', '横', '竖', '撇', '点', '横', '横', '撇', '竖'],
    lessonId: 114,
    category: '农事',
  ),
  // ---------------- 第 115 课 ----------------
  '播': CharCard(
    char: '播',
    pinyin: 'bō',
    meaning: '撒种子进地，播种',
    words: <String>['播种', '播撒'],
    sentence: '雨后播种玉米。',
    picFile: null,
    strokeNames: <String>['横', '竖钩', '提', '撇', '点', '撇', '横', '竖', '撇', '捺', '竖', '横折', '横', '竖', '横'],
    lessonId: 115,
    category: '农事',
  ),
  '锄': CharCard(
    char: '锄',
    pinyin: 'chú',
    meaning: '除草的小锄，锄草',
    words: <String>['锄草', '锄头'],
    sentence: '地里该锄草了。',
    picFile: null,
    strokeNames: <String>['撇', '横', '横', '横', '竖提', '竖', '横折', '横', '横', '提', '横折钩', '撇'],
    lessonId: 115,
    category: '农事',
  ),
  '镰': CharCard(
    char: '镰',
    pinyin: 'lián',
    meaning: '割麦的弯刀，镰刀',
    words: <String>['镰刀', '开镰'],
    sentence: '割麦要用镰刀。',
    picFile: null,
    strokeNames: <String>['撇', '横', '横', '横', '竖提', '点', '横', '撇', '点', '撇', '横', '横折', '横', '横', '竖', '竖', '撇', '捺'],
    lessonId: 115,
    category: '农事',
  ),
  // ---------------- 第 116 课 ----------------
  '粮': CharCard(
    char: '粮',
    pinyin: 'liáng',
    meaning: '吃的米面，粮食',
    words: <String>['粮食', '口粮'],
    sentence: '囤里粮食满啦。',
    picFile: null,
    strokeNames: <String>['点', '撇', '横', '竖', '撇', '点', '点', '横折', '横', '横', '竖提', '撇', '捺'],
    lessonId: 116,
    category: '农事',
  ),
  '囤': CharCard(
    char: '囤',
    pinyin: 'dùn',
    meaning: '存粮的大仓，粮囤',
    words: <String>['粮囤', '囤粮'],
    sentence: '粮囤存满麦子。',
    picFile: null,
    strokeNames: <String>['竖', '横折', '横', '竖弯', '竖', '竖弯钩', '横'],
    lessonId: 116,
    category: '农事',
  ),
  '晒': CharCard(
    char: '晒',
    pinyin: 'shài',
    meaning: '放太阳下，晒粮晒被',
    words: <String>['晒粮', '晒被'],
    sentence: '晴天晒粮晒被。',
    picFile: null,
    strokeNames: <String>['竖', '横折', '横', '横', '横', '竖', '横折', '撇', '竖弯', '横'],
    lessonId: 116,
    category: '农事',
  ),
  // ---------------- 第 117 课 ----------------
  '缝': CharCard(
    char: '缝',
    pinyin: 'féng',
    meaning: '用针连，缝衣服',
    words: <String>['缝衣', '缝补'],
    sentence: '衣服破了缝一缝。',
    picFile: null,
    strokeNames: <String>['撇折', '撇折', '提', '撇', '横撇', '捺', '横', '横', '横', '竖', '点', '横折折撇', '捺'],
    lessonId: 117,
    category: '居家',
  ),
  '擦': CharCard(
    char: '擦',
    pinyin: 'cā',
    meaning: '用布抹，擦桌子',
    words: <String>['擦桌', '擦手'],
    sentence: '吃饭擦净桌子。',
    picFile: null,
    strokeNames: <String>['横', '竖钩', '提', '点', '点', '横撇', '撇', '横撇', '点', '点', '横撇', '捺', '横', '横', '竖钩', '撇', '点'],
    lessonId: 117,
    category: '居家',
  ),
  '婶': CharCard(
    char: '婶',
    pinyin: 'shěn',
    meaning: '叔叔的媳妇，婶婶',
    words: <String>['婶婶', '大婶'],
    sentence: '婶婶来串门。',
    picFile: null,
    strokeNames: <String>['撇点', '撇', '横', '点', '点', '横撇', '竖', '横折', '横', '横', '竖'],
    lessonId: 117,
    category: '亲属',
  ),
  // ---------------- 第 118 课 ----------------
  '嫂': CharCard(
    char: '嫂',
    pinyin: 'sǎo',
    meaning: '哥哥的媳妇，嫂子',
    words: <String>['嫂子', '大嫂'],
    sentence: '嫂子做饭好吃。',
    picFile: null,
    strokeNames: <String>['撇点', '撇', '横', '撇', '竖', '横', '横折', '横', '横', '竖', '横撇', '捺'],
    lessonId: 118,
    category: '亲属',
  ),
  '侄': CharCard(
    char: '侄',
    pinyin: 'zhí',
    meaning: '兄弟的儿子，侄子',
    words: <String>['侄子', '侄女'],
    sentence: '侄子放暑假来。',
    picFile: null,
    strokeNames: <String>['撇', '竖', '横', '撇折', '点', '横', '竖', '横'],
    lessonId: 118,
    category: '亲属',
  ),
  '贺': CharCard(
    char: '贺',
    pinyin: 'hè',
    meaning: '有喜道喜，祝贺',
    words: <String>['贺喜', '祝贺'],
    sentence: '侄儿结婚去贺喜。',
    picFile: null,
    strokeNames: <String>['横折钩', '撇', '竖', '横折', '横', '竖', '横折', '撇', '点'],
    lessonId: 118,
    category: '称谓',
  ),
  // ---------------- 第 119 课 ----------------
  '探': CharCard(
    char: '探',
    pinyin: 'tàn',
    meaning: '去看人，探望病人',
    words: <String>['探望', '探病'],
    sentence: '去医院探病人。',
    picFile: null,
    strokeNames: <String>['横', '竖钩', '提', '点', '横撇', '撇', '点', '横', '竖', '撇', '捺'],
    lessonId: 119,
    category: '称谓',
  ),
  '谢': CharCard(
    char: '谢',
    pinyin: 'xiè',
    meaning: '受好说声谢，谢谢',
    words: <String>['谢谢', '道谢'],
    sentence: '受人好要说谢谢。',
    picFile: null,
    strokeNames: <String>['点', '横折提', '撇', '竖', '横折钩', '横', '横', '横', '撇', '横', '竖钩', '点'],
    lessonId: 119,
    category: '称谓',
  ),
  '请': CharCard(
    char: '请',
    pinyin: 'qǐng',
    meaning: '叫人来，请客请人',
    words: <String>['请客', '请人'],
    sentence: '过节请人吃饭。',
    picFile: null,
    strokeNames: <String>['点', '横折提', '横', '横', '竖', '横', '竖', '横折钩', '横', '横'],
    lessonId: 119,
    category: '称谓',
  ),
};

/// 取字卡；字库里没有时返回 null（调用方自行兜底，绝不抛异常）
CharCard? cardOf(String c) => kCharLibrary[c];

/// 该字是否已在字库中
bool hasCard(String c) => kCharLibrary.containsKey(c);

/// 字库总量（V1.0 = 60）
int get kCharLibrarySize => kCharLibrary.length;

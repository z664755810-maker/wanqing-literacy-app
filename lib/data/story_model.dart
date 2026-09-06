// ============================================================================
// 晚晴识字 · 故事屋数据模型
//
// 仅描述数据结构，不含任何 UI / 业务逻辑。具体故事内容见 [story.dart]，
// 注音解析见 [story_ruby.dart]。
// ============================================================================

/// 故事来源分类。
enum StorySource {
  /// 四大名著
  classic,
  /// 民间传说（白蛇传、哪吒闹海、牛郎织女、愚公移山……）
  legend,
  /// 语文课本经典篇目
  textbook,
  /// 原创生活故事（80 年代农村 / 家庭向）
  life,
  /// 中国寓言（守株待兔、亡羊补牢、愚公移山……）
  fable,
  /// 神话传说（大禹治水、牛郎织女、精卫填海……）
  myth,
}

/// 故事来源的中文名，直接用于 UI 展示。
const Map<StorySource, String> kStorySourceLabel = <StorySource, String>{
  StorySource.classic: '四大名著',
  StorySource.legend: '民间传说',
  StorySource.textbook: '语文课本',
  StorySource.life: '生活故事',
  StorySource.fable: '中国寓言',
  StorySource.myth: '神话传说',
};

/// 一个段落：正文（带注音源码）+ 1~3 张按阅读顺序的插图 + 图注（朗读无障碍用）。
class StoryParagraph {
  const StoryParagraph({
    required this.id,
    required this.ruby,
    this.images = const <String>[],
    this.imageCaption,
  });

  /// 段落内唯一 ID（书内）
  final String id;

  /// 带注音正文：`孙(sūn)悟(wù)空(kōng)，你(nǐ)好(hǎo)！`
  final String ruby;

  /// 插图资源路径（按阅读顺序排列，1~3 张）
  final List<String> images;

  /// 图注（用于整段朗读时的场景提示，可选）
  final String? imageCaption;
}

/// 一个章节：标题 + 封面 + 若干段落。
class StoryChapter {
  const StoryChapter({
    required this.id,
    required this.title,
    this.cover,
    required this.paragraphs,
  });

  /// 章节内唯一 ID
  final String id;

  /// 章节标题（带注音）
  final String title;

  /// 章节封面资源路径（可选）
  final String? cover;

  /// 段落列表
  final List<StoryParagraph> paragraphs;
}

/// 一本书：元信息 + 章节列表。
class StoryBook {
  const StoryBook({
    required this.id,
    required this.title,
    required this.source,
    this.cover,
    this.intro = '',
    this.difficulty = 1,
    required this.chapters,
  });

  /// 全局唯一 ID（路由 / 进度用）
  final String id;

  /// 书名（带注音）
  final String title;

  /// 来源分类
  final StorySource source;

  /// 封面资源路径
  final String? cover;

  /// 一句话简介（带注音）
  final String intro;

  /// 难度等级 1~3
  final int difficulty;

  /// 章节列表
  final List<StoryChapter> chapters;
}

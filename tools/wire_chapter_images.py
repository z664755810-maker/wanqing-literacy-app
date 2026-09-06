# -*- coding: utf-8 -*-
"""把 21 篇新故事每章第 1 段的 images 字段，填上对应的 c<N>_p1_1.png 路径。

规则（与旧 6 篇一致）：
  每章只在第 1 段挂一张图，命名 assets/images/stories/<story_id>/c<N>_p1_1.png

匹配靠缩进区分层级：
  2 空格 id: '<story_id>',   -> StoryBook 层
  6 空格 id: 'cN',           -> StoryChapter 层
  10 空格 id: 'p1',          -> StoryParagraph 层
  10 空格 images: <String>[], -> 该段图片字段
"""
import io
import re
import sys

PATH = r'D:/Progect-3/wanqing_shizi/lib/data/story.dart'

TARGET_IDS = [
    'fable_shouzhu', 'fable_wangyang', 'fable_yamiao', 'fable_hujia',
    'fable_kezhou', 'fable_jingdi', 'fable_maodun', 'fable_huashe',
    'fable_zhengren', 'fable_yegong', 'fable_lanyu', 'fable_maidu',
    'fable_saiweng', 'fable_beigong', 'fable_wushibu', 'fable_jiegan',
    'fable_yubang', 'fable_dongguo', 'myth_yugong', 'myth_dayu',
    'myth_niulang',
]

RE_BOOK = re.compile(r"^  id: '([a-z_]+)',$")      # StoryBook
RE_CHAP = re.compile(r"^      id: 'c(\d+)',$")     # StoryChapter
RE_PARA = re.compile(r"^          id: 'p(\d+)',$")  # StoryParagraph
RE_IMG = re.compile(r"^          images: <String>\[\],$")


def main():
    lines = io.open(PATH, encoding='utf-8').read().split('\n')

    story = None
    chapter = None
    paragraph = None
    filled = {}

    for i, line in enumerate(lines):
        m = RE_BOOK.match(line)
        if m:
            story = m.group(1) if m.group(1) in TARGET_IDS else None
            chapter = None
            paragraph = None
            continue

        m = RE_CHAP.match(line)
        if m:
            chapter = int(m.group(1))
            paragraph = None
            continue

        m = RE_PARA.match(line)
        if m:
            paragraph = int(m.group(1))
            continue

        if (RE_IMG.match(line) and story and chapter is not None
                and paragraph == 1):
            rel = 'assets/images/stories/%s/c%d_p1_1.png' % (story, chapter)
            lines[i] = "          images: <String>['%s']," % rel
            filled.setdefault(story, []).append(chapter)

    # 完整性校验
    bad = []
    for sid in TARGET_IDS:
        got = sorted(filled.get(sid, []))
        if got != [1, 2, 3, 4, 5, 6]:
            bad.append('%s -> %s' % (sid, got))
    if bad:
        print('校验失败，未写入任何内容：')
        for b in bad:
            print('  ', b)
        return 1

    total = sum(len(v) for v in filled.values())
    io.open(PATH, 'w', encoding='utf-8', newline='\n').write('\n'.join(lines))
    print('已写入 %d 处 images 路径（%d 篇 × 6 章）。' % (total, len(filled)))
    return 0


if __name__ == '__main__':
    sys.exit(main())

# -*- coding: utf-8 -*-
"""把 generated-images 里带 Oxx 编号的图片，归档到旧 6 篇的历史缺口位置。

这些位置在 story.dart 里**早已被引用**，只是文件从来没落地，
所以本脚本只补文件、不改代码。
"""
import os
import shutil
import sys

SRC = r'D:/Progect-3/generated-images'
DST = r'D:/Progect-3/wanqing_shizi/assets/images/stories'

MAP = [
    ('O01', 'market',     'c1_p2_1.png'),
    ('O02', 'market',     'c4_p2_1.png'),
    ('O03', 'market',     'c5_p2_1.png'),
    ('O04', 'simaguang',  'c3_p2_1.png'),
    ('O05', 'simaguang',  'c4_p2_1.png'),
    ('O06', 'simaguang',  'c4_p3_1.png'),
    ('O07', 'nezha',      'c1_p2_1.png'),
    ('O08', 'nezha',      'c1_p3_1.png'),
    ('O09', 'nezha',      'c1_p4_1.png'),
    ('O10', 'nezha',      'c2_p2_1.png'),
    ('O11', 'nezha',      'c2_p2_2.png'),
    ('O12', 'nezha',      'c3_p2_2.png'),
    ('O13', 'nezha',      'c4_p2_1.png'),
    ('O14', 'nezha',      'c4_p3_1.png'),
    ('O15', 'nezha',      'c5_p2_1.png'),
    ('O16', 'nezha',      'c5_p3_1.png'),
    ('O17', 'nezha',      'c6_p2_1.png'),
    ('O18', 'nezha',      'c6_p3_1.png'),
    ('O19', 'pony',       'c1_p2_1.png'),
    ('O20', 'pony',       'c4_p2_1.png'),
    ('O21', 'pony',       'c5_p3_1.png'),
    ('O22', 'whitesnake', 'c2_p2_1.png'),
    ('O23', 'whitesnake', 'c3_p2_1.png'),
    ('O24', 'whitesnake', 'c5_p2_1.png'),
    ('O25', 'havoc',      'c2_p2_1.png'),
    ('O26', 'havoc',      'c3_p2_1.png'),
    ('O27', 'havoc',      'c4_p2_1.png'),
    ('O28', 'havoc',      'c5_p2_1.png'),
    ('O29', 'havoc',      'c7_p2_1.png'),
]


def main():
    files = [f for f in os.listdir(SRC) if f.lower().endswith('.png')]
    ok = 0
    miss = []
    for token, sid, name in MAP:
        hits = [f for f in files if f.startswith(token + '_')]
        if not hits:
            miss.append(token)
            continue
        hits.sort(key=lambda f: os.path.getmtime(os.path.join(SRC, f)))
        src = os.path.join(SRC, hits[-1])
        if os.path.getsize(src) < 10 * 1024:
            miss.append(token + '(太小)')
            continue
        outdir = os.path.join(DST, sid)
        os.makedirs(outdir, exist_ok=True)
        shutil.copyfile(src, os.path.join(outdir, name))
        ok += 1
    print('已归档: %d / %d' % (ok, len(MAP)))
    if miss:
        print('缺失:', ', '.join(miss))
        return 1
    print('29 张历史缺口全部补齐。')
    return 0


if __name__ == '__main__':
    sys.exit(main())

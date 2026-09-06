# -*- coding: utf-8 -*-
"""把 generated-images 里带 SxxCyy 编号的图片，按编号归档到各故事目录。

文件名前缀规则：S01C01_xxx.png -> 第 1 篇故事（fable_shouzhu）第 1 章
目标路径：assets/images/stories/<story_id>/c<N>_p1_1.png
"""
import os
import re
import shutil
import sys

SRC = r'D:/Progect-3/generated-images'
DST = r'D:/Progect-3/wanqing_shizi/assets/images/stories'

# 顺序必须与 generated-images 编号 S01..S21 严格一致
STORY_IDS = [
    'fable_shouzhu',   # S01 守株待兔
    'fable_wangyang',  # S02 亡羊补牢
    'fable_yamiao',    # S03 揠苗助长
    'fable_hujia',     # S04 狐假虎威
    'fable_kezhou',    # S05 刻舟求剑
    'fable_jingdi',    # S06 井底之蛙
    'fable_maodun',    # S07 自相矛盾
    'fable_huashe',    # S08 画蛇添足
    'fable_zhengren',  # S09 郑人买履
    'fable_yegong',    # S10 叶公好龙
    'fable_lanyu',     # S11 滥竽充数
    'fable_maidu',     # S12 买椟还珠
    'fable_saiweng',   # S13 塞翁失马
    'fable_beigong',   # S14 杯弓蛇影
    'fable_wushibu',   # S15 五十步笑百步
    'fable_jiegan',    # S16 截竿入城
    'fable_yubang',    # S17 鹬蚌相争
    'fable_dongguo',   # S18 东郭先生和狼
    'myth_yugong',     # S19 愚公移山
    'myth_dayu',       # S20 大禹治水
    'myth_niulang',    # S21 牛郎织女
]

PAT = re.compile(r'^S(\d{2})C(\d{2})_')


def main():
    if not os.path.isdir(SRC):
        print('源目录不存在:', SRC)
        return 1

    files = [f for f in os.listdir(SRC) if f.lower().endswith('.png')]
    copied = 0
    skipped = 0
    missing = []

    for si, sid in enumerate(STORY_IDS, start=1):
        for ch in range(1, 7):
            token = 'S%02dC%02d' % (si, ch)
            hits = [f for f in files if f.startswith(token + '_')]
            if not hits:
                missing.append(token + '(' + sid + ')')
                continue
            # 同一编号若有多张（重跑），取最新的一张
            hits.sort(key=lambda f: os.path.getmtime(os.path.join(SRC, f)))
            src = os.path.join(SRC, hits[-1])
            if os.path.getsize(src) < 10 * 1024:
                missing.append(token + '(太小)')
                continue
            outdir = os.path.join(DST, sid)
            os.makedirs(outdir, exist_ok=True)
            dst = os.path.join(outdir, 'c%d_p1_1.png' % ch)
            shutil.copyfile(src, dst)
            copied += 1
            if len(hits) > 1:
                skipped += len(hits) - 1

    print('已归档: %d 张' % copied)
    if skipped:
        print('（忽略同编号重复文件: %d 个）' % skipped)
    if missing:
        print('尚未生成: %d 个 -> %s' % (len(missing), ', '.join(missing)))
    else:
        print('全部 126 张已齐。')
    return 0


if __name__ == '__main__':
    sys.exit(main())

# -*- coding: utf-8 -*-
import io, os, re, sys, zipfile
ROOT = r'D:/Progect-3/wanqing_shizi'
APK = os.path.join(ROOT, 'dist', '晚晴识字-v1.11-arm64.apk')
PREFIX = 'assets/flutter_assets/'

src = io.open(os.path.join(ROOT, 'lib/data/story.dart'), encoding='utf-8').read()
refs = re.findall(r"images: <String>\['([^']+)'\]", src)
refs = [p for p in refs if p.startswith('assets/images/stories/')]
covers = re.findall(r"cover: '([^']+)'", src)
want = sorted(set(refs) | set(c for c in covers if c.startswith('assets/images/stories/')))

z = zipfile.ZipFile(APK)
names = set(z.namelist())
missing = [p for p in want if PREFIX + p not in names]
# 只统计 21 篇新故事的 147 张
NEW = ['fable_shouzhu','fable_wangyang','fable_yamiao','fable_hujia','fable_kezhou','fable_jingdi',
       'fable_maodun','fable_huashe','fable_zhengren','fable_yegong','fable_lanyu','fable_maidu',
       'fable_saiweng','fable_beigong','fable_wushibu','fable_jiegan','fable_yubang','fable_dongguo',
       'myth_yugong','myth_dayu','myth_niulang']
new_ok = 0
for sid in NEW:
    for i in range(1, 7):
        e = PREFIX + 'assets/images/stories/%s/c%d_p1_1.png' % (sid, i)
        if e in names and z.getinfo(e).file_size > 10*1024:
            new_ok += 1
    e = PREFIX + 'assets/images/stories/%s/cover.png' % sid
    if e in names and z.getinfo(e).file_size > 10*1024:
        new_ok += 1

print('APK 内总条目: %d' % len(names))
print('story.dart 引用(去重): %d 张' % len(want))
print('引用但包内缺失: %d' % len(missing))
for p in missing[:30]: print('   MISS', p)
print('21 篇新故事应到 147 张 -> 实际到位: %d 张' % new_ok)
z.close()
sys.exit(0)

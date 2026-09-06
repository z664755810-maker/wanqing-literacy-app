# -*- coding: utf-8 -*-
import io, os, re, zipfile
ROOT = r'D:/Progect-3/wanqing_shizi'
APK = os.path.join(ROOT, 'dist', '晚晴识字-v1.11-arm64.apk')
P = 'assets/flutter_assets/'
src = io.open(os.path.join(ROOT, 'lib/data/story.dart'), encoding='utf-8').read()

# 抓取所有 images: <String>[ ... ] 列表里的每一个路径（含多元素）
refs = []
for blk in re.findall(r"images: <String>\[(.*?)\]", src, re.S):
    refs += re.findall(r"'([^']+)'", blk)
refs = [p for p in refs if p.startswith('assets/images/stories/')]
names = set(zipfile.ZipFile(APK).namelist())

OLD = ['market','simaguang','nezha','pony','whitesnake','havoc']
NEW = ['fable_shouzhu','fable_wangyang','fable_yamiao','fable_hujia','fable_kezhou','fable_jingdi',
       'fable_maodun','fable_huashe','fable_zhengren','fable_yegong','fable_lanyu','fable_maidu',
       'fable_saiweng','fable_beigong','fable_wushibu','fable_jiegan','fable_yubang','fable_dongguo',
       'myth_yugong','myth_dayu','myth_niulang']
print('%-12s %6s %6s %6s' % ('篇目', '引用', '缺失', '章节封面缺'))
tr = tm = 0
for sid in OLD + NEW:
    r = [p for p in refs if '/%s/' % sid in p]
    m = [p for p in r if P + p not in names]
    cov = len([p for p in m if p.endswith('_cover.png')])
    print('%-12s %6d %6d %6d' % (sid, len(r), len(m), cov))
    tr += len(r); tm += len(m)
print('%-12s %6d %6d' % ('合计', tr, tm))
print()
print('旧 6 篇缺失明细：')
for sid in OLD:
    r = [p for p in refs if '/%s/' % sid in p]
    for p in sorted(set(p for p in r if P + p not in names)):
        print('  ', p.split('/')[-2] + '/' + p.split('/')[-1])

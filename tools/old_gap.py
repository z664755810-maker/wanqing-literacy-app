# -*- coding: utf-8 -*-
import io, os, re, zipfile
ROOT = r'D:/Progect-3/wanqing_shizi'
APK = os.path.join(ROOT, 'dist', '晚晴识字-v1.11-arm64.apk')
P = 'assets/flutter_assets/'
src = io.open(os.path.join(ROOT, 'lib/data/story.dart'), encoding='utf-8').read()
refs = re.findall(r"images: <String>\['([^']+)'\]", src)
names = set(zipfile.ZipFile(APK).namelist())
OLD = ['market','simaguang','nezha','pony','whitesnake','havoc']
print('%-12s %-10s %-10s' % ('旧篇', '引用', '包内缺失'))
tot_r = tot_m = 0
for sid in OLD:
    r = [p for p in refs if '/%s/' % sid in p]
    m = [p for p in r if P + p not in names]
    cov = len([p for p in m if p.endswith('_cover.png')])
    print('%-12s %-10d %-10d (其中章节封面 %d)' % (sid, len(r), len(m), cov))
    tot_r += len(r); tot_m += len(m)
print('%-12s %-10d %-10d' % ('合计', tot_r, tot_m))

# -*- coding: utf-8 -*-
import io, os, re, sys
ROOT = r'D:/Progect-3/wanqing_shizi'
src = io.open(os.path.join(ROOT, 'lib/data/story.dart'), encoding='utf-8').read()
paths = re.findall(r"images: <String>\['([^']+)'\]", src)
paths = [p for p in paths if p.startswith('assets/images/stories/')]
miss = [p for p in paths if not os.path.isfile(os.path.join(ROOT, p))]
small = [p for p in paths if os.path.isfile(os.path.join(ROOT, p)) and os.path.getsize(os.path.join(ROOT, p)) < 10*1024]
print('story.dart 引用的故事图: %d 张' % len(paths))
print('磁盘缺失: %d' % len(miss))
print('小于 10KB(疑似坏图): %d' % len(small))
for p in miss[:20]: print('  MISS', p)
for p in small[:20]: print('  SMALL', p)
# 磁盘上实际有多少故事图
base = os.path.join(ROOT, 'assets/images/stories')
disk = 0
for sid in sorted(os.listdir(base)):
    d = os.path.join(base, sid)
    if os.path.isdir(d):
        disk += len([f for f in os.listdir(d) if f.lower().endswith('.png')])
print('磁盘故事图总数: %d' % disk)
sys.exit(1 if (miss or small) else 0)

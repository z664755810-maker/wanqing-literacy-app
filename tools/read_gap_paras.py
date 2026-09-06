# -*- coding: utf-8 -*-
import io, re
ROOT = r'D:/Progect-3/wanqing_shizi'
src = io.open(ROOT + '/lib/data/story.dart', encoding='utf-8').read().split('\n')
GAPS = {
 'market':     [('c1','p2'),('c4','p2'),('c5','p2')],
 'simaguang':  [('c3','p2'),('c4','p2'),('c4','p3')],
 'nezha':      [('c1','p2'),('c1','p3'),('c1','p4'),('c2','p2'),('c4','p2'),('c4','p3'),
                ('c5','p2'),('c5','p3'),('c6','p2'),('c6','p3')],
 'pony':       [('c1','p2'),('c4','p2'),('c5','p3')],
 'whitesnake': [('c2','p2'),('c3','p2'),('c5','p2')],
 'havoc':      [('c2','p2'),('c3','p2'),('c4','p2'),('c5','p2'),('c7','p2')],
}
def plain(t): return re.sub(r'\([^)]*\)', '', t)
story = chap = para = None
for ln in src:
    m = re.match(r"^  id: '([a-z_]+)',$", ln)
    if m: story = m.group(1); chap = para = None; continue
    m = re.match(r"^      id: '(c\d+)',$", ln)
    if m: chap = m.group(1); para = None; continue
    m = re.match(r"^      title: '(.+)',$", ln)
    if m and story in GAPS: pass
    m = re.match(r"^          id: '(p\d+)',$", ln)
    if m: para = m.group(1); continue
    m = re.match(r"^          ruby: '(.+)',$", ln)
    if m and story in GAPS and para:
        key = (chap, para)
        if key in GAPS[story]:
            print('%-11s %s %s | %s' % (story, chap, para, plain(m.group(1))))
    m = re.match(r"^          ruby: '(.+)$", ln)
    if m and story in GAPS and para:
        key = (chap, para)
        if key in GAPS[story]:
            print('%-11s %s %s | %s...' % (story, chap, para, plain(m.group(1))[:60]))

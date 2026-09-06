import re, io, json
p = 'D:/Progect-3/wanqing_shizi/lib/data/story.dart'
src = io.open(p, encoding='utf-8').read()
lines = src.split('\n')

# find story ids among the 21 new ones
ids = ['fable_shouzhu','fable_wangyang','fable_yamiao','fable_hujia','fable_kezhou','fable_jingdi','fable_maodun','fable_huashe','fable_zhengren','fable_yegong','fable_lanyu','fable_maidu','fable_saiweng','fable_beigong','fable_wushibu','fable_jiegan','fable_yubang','fable_dongguo','myth_yugong','myth_dayu','myth_niulang']

def plain(ruby):
    return re.sub(r'\([^)]*\)', '', ruby)

out = {}
for sid in ids:
    # locate id: 'sid'
    start = None
    for i,l in enumerate(lines):
        if l.strip() == "id: '%s'," % sid:
            start = i; break
    if start is None:
        out[sid] = 'NOT FOUND'; continue
    # scan forward until matching closing
    chapters = []
    cur_cid = None
    for j in range(start, min(start+400, len(lines))):
        s = lines[j].strip()
        m = re.match(r"id: '(c\d+)',", s)
        if m:
            cur_cid = m.group(1); continue
        m = re.match(r"title: '(.+)',\s*$", s)
        if m and cur_cid and len(chapters) < 6:
            chapters.append((cur_cid, plain(m.group(1))))
        if s == '];' and len(chapters) >= 6:
            break
    out[sid] = chapters

for sid in ids:
    print(sid, '->', len(out[sid]) if isinstance(out[sid], list) else out[sid])
    if isinstance(out[sid], list):
        for cid, t in out[sid]:
            print('   ', cid, t)

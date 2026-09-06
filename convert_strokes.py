import json, os, re

charlib = open('lib/data/char_library.dart', encoding='utf-8').read()
chars = set(re.findall(r"char:\s*'([^']+)'", charlib))

src = 'D:/Progect-3/hwdata/node_modules/hanzi-writer-data'
out = {}
sample = None
for c in chars:
    p = os.path.join(src, c + '.json')
    if not os.path.exists(p):
        continue
    try:
        d = json.load(open(p, encoding='utf-8'))
    except Exception:
        continue
    s = d.get('strokes')
    m = d.get('medians')
    if not s or not m:
        continue
    out[c] = {'s': s, 'm': m}
    if sample is None:
        sample = (c, list(d.keys()))

with open('assets/strokes.json', 'w', encoding='utf-8') as f:
    json.dump(out, f, ensure_ascii=False, separators=(',', ':'))

print('covered', len(out), 'of', len(chars), 'char_library chars')
print('sample keys of one entry:', sample)

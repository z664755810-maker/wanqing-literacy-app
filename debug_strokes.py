import json, os, re

charlib = open('lib/data/char_library.dart', encoding='utf-8').read()
chars = set(re.findall(r"char:\s*'([^']+)'", charlib))
print('chars:', len(chars))
src = '/d/Progect-3/hwdata/node_modules/hanzi-writer-data'
sample = list(chars)[:12]
for c in sample:
    p = os.path.join(src, c + '.json')
    print(repr(c), 'exists?', os.path.exists(p))
# try loading one that exists
for c in chars:
    p = os.path.join(src, c + '.json')
    if os.path.exists(p):
        d = json.load(open(p, encoding='utf-8'))
        print('loaded', repr(c), 'keys', list(d.keys()))
        break

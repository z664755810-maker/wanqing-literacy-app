import re, json

lib = open('lib/data/char_library.dart', encoding='utf-8').read()
chars = set(re.findall(r"char:\s*'([^']+)'", lib))
d = json.load(open('assets/strokes.json', encoding='utf-8'))
have = set(d.keys())
print('char_library chars:', len(chars))
print('strokes.json chars:', len(have))
missing = chars - have
print('missing from strokes.json:', len(missing))
print('sample missing:', sorted(missing)[:30])

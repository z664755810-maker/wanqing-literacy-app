"""Strip ImageGen bottom-right watermark from char illustrations.

Worker E already cropped its 9 batch-6 images (mai/qian/gei/kan/ting/shuo/shi/bu/you)
using a 90px bottom crop. Apply the same treatment to the remaining 51 images so
all 60 are watermark-free and have the same dimensions.
"""
import os
from PIL import Image

ROOT = r'D:\Progect-3\wanqing_shizi\assets\images\chars'
# These files were already cleaned by worker E; do not crop again.
EXCLUDED = {
    'mai.png', 'qian.png', 'gei.png', 'kan.png',
    'ting.png', 'shuo.png', 'shi.png', 'bu.png', 'you.png',
}
CROP_BOTTOM = 90

cropped = []
skipped = []

for fn in sorted(os.listdir(ROOT)):
    if not fn.lower().endswith('.png'):
        continue
    path = os.path.join(ROOT, fn)
    if fn in EXCLUDED:
        skipped.append(fn)
        continue
    with Image.open(path) as img:
        w, h = img.size
        if h <= CROP_BOTTOM:
            skipped.append(fn)
            continue
        out = img.crop((0, 0, w, h - CROP_BOTTOM))
        out.save(path, 'PNG')
        cropped.append(f'{fn}: {w}x{h} -> {w}x{h - CROP_BOTTOM}')

print(f'Cropped {len(cropped)} files (bottom {CROP_BOTTOM}px):')
for line in cropped:
    print(line)
print(f'\nSkipped {len(skipped)} files (already cleaned or too small):')
print(', '.join(skipped) or '(none)')

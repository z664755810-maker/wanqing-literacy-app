# 只重建 voice_manifest*.dart，不烤音频。
# 用途：v1.16 在跑 gen_audio.py 时如果中断，原 manifest 可能被截断——本脚本
# 用已有的 mp3 文件直接列出，生成两份完整（或增量）的 manifest。
# 不联网、不调 edge-tts，秒级完成。
#
# 用法：
#   python tool/rebuild_manifest.py

import json
import os

ROOT = r'D:/Progect-3/wanqing_shizi'
VOICE_LIST = os.path.join(ROOT, 'tool', 'voice_list.json')
AUDIO_DIR = os.path.join(ROOT, 'assets', 'audio')
AUDIO_DIR_NORM = os.path.join(ROOT, 'assets', 'audio_norm')
MANIFEST = os.path.join(ROOT, 'lib', 'data', 'voice_manifest.dart')
MANIFEST_NORM = os.path.join(ROOT, 'lib', 'data', 'voice_manifest_norm.dart')


def write_manifest(out_path, ok_list, audio_subdir, const_name):
    lines = []
    lines.append('// 预生成语音映射（构建流水线 tool/gen_audio.py 自动生成，勿手改）。')
    lines.append("// key = 运行时送入 TtsService.speak 的文本；value = Flutter asset key（**必须带 'assets/' 前缀**，"
                 "与 pubspec 声明一致；原生 getLookupKeyForAsset 会再补 'flutter_assets/'）。")
    lines.append('// 缺失项由 VoicePlayer 自动回落系统 TTS。')
    lines.append(f'const Map<String, String> {const_name} = <String, String>{{')
    for text, eid in ok_list:
        esc = text.replace('\\', '\\\\').replace("'", "\\'")
        lines.append(f"  '{esc}': 'assets/{audio_subdir}/{eid}.mp3',")
    lines.append('};')
    with open(out_path, 'w', encoding='utf-8') as f:
        f.write('\n'.join(lines) + '\n')


with open(VOICE_LIST, encoding='utf-8') as f:
    entries = json.load(f)

slow_ok = []   # (text, eid) 慢速
norm_ok = []   # (text, eid) 原速
slow_missing = []
norm_missing = []

for e in entries:
    eid = e['id']
    text = e['text']
    slow_file = os.path.join(AUDIO_DIR, eid + '.mp3')
    norm_file = os.path.join(AUDIO_DIR_NORM, eid + '.mp3')
    if os.path.exists(slow_file) and os.path.getsize(slow_file) > 0:
        slow_ok.append((text, eid))
    else:
        slow_missing.append((text, eid))
    if os.path.exists(norm_file) and os.path.getsize(norm_file) > 0:
        norm_ok.append((text, eid))
    else:
        norm_missing.append((text, eid))

write_manifest(MANIFEST, slow_ok, 'audio', 'kVoiceManifest')
write_manifest(MANIFEST_NORM, norm_ok, 'audio_norm', 'kVoiceManifestNorm')

print(f'[慢速] voice_manifest.dart: {len(slow_ok)} 条（缺 {len(slow_missing)} 条）')
print(f'[原速] voice_manifest_norm.dart: {len(norm_ok)} 条（缺 {len(norm_missing)} 条）')
if slow_missing:
    print(f'  慢速缺失示例: {slow_missing[:5]}')
if norm_missing:
    print(f'  原速缺失示例: {norm_missing[:5]}')
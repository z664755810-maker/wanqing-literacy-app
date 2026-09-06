# 离线语音生成流水线（构建期，不进 APK）。
# 读 tool/voice_list.json，用 edge-tts 把每条文本合成 MP3 到 assets/audio/<id>.mp3，
# 并生成 lib/data/voice_manifest.dart（text -> 'audio/<id>.mp3'）。
# 断点续传：已存在且非空的 mp3 跳过；失败最多重试 3 次。失败的文本不进 manifest，运行时回落系统 TTS。
#
# v1.16 起支持**双档输出**：
#   默认（-30% 慢速母带） → assets/audio/<id>.mp3       + lib/data/voice_manifest.dart
#   原速（+0%）           → assets/audio_norm/<id>.mp3  + lib/data/voice_manifest_norm.dart
# 两套文件一一对应，文件名都按 <id>.mp3 命名，运行时按语速档选不同档位的 manifest entry。

import json
import os
import sys
import time
import subprocess

ROOT = r'D:/Progect-3/wanqing_shizi'
VOICE_LIST = os.path.join(ROOT, 'tool', 'voice_list.json')
AUDIO_DIR = os.path.join(ROOT, 'assets', 'audio')
MANIFEST = os.path.join(ROOT, 'lib', 'data', 'voice_manifest.dart')
VOICE = 'zh-CN-XiaoxiaoNeural'

# 语速：预生成音频直接烤进「慢速」，母亲听得清。
# 原因：运行时用 MediaPlayer.setPlaybackParams 做变速（speed<1）在部分机型/编码上会 native 崩溃，
# 表现为「点一下语音直接退出软件 / 语音很不稳定」。所以这里把慢速烤进音频本身，
# 运行时永远以 1.0 播放，彻底绕开原生变速这条崩溃路径。
# 取值为 edge-tts 相对速率：-20% ≈ 0.8 倍速，温和偏慢；要更慢可改 -30%。
RATE = os.environ.get('GEN_RATE', '-30%')

# 强制重新生成（覆盖已存在的 mp3）：用于改语速后全量重生。
FORCE = os.environ.get('GEN_FORCE') == '1'

# v1.16 双档：是否同时生成「原速」版本到 assets/audio_norm/
DUAL = os.environ.get('GEN_DUAL', '1') == '1'
RATE_NORM = os.environ.get('GEN_RATE_NORM', '+0%')
AUDIO_DIR_NORM = os.path.join(ROOT, 'assets', 'audio_norm')
MANIFEST_NORM = os.path.join(ROOT, 'lib', 'data', 'voice_manifest_norm.dart')


def ensure_edge_tts():
    try:
        import edge_tts  # noqa
    except ImportError:
        print('[pip] installing edge-tts ...', flush=True)
        subprocess.check_call([sys.executable, '-m', 'pip', 'install', 'edge-tts'])


ensure_edge_tts()
import asyncio
import edge_tts

with open(VOICE_LIST, encoding='utf-8') as f:
    entries = json.load(f)

os.makedirs(AUDIO_DIR, exist_ok=True)
if DUAL:
    os.makedirs(AUDIO_DIR_NORM, exist_ok=True)

ok = []
failed = []
total = len(entries)


def write_manifest(ok_list, out_path, audio_subdir, const_name='kVoiceManifest'):
    """把已完成的条目写成 Dart manifest。每 200 条增量落盘一次，
    即使中途被中断，已生成的音频也不会白做。

    [const_name] 决定写入的常量名——慢速档用 kVoiceManifest（历史），
    原速档用 kVoiceManifestNorm（v1.16 双档新增）。
    """
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


async def synth_one(text, voice, rate, out_path, pitch='+0Hz'):
    """v1.16 起固定 pitch=+0Hz：edge-tts 每条单独合成时字间语调/语速会自然漂移，
    固定 pitch 让单字之间的基频更稳定，减少「字间语速语调不一致」的观感。
    rate 仍可调（慢速 -30% / 原速 +0%）。"""
    comm = edge_tts.Communicate(text, voice, rate=rate, pitch=pitch)
    await comm.save(out_path)


def synth(text, voice, rate, out_path):
    """同步包装 edge-tts 异步 save。"""
    try:
        asyncio.run(synth_one(text, voice, rate, out_path))
        return os.path.exists(out_path) and os.path.getsize(out_path) > 0, None
    except Exception as ex:  # noqa
        return False, str(ex)


try:
    for i, e in enumerate(entries):
        eid = e['id']
        text = e['text']
        # v1.17：可选的「合成文本」覆盖。拼音教学里呼读音汉字的字面声调与教学音不一致
        # （如「特」本音 tè 四声，教学念 tē 一声），用 tts_text 指定教学音拼音来合成，
        # 而 manifest 的 key 仍用 text（真汉字串）——运行时绝不会送拼音字母给 TTS。
        # 没有 tts_text 的条目行为与之前完全一致（向后兼容）。
        tts_text = e.get('tts_text', text)
        out = os.path.join(AUDIO_DIR, eid + '.mp3')

        # —— 慢速档（原有）——
        if (not FORCE) and os.path.exists(out) and os.path.getsize(out) > 0:
            ok.append((text, eid))
        else:
            last_err = None
            for attempt in range(3):
                ok_write, last_err = synth(tts_text, VOICE, RATE, out)
                if ok_write:
                    ok.append((text, eid))
                    break
                time.sleep(2 * (attempt + 1))
            else:
                failed.append((text, eid, last_err))

        # —— 原速档（v1.16 新增）——
        if DUAL:
            out_norm = os.path.join(AUDIO_DIR_NORM, eid + '.mp3')
            if FORCE or not (os.path.exists(out_norm) and os.path.getsize(out_norm) > 0):
                last_err = None
                for attempt in range(3):
                    ok_write, last_err = synth(tts_text, VOICE, RATE_NORM, out_norm)
                    if ok_write:
                        break
                    time.sleep(2 * (attempt + 1))
                # 原速档失败不计入 failed（不影响慢速档的可用性）

        if (i + 1) % 50 == 0:
            print(f'[{i + 1}/{total}] ok={len(ok)} fail={len(failed)}', flush=True)
        if (i + 1) % 200 == 0:
            write_manifest(ok, MANIFEST, 'audio', 'kVoiceManifest')
            if DUAL:
                write_manifest(ok, MANIFEST_NORM, 'audio_norm', 'kVoiceManifestNorm')
            print(f'  [checkpoint] manifest 已落盘 {len(ok)} 条', flush=True)
finally:
    write_manifest(ok, MANIFEST, 'audio', 'kVoiceManifest')
    if DUAL:
        write_manifest(ok, MANIFEST_NORM, 'audio_norm', 'kVoiceManifestNorm')
    print(f'[manifest] 慢速 → {len(ok)} 条写入 voice_manifest.dart', flush=True)
    if DUAL:
        print(f'[manifest] 原速 → {len(ok)} 条写入 voice_manifest_norm.dart', flush=True)

print(f'DONE ok={len(ok)} fail={len(failed)} total={total}', flush=True)
if failed:
    print('FAILURES:', flush=True)
    for t, eid, err in failed[:80]:
        print(f'  {eid}: {err} | {t[:24]}', flush=True)
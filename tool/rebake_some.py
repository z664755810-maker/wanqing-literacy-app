# 定向重烤「少量」条目（v1.17 拼音教学声调修复引入）。
#
# 为什么不用 gen_audio.py：它会顺带补齐 assets/audio_norm/ 里**所有**缺失条目
# （当前缺 800+ 条，全烤要很久）。改了几条的合成文本时，只想重烤这几条。
#
# 与 gen_audio.py 保持一致：
#   voice = zh-CN-XiaoxiaoNeural，pitch = +0Hz，慢速 -30%、原速 +0%，
#   合成文本取 tts_text（没有则回退 text），manifest key 始终用 text（另由
#   tool/rebuild_manifest.py 重建）。
#
# 用法：
#   python tool/rebake_some.py sm_2240 sm_2241 ym_2253   # 重烤指定 id（两档）
#   python tool/rebake_some.py --verify                  # 额外生成 tool/verify_*.mp3 试听样本
#
# 注意：本脚本只写 mp3，不动 manifest —— 烤完请跑 tool/rebuild_manifest.py。

import asyncio
import json
import os
import sys

import edge_tts

ROOT = r'D:/Progect-3/wanqing_shizi'
VOICE_LIST = os.path.join(ROOT, 'tool', 'voice_list.json')
AUDIO_DIR = os.path.join(ROOT, 'assets', 'audio')
AUDIO_DIR_NORM = os.path.join(ROOT, 'assets', 'audio_norm')

VOICE = 'zh-CN-XiaoxiaoNeural'
RATE_SLOW = '-30%'
RATE_NORM = '+0%'
PITCH = '+0Hz'

# v1.17 拼音教学声调：需要「一声教学音」的条目（A 类专属 + B 类隔离）。
PINYIN_TARGETS = (
    'sm_2240',  # 特  tè  -> tē
    'sm_2241',  # 讷  nè  -> nē
    'sm_2242',  # 勒  lè  -> lē
    'ym_2253',  # 鹅  é   -> ē
    'ym_2258',  # 奥  ào  -> āo
    'ym_2268',  # 昂  áng -> āng
    'py_de',    # 得·py dē
    'py_ri',    # 日·py rī
    'py_ai',    # 爱·py āi
    'py_er',    # 儿·py ēr
)

# 试听样本（--verify）：让用户对比「教学音一声」与「本音」，确认听感。
VERIFY_SAMPLES = (
    ('verify_py_de.mp3', 'dē'),            # 拼音教学音（一声）
    ('verify_py_ri.mp3', 'rī'),
    ('verify_py_ai.mp3', 'āi'),
    ('verify_py_er.mp3', 'ēr'),
    ('verify_char_de_benpin.mp3', '得'),   # 本音 dé（char_231，对照用）
)


async def synth(text, out_path, rate):
    """合成一条；失败最多重试 3 次。返回是否成功。"""
    for attempt in range(3):
        try:
            comm = edge_tts.Communicate(text, VOICE, rate=rate, pitch=PITCH)
            await comm.save(out_path)
            if os.path.exists(out_path) and os.path.getsize(out_path) > 0:
                return True
        except Exception as ex:  # noqa
            print(f'    ! 第 {attempt + 1} 次失败: {ex}', flush=True)
        await asyncio.sleep(2 * (attempt + 1))
    return False


async def bake_entry(eid, tts_text):
    """烤一个 id 的两档（慢速 + 原速）。返回 (slow_ok, norm_ok)。"""
    slow = os.path.join(AUDIO_DIR, eid + '.mp3')
    norm = os.path.join(AUDIO_DIR_NORM, eid + '.mp3')
    ok_s = await synth(tts_text, slow, RATE_SLOW)
    ok_n = await synth(tts_text, norm, RATE_NORM)
    return ok_s, ok_n


async def main(argv):
    want_verify = '--verify' in argv
    ids = [a for a in argv if not a.startswith('--')]
    if not ids:
        ids = list(PINYIN_TARGETS)

    with open(VOICE_LIST, encoding='utf-8') as f:
        entries = json.load(f)
    by_id = {e['id']: e for e in entries}

    os.makedirs(AUDIO_DIR, exist_ok=True)
    os.makedirs(AUDIO_DIR_NORM, exist_ok=True)

    print(f'目标 {len(ids)} 条，两档共 {len(ids) * 2} 个 mp3', flush=True)
    failed = []
    for eid in ids:
        e = by_id.get(eid)
        if e is None:
            print(f'  !! voice_list.json 里没有 {eid}，跳过', flush=True)
            failed.append(eid)
            continue
        # 合成文本优先用 tts_text（教学音拼音），没配就用 text
        tts_text = e.get('tts_text', e['text'])
        ok_s, ok_n = await bake_entry(eid, tts_text)
        size_s = os.path.getsize(os.path.join(AUDIO_DIR, eid + '.mp3')) if ok_s else 0
        size_n = os.path.getsize(os.path.join(AUDIO_DIR_NORM, eid + '.mp3')) if ok_n else 0
        print(f'  {eid:9s} text={e["text"]!r} tts={tts_text!r} '
              f'慢速={"OK" if ok_s else "FAIL"}({size_s}) 原速={"OK" if ok_n else "FAIL"}({size_n})',
              flush=True)
        if not (ok_s and ok_n):
            failed.append(eid)

    if want_verify:
        print(f'生成 {len(VERIFY_SAMPLES)} 个试听样本到 tool/', flush=True)
        for name, text in VERIFY_SAMPLES:
            out = os.path.join(ROOT, 'tool', name)
            ok = await synth(text, out, RATE_SLOW)
            size = os.path.getsize(out) if os.path.exists(out) else 0
            print(f'  {name:32s} text={text!r} {"OK" if ok else "FAIL"}({size})', flush=True)

    print(f'DONE ok={len(ids) - len(failed)} fail={len(failed)}', flush=True)
    if failed:
        print('FAILED:', ', '.join(failed), flush=True)
        return 1
    return 0


if __name__ == '__main__':
    sys.exit(asyncio.run(main(sys.argv[1:])))

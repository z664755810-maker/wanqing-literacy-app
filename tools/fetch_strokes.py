#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""晚晴识字 · 笔顺数据抓取工具（构建期一次性使用）

从 cdn.jsdelivr.net 抓取 hanzi-writer-data 的单字笔顺，合并压缩为 assets/strokes.json。

    {"饭": {"s": ["M 259 579 ... Z", "..."], "m": [[[x, y], [x, y]], ...]}}

- s = 每笔轮廓 SVG path（1024x1024 网格，y 轴向下，渲染时需翻转）
- m = 每笔中线点列（medians，用于"笔尖沿中线行走"的书写动画）

⚠️ 重要：这是**构建期**行为。产物随 APK 分发，运行时零网络请求。
   合规：hanzi-writer-data 派生自文鼎（Arphic PL）字体，适用 Arphic Public License
   —— 允许免费使用与再分发，禁止单独出售字数据本身。本项目自用非商业且随 APK
   整体分发，属许可范围内。

用法：
    python tools/fetch_strokes.py                 # 按 tools/chars_v1.txt 抓取
    python tools/fetch_strokes.py --chars 饭门钱   # 指定字
"""
from __future__ import annotations

import argparse
import json
import os
import sys
import time
import urllib.parse
import urllib.request

BASE = "https://cdn.jsdelivr.net/npm/hanzi-writer-data@2.0.1/"
DEFAULT_CHAR_FILE = os.path.join(os.path.dirname(__file__), "chars_v1.txt")
OUT = os.path.abspath(
    os.path.join(os.path.dirname(__file__), "..", "assets", "strokes.json")
)


def read_chars(path: str) -> list[str]:
    with open(path, encoding="utf-8") as f:
        raw = "".join(f.read().split())
    # 去重保序
    seen: set[str] = set()
    out: list[str] = []
    for ch in raw:
        if ch not in seen:
            seen.add(ch)
            out.append(ch)
    return out


def fetch(ch: str, timeout: float = 20.0) -> dict | None:
    url = BASE + urllib.parse.quote(ch) + ".json"
    req = urllib.request.Request(url, headers={"User-Agent": "wanqing-shizi/1.0"})
    with urllib.request.urlopen(req, timeout=timeout) as resp:
        data = json.loads(resp.read().decode("utf-8"))
    strokes = data.get("strokes") or []
    medians = data.get("medians") or []
    if not strokes:
        return None
    # 坐标取整，压缩体积（medians 是 [[x, y], ...]）
    medians = [[[round(float(x)), round(float(y))] for x, y in stroke] for stroke in medians]
    return {"s": strokes, "m": medians}


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--chars", help="要抓取的字（直接给出，空格或连续均可）")
    ap.add_argument("--char-file", default=DEFAULT_CHAR_FILE)
    ap.add_argument("--out", default=OUT)
    ap.add_argument("--force", action="store_true", help="忽略已有结果，全部重抓")
    args = ap.parse_args()

    chars = read_chars(args.char_file) if not args.chars else [c for c in args.chars if c.strip()]

    merged: dict[str, dict] = {}
    if os.path.exists(args.out) and not args.force:
        try:
            with open(args.out, encoding="utf-8") as f:
                merged = json.load(f)
        except Exception as exc:  # noqa: BLE001
            print(f"[warn] 读取已有 {args.out} 失败，将重新生成：{exc}", file=sys.stderr)

    ok, fail = 0, []
    for i, ch in enumerate(chars, 1):
        if ch in merged and not args.force:
            ok += 1
            continue
        try:
            got = fetch(ch)
        except Exception as exc:  # noqa: BLE001
            print(f"[{i}/{len(chars)}] {ch} 失败：{exc}", file=sys.stderr)
            fail.append(ch)
            continue
        if got is None:
            print(f"[{i}/{len(chars)}] {ch} 无笔顺数据", file=sys.stderr)
            fail.append(ch)
            continue
        merged[ch] = got
        ok += 1
        print(f"[{i}/{len(chars)}] {ch} ok ({len(got['s'])} 笔)")
        time.sleep(0.05)

    os.makedirs(os.path.dirname(args.out), exist_ok=True)
    with open(args.out, "w", encoding="utf-8") as f:
        json.dump(merged, f, ensure_ascii=False, separators=(",", ":"))

    size = os.path.getsize(args.out)
    print(f"\n完成：{ok} 字写入 {args.out}（{size/1024:.1f} KB）")
    if fail:
        print(f"失败/无数据 {len(fail)} 字：{''.join(fail)}")
        print("→ 这些字在 UI 上会自动隐藏「看笔顺」，降级为「整字描红 + 笔画名称朗读」，不影响使用。")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

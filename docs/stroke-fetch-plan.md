# 笔顺数据抓取方案（Python）

> 归属：T05 · 设计者：高见远（架构师）· 执行者：software-engineer
> 状态：**设计完成，等待两件事放行** —— ① 原 Q2（hanzi-writer-data 许可）答复；② 字表定稿。
> 相关文档：`docs/ARCHITECTURE.md` §1.3（难点 2）、§7.5（存储约定）

---

## 1. 目标与硬约束

| 项 | 要求 |
|---|---|
| 目标 | 为字库每个字提供**逐笔轮廓路径 + 中线点**，供 `StrokeAnimator` 做逐笔慢速书写动画 |
| 纯离线 | **运行时零请求**。数据在**开发机**上一次性抓取，产物 `assets/strokes.json` 打进 APK |
| 零依赖 | 抓取脚本**只用 Python 标准库**（urllib / json / gzip / pathlib），不装 requests 等第三方包 |
| 体积 | 60 字 ≈ 90–150 KB；126 字 ≈ 190–300 KB（对 APK 可忽略） |
| 降级 | 某字抓取失败 → 该字自动降级为"整字描红 + 笔画名"，**绝不空白、绝不报错** |

**合规前提**：`hanzi-writer-data` 派生自文鼎（Arphic PL）字体，适用 Arphic Public License —— 允许免费使用与再分发，禁止单独出售字数据本身。本项目自用非商业、随 APK 整体分发，属许可范围。**此项（原 Q2）尚未答复，答复前不要执行抓取。**

---

## 2. 数据源（按优先级，命中即止）

| 优先级 | 源 | URL 模板 | 备注 |
|---|---|---|---|
| 1 | jsDelivr（**已实测 200**） | `https://cdn.jsdelivr.net/npm/hanzi-writer-data@2.0.1/<字>.json` | 首选。实测 `饭.json` = 2442 字节 / 7 笔 |
| 2 | unpkg | `https://unpkg.com/hanzi-writer-data@2.0.1/<字>.json` | jsDelivr 挂了的兜底 |
| 3 | npmmirror（国内） | `https://registry.npmmirror.com/hanzi-writer-data/-/hanzi-writer-data-2.0.1.tgz` | 整包 tgz，需 `tarfile` 解包后取 `package/<字>.json`。一次 ~10MB，适合批量 |
| 4 | GitHub raw | `https://raw.githubusercontent.com/chanind/hanzi-writer-data/master/<字>.json` | 最后手段 |

**统一用优先级 1**；连续 5 个字失败则整源切换到下一档。

**URL 编码**：汉字必须 percent-encode，`urllib.parse.quote('饭')` → `%E9%A5%AD`。直接拼汉字 URL 在部分代理下会失败。

---

## 3. 数据格式与坐标系（关键，错一笔就整体翻转）

### 3.1 单字 JSON 结构

```json
{
  "strokes": [
    "M 332 412 Q 322 388 305 371 Q 291 350 274 331 L 246 305 ... Z",
    "M 508 499 Q 496 479 479 462 ... Z"
  ],
  "medians": [
    [[332, 412], [305, 371], [274, 331], [246, 305]],
    [[508, 499], [479, 462], ...]
  ]
}
```

- `strokes[]`：每笔的**轮廓** SVG path，闭合（`Z`）。命令只有 `M / L / Q / C / Z` 五种 —— 解析器只需支持这 5 种。
- `medians[]`：每笔的**中线点列**，用于"笔尖沿中线行走"的书写动画。`medians.length === strokes.length` **必须校验**。
- 坐标：1024 × 1024 em 方框，**y 轴向上**，字形占 y ∈ `[-124, 900]`（基线 0，上伸 900，下伸 -124）。

### 3.2 渲染变换（hanzi-writer 官方做法）

hanzi-writer 渲染时用的 SVG 变换是：

```
scale(1, -1) translate(0, -900)
```

SVG 的 transform 从右往左作用，即 `p → scale(translate(p))`，最终 **`y' = 900 - y`**（y 轴翻正并平移）。

在 Flutter `Canvas` 里等价写法（`s = size / 1024`）：

```dart
canvas.save();
canvas.translate(0, 900 * s);   // 先平移
canvas.scale(s, -s);            // 再缩放（含 y 翻转）
// 此时点 (x, y) 落在 (s*x, s*(900 - y))
... 绘制 ...
canvas.restore();
```

> ⚠️ **必须先自校验再批量渲染**。判据：用「十」试渲染 —— 正确时**横笔在竖笔上方偏下位置、整体居中**；错误（漏了翻转）时**字上下颠倒**。再拿「上」验一次（长横应在底部）。

### 3.3 输出格式（assets/strokes.json）

用短 key + 整数坐标压缩：

```json
{
  "v": 1,
  "chars": {
    "饭": {
      "s": ["M 332 412 Q ...", "..."],
      "m": [[[332,412],[305,371]], [[...]]]
    }
  }
}
```

- `"v"`：格式版本号，运行时校验用。
- 坐标**取整**（`round()`），不损失可见精度（1024 网格下 1 单位 ≈ 0.1% 字宽），体积降 30%+。
- 序列化：`json.dumps(data, ensure_ascii=False, separators=(',', ':'))`。

---

## 4. 抓取脚本设计：`tools/fetch_strokes.py`

```python
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
晚晴识字 —— 笔顺数据抓取（构建期一次性执行，运行时零请求）

用法:
    python tools/fetch_strokes.py                 # 抓全部字表
    python tools/fetch_strokes.py --only 饭 水 门  # 只抓指定字
    python tools/fetch_strokes.py --retry-missing # 只重试上次失败的

输出:
    assets/strokes.json          主产物（打进 APK）
    tools/_cache/<字>.json       原始缓存（可删，脚本幂等）
    tools/_cache/missing.txt     抓取失败的字（一行一个）
    tools/_cache/stroke-count.txt  "字<TAB>笔画数"，供字库录入笔画名时核对

依赖: 仅 Python 标准库。
"""
import argparse
import json
import sys
import time
import urllib.error
import urllib.parse
import urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
CACHE = ROOT / "tools" / "_cache"
OUT = ROOT / "assets" / "strokes.json"

# 数据源：优先级从高到低
SOURCES = [
    "https://cdn.jsdelivr.net/npm/hanzi-writer-data@2.0.1/{q}.json",
    "https://unpkg.com/hanzi-writer-data@2.0.1/{q}.json",
    "https://raw.githubusercontent.com/chanind/hanzi-writer-data/master/{q}.json",
]

TIMEOUT = 10          # 秒。本机网络不稳，宁可快速失败换源
RETRY = 3
UA = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) wanqing-shizi-build/1.0"
SLEEP_BETWEEN = 0.05  # 礼貌间隔，避免被 CDN 限流


def load_charlist() -> list[str]:
    """字表来源：docs/char-library-extended.md 里的课程表。
    ⚠️ 实施时改为直接 import lib/data/char_library.dart 的 key，
       或用下面的 CHARS 常量兜底，确保与字库**永远一致**（不允许两份清单漂移）。"""
    return CHARS


def fetch_one(ch: str) -> dict | None:
    q = urllib.parse.quote(ch)
    for url_tpl in SOURCES:
        url = url_tpl.format(q=q)
        for attempt in range(RETRY):
            try:
                req = urllib.request.Request(url, headers={"User-Agent": UA})
                with urllib.request.urlopen(req, timeout=TIMEOUT) as resp:
                    raw = resp.read().decode("utf-8")
                data = json.loads(raw)
                # 结构校验：缺一不可，长度必须相等
                if not isinstance(data.get("strokes"), list) or not data["strokes"]:
                    raise ValueError("strokes 缺失或为空")
                if not isinstance(data.get("medians"), list):
                    raise ValueError("medians 缺失")
                if len(data["strokes"]) != len(data["medians"]):
                    raise ValueError(
                        f"笔画数不匹配 {len(data['strokes'])} != {len(data['medians'])}"
                    )
                return data
            except (urllib.error.URLError, urllib.error.HTTPError,
                    TimeoutError, json.JSONDecodeError, ValueError) as e:
                if attempt == RETRY - 1:
                    print(f"  [失败] {ch} <- {url_tpl.split('/')[2]}: {e}")
                    break
                time.sleep(0.4 * (attempt + 1))
    return None


def compact(data: dict) -> dict:
    """压缩：坐标取整，只保留 s / m 两个字段。"""
    def rnd(pt):
        return [round(pt[0]), round(pt[1])]
    return {
        "s": data["strokes"],
        "m": [[rnd(p) for p in stroke] for stroke in data["medians"]],
    }


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--only", nargs="*", default=None)
    ap.add_argument("--retry-missing", action="store_true")
    args = ap.parse_args()

    CACHE.mkdir(parents=True, exist_ok=True)
    chars = args.only or load_charlist()
    if args.retry_missing:
        mf = CACHE / "missing.txt"
        chars = mf.read_text(encoding="utf-8").split() if mf.exists() else []
    chars = list(dict.fromkeys(chars))  # 去重保序

    ok, missing = {}, []
    for i, ch in enumerate(chars, 1):
        cf = CACHE / f"{ch}.json"
        if cf.exists():                       # 幂等：已缓存直接用
            data = json.loads(cf.read_text(encoding="utf-8"))
        else:
            print(f"[{i}/{len(chars)}] 抓取 {ch} ...", end="", flush=True)
            data = fetch_one(ch)
            if data is None:
                missing.append(ch)
                print(" ✗")
                continue
            cf.write_text(json.dumps(data, ensure_ascii=False), encoding="utf-8")
            print(" ✓")
            time.sleep(SLEEP_BETWEEN)
        ok[ch] = compact(data)

    OUT.parent.mkdir(parents=True, exist_ok=True)
    OUT.write_text(
        json.dumps({"v": 1, "chars": ok}, ensure_ascii=False, separators=(",", ":")),
        encoding="utf-8",
    )
    (CACHE / "missing.txt").write_text("\n".join(missing), encoding="utf-8")
    (CACHE / "stroke-count.txt").write_text(
        "\n".join(f"{c}\t{len(ok[c]['s'])}" for c in ok), encoding="utf-8"
    )

    print(f"\n完成：成功 {len(ok)} / 失败 {len(missing)}")
    print(f"产物：{OUT.relative_to(ROOT)}  ({OUT.stat().st_size / 1024:.1f} KB)")
    if missing:
        print(f"失败字（已写入 missing.txt，可 --retry-missing 重试）：{' '.join(missing)}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
```

### 4.1 脚本要点说明

| 设计点 | 原因 |
|---|---|
| **幂等 + 本地缓存** | 网络不稳，重跑不重下已成功的字；`tools/_cache/` 建议加 `.gitignore` |
| **结构强校验**（`strokes`/`medians` 非空且长度相等） | 脏数据会在运行时把 `StrokeAnimator` 搞崩，必须在抓取期拦掉 |
| **多源自动切换** | jsDelivr 偶尔抽风；本机代理环境不可预测 |
| **快速失败**（10s 超时 + 3 次重试） | 与其卡 5 分钟，不如快速换源。这是本机环境最重要的经验 |
| **`stroke-count.txt` 副产物** | 字库录入**笔画名**时用它核对笔数，避免手写笔顺名写错笔数 |
| **字表单一来源** | ⚠️ 脚本必须复用字库的 key（见下），**禁止再维护一份字清单** |

### 4.2 ⚠️ 字表单一来源（防漂移）

`load_charlist()` 里我留了 `CHARS` 常量兜底，但**正式实施时不要用它**。两份清单必然会漂移，最后出现"字库有 126 个字、笔顺只抓了 120 个"的哑巴 bug。

推荐做法（选一）：
1. **推荐**：脚本读取 `lib/data/char_library.dart`，用正则提取所有 `CharCard(` 的 `char:` 字段 —— 与代码强一致。
2. 或：把字表维护成 `tools/charlist.txt`（一行一个字），`char_library.dart` 的录入与脚本**都**以它为准，并加一个 CI 式校验（字数必须相等）。

---

## 5. 待抓取清单

### 5.1 V1.0 首批：60 字（课 1–20）

```
我你 好  人 口 手   大 小 多   一 二 三   上 下 中
天 日 月  家 门 开   关 出 入   来 去 回   吃 饭 水
喝 米 面  菜 肉 汤   碗 筷 锅   衣 鞋 帽   洗 脸 牙
睡 起 床  走 路 车   买 钱 给   看 听 说   是 不 有
```

逐字清单（供脚本/校验使用，共 60）：

```
我 你 好 人 口 手 大 小 多 一
二 三 上 下 中 天 日 月 家 门
开 关 出 入 来 去 回 吃 饭 水
喝 米 面 菜 肉 汤 碗 筷 锅 衣
鞋 帽 洗 脸 牙 睡 起 床 走 路
车 买 钱 给 看 听 说 是 不 有
```

### 5.2 扩展批次：课 21–42，新增 66 字（累计 126 字）

```
早 午 晚  今 明 年  时 分 点  站 坐 停  前 后 左
右 里 外  住 房 屋  灯 电 话  冷 热 火  病 药 医
男 女 老  白 黑 红  爸 妈 孙  哥 姐 弟  心 想 爱
谢 请 对  会 要 做  元 块 角  少 长 在  十 百 千
了 的 这  个 和 就
```

> 字表来源与释义见 `docs/char-library-extended.md`。
> **课 41–42（了的这 / 个和就）是虚词补充包**，强烈建议一并抓取 —— 没有这 6 个字，短句库写不出自然句子（详见扩展文档 §4）。

---

## 6. 体积与运行时性能

| 批次 | 原始（60/126 字） | 取整+紧凑后估算 |
|---|---|---|
| V1.0 60 字 | ~147 KB（2442 B × 60） | **90–150 KB** |
| 扩展 126 字 | ~308 KB | **190–300 KB** |

**运行时加载策略**（重要，别在主线程干这事）：

1. `assets/strokes.json` 整文件在 APK 中**不压缩存储**（Flutter assets 默认 stored），读取很快。
2. **不要在 `main()` 里同步解析 300KB JSON** —— 低端机约 100–300ms，会拖慢启动。
   - 正确做法：`AppState.init()` 里**异步后台**解析（`await` 但不阻塞首屏），字卡页首次点"看笔顺"时若未就绪则显示进度圈（< 1 秒）。
3. 解析后按字存 `Map<String, StrokeData>`，单字首次取用时才 `Path.parse`，之后缓存 `ui.Path`（`Path` 不可跨 isolate，但在主 isolate 缓存即可）。
4. `StrokeData.load()` 失败/缺字一律返回 `null`，**绝不 throw**。

---

## 7. 失败与降级（S2，必须实现）

```
字卡页点「看笔顺」
   │
   ├─ StrokeData.has(char) == true
   │     → S1：逐笔轮廓 + 中线动画（慢速、可暂停、可重复、可跟写）
   │
   └─ false（抓取失败 / 尚未解析完成 / 许可未通过）
         → S2：整字描红（系统字体渲染浅灰底字）
               + 笔画名序列（来自 CharCard.strokeNames）
               + 「第 k / N 笔」分步引导
               + 点笔画名 → TTS 念该笔画名（真实汉字，符合 TTS 铁律）
         → 界面上**不显示"数据缺失"字样**，只当作一种正常的展示形态
```

**S2 是 V1.0 的交付底线**，不依赖任何外部数据，必须实现。S1 是"能拿到就赚到"。两条路径共用同一个 `StrokeAnimator` 组件接口，切换对页面透明。

---

## 8. 执行与验收

### 8.1 执行

```bat
cd /d D:\Progect-3\wanqing_shizi
python tools/fetch_strokes.py
:: 若有失败字：
python tools/fetch_strokes.py --retry-missing
```

（脚本只依赖标准库，Python 3.13 直接可跑，无需 venv / pip install。）

### 8.2 验收清单

- [ ] `assets/strokes.json` 存在，`v == 1`，字数 == 字库字数
- [ ] 每个字 `s.length == m.length`（脚本已强制校验，仍建议抽查 5 个字）
- [ ] 抽查渲染：渲染「十」「上」「饭」三字，**字形正立、居中、无上下翻转**
- [ ] 抽查渲染：渲染「一」只有 1 笔；「饭」7 笔（与 `stroke-count.txt` 一致）
- [ ] 体积：126 字时 `assets/strokes.json` ≤ 350 KB
- [ ] 断网后 App 内笔顺动画**正常播放**（纯离线硬校验）
- [ ] 人为删掉 `assets/strokes.json` 中某字 → 该字自动降级为 S2，**不崩溃、不空白**
- [ ] `assets/` 已在 `pubspec.yaml` 的 `flutter.assets` 声明

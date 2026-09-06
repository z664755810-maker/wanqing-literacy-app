# 晚晴识字 v1.6 交付概览（2026-09-01）

## 本次目标
给字库 60 个单字各配一张生活化插图，母亲学每个字都能看到对应实物图。

## 交付物
- **APK**：`dist/晚晴识字-v1.6-arm64.apk`（246,807,520 B ≈ 235 MB，已签名）
  - `apksigner verify` 通过，签名者 CN=Wanqing Shizi
  - 包内 `assets/images/chars/` 共 **60 张**单字插图齐全；总 PNG 391 张
  - 纯离线、arm64 单包（API 26+）、零新增 pub 依赖

## 做了什么
1. **数据/UI 接线**（沿用既有槽位）
   - `CharCard.picFile/picPath` 已存在；`scripts_assign_picfile.py` 给 60 字插入 `picFile` 映射（同音歧义 `一/衣`→`yi/yi2`、`水/睡`→`shui/shui2`）。
   - 新增 `lib/widgets/char_pic.dart`，带 `errorBuilder` 优雅降级（缺图不崩）；接入 `char_detail` / `dictionary` / `hanzi` 三个界面。
2. **生成 60 张插图**
   - ImageGen（deferred 工具，1024×1024 / medium），中国传统简笔绘本风、宣纸米色、墨线平涂、画面无任何文字。
   - 多 worker 并行 + 重发补齐，全部落 `assets/images/chars/<pinyin>.png`。
3. **去水印（关键）**
   - ImageGen 图自带右下角「AI生成 / WORKBUDDY」角标，违反「画面无文字」红线。
   - 用 `scripts_strip_watermark.py`（Pillow 裁底 90px）统一去除 51 张；worker E 先裁的 9 张跳过，最终 60 张全无水印。
4. **构建**
   - `pubspec.yaml` → `1.6.0+10`；`flutter analyze` 0 error（仅 pre-existing info）。
   - 因 worker E 的洗净版（合规「钱」、修正「是」）在首打之后才落盘，去水印后**重打第二版**。

## 关键教训（可复用）
- ImageGen 生成图自带角标水印 → 交付前必须批量去水印。
- 多 worker 同秒生成文件名碰撞会内容错乱 → 逐张顺序生成或落盘即复制。
- 角标之外还有内容歧义（钱画成领导人像、是画成汤碗）→ 需人工抽检修正。
- worker 若在 build 之后改了源图，必须重打 APK 才进包（build 只快照当时磁盘）。

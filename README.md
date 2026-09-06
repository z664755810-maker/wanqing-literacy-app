# 晚晴识字 · 成人汉字/拼音学习平板应用（Flutter）

为约 50 岁、未受义务教育、仅识少量基础汉字的母亲打造的荣耀平板识字课堂。
稳重、有课堂感，**坚决去儿童化**；内容贴合她的真实生活（烧香信佛、老家河南、二十四节气、厨房日常）。

## 运行方式（在你的 D: Flutter 环境）

本工程只含 `pubspec.yaml` + `lib/**`，平台壳（android/ios）需由 Flutter SDK 生成。

```bash
# 1. 进入工程目录（建议用你 D: 盘的 Flutter 环境）
cd D:\Progect-3\wanqing_shizi

# 2. 生成平台工程（已存在 lib/pubspec 不会覆盖）
flutter create --platforms=android,ios .

# 3. 拉依赖
flutter pub get

# 4. 连上荣耀平板（或开模拟器）后运行
flutter run
```

> 若 `flutter create .` 提示目录已含 pubspec，可改为：
> `flutter create wanqing_tmp` 新建一个空工程，然后把本工程的 `lib/` 和 `pubspec.yaml` 覆盖进去，再 `flutter pub get && flutter run`。

运行前可用 `flutter doctor` 确认 Android SDK / 设备连接正常。

## 工程结构

```
lib/
  main.dart                  # 入口：初始化 TTS/存储、横竖屏、路由
  theme/app_theme.dart       # 宣纸/墨/黛青/赭石 主题，宋体回退
  data/content.dart          # 拼音表(已校验) / 汉字字典 / 阅读故事
  services/
    tts_service.dart         # 系统 TTS(zh-CN)，声母播真实音节避免拼字母
    store.dart               # 收藏 / 连续打卡 / 复习间隔盒(本地 SharedPreferences)
  widgets/
    app_bottom_nav.dart      # 底部五导航
    stroke_widget.dart       # 田字格 + 笔顺动画(CDN 取数据，离线降级大字)
  screens/
    home_screen.dart         # 首页
    pinyin_screen.dart       # 拼音小课堂 + 声母/韵母/声调
    hanzi_screen.dart        # 系统课程 + 文化分类 + 收藏
    char_detail_screen.dart  # 字详情：大字+拼音+笔顺+释义例句+收藏
    read_screen.dart         # 阅读：已学字高亮 + 整篇朗读 + 点字查
    review_screen.dart       # 听音辨字 + 待复习(间隔盒)
```

## 已落地的关键决策

- **技术栈**：Flutter（单代码库出 Android）。
- **语音**：系统 TTS（zh-CN），语速 0.5、平稳；接口已预留，后续可换讯飞/火山成人播音员音。
- **声母发音修复**：zh/ch/sh 等点击播放“真实音节示例”（如 zh→知 zhī），不再被拆成字母念。
- **拼音小课堂**：先讲“拼音是什么 / 为什么学 / 怎么拼 / 声调决定意思”，再进入分项。
- **汉字**：系统课程（数字·身体·自然·家庭·方向）按主题进阶；文化分类覆盖二十四节气 / 传统节日 / 神仙民俗 / 老家河南 / 厨房饮食；每字含笔顺动画 + 释义 + 例词例句 + 收藏。
- **阅读**：8 篇故事（烧香 / 念佛 / 财神 / 立春 / 过年 / 河南老家 / 厨房学问 / 身体信号），已学字蓝色高亮、点字可查，整篇朗读。
- **复习**：听音辨字（练耳）+ 待复习列表（间隔盒 Leitner 1–5，记错即重现、记对仍回炉）。
- **横竖屏**：均支持，布局响应式（平板默认横屏由设备/用户决定）。

## 已知待办（下一轮迭代）

1. **笔顺离线包**：当前笔顺数据首次联网从 CDN 取、会话内缓存；正式版把 stroke JSON 内置 `assets/`，断网也能逐笔描红。
2. **定时提醒**：复习调度逻辑已就绪，但本地通知（flutter_local_notifications + 权限/渠道）尚未接线，需真机调。
3. **播音员音**：TTS 服务接口已留，接讯飞/火山后替换即可，更自然稳重。
4. **宋体字体内置**：当前中文走系统回退（部分 Android 非宋体）；内置思源宋体后“课堂感”更足。
5. **手写画板**：复习“认识·手写”目前用提示框确认；可加真实手指田字格手写识别，写错即标仍需复习。
6. **内容扩充**：字库/故事可由你（儿子）在 `data/content.dart` 持续增补，题材已覆盖其信仰、老家、生活经验。

## 依赖

flutter_tts / shared_preferences / http / path_drawing

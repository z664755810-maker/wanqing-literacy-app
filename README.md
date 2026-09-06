# 晚晴识字 · 成人汉字/拼音学习平板应用（Flutter）

> 为约 50 岁、未受义务教育、有拼音基础的母亲定制的**纯离线**安卓识字 App。
> 稳重、有课堂感，**坚决去儿童化**；内容贴合她的真实生活（河南农村、起居饮食、节气日用）。

- 当前版本：**v1.17.0**（versionCode 21）
- 仓库：https://github.com/z664755810-maker/wanqing-literacy-app
- 安装包：https://github.com/z664755810-maker/wanqing-literacy-app/releases/download/v1.17/wanqing-shizi-v1.17-arm64.apk

## 📖 完整文档

**👉 接手开发请先读 [`docs/项目总结.md`](docs/项目总结.md)** —— 涵盖用户画像、架构、语音系统、打包流程、v1.17 声调修正来龙去脉、开发红线、排错手册。

历史版本说明见 `docs/` 下 `v1.7` ~ `v1.11-更新说明.md`。

## 快速开始

### 环境（本机路径，换机器需改）

| 工具 | 路径 |
|---|---|
| Flutter SDK | `D:\flutter_sdk\flutter` |
| JDK 17 | `D:\jdk\zulu17.68.203-ca-jdk17.0.20.1-win_x64` |
| Android SDK | `D:\android_sdk` |
| Gradle 用户目录 | `D:\gradle_user_home` |

从 GitHub clone 后**不能直接构建**，还需补两样（都在 `.gitignore` 里）：

1. `android/local.properties` —— 填本机 `sdk.dir` / `flutter.sdk`
2. 签名密钥 `android/keystore/wanqing.jks` + `android/key.properties`（自建，见下）

### 构建

```bash
cd D:/Progect-3/wanqing_shizi

# 首次：插件符号链接在本机受限，用 PowerShell 建 junction 代替
# PowerShell: New-Item -ItemType Junction -Path <插件路径> -Target <缓存路径>

export JAVA_HOME="D:/jdk/zulu17.68.203-ca-jdk17.0.20.1-win_x64"   # ⚠️ Windows 路径，不能写 /d/jdk/...
export GRADLE_USER_HOME="D:/gradle_user_home"                      # ⚠️ 必须是这个目录

flutter pub get
flutter build apk --release --split-per-abi --no-tree-shake-icons
# 产物：build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
```

### 自建签名密钥

```bash
keytool -genkey -v -keystore android/keystore/wanqing.jks \
  -keyalg RSA -keysize 2048 -validity 10000 -alias wanqing
```

## 技术要点

- **Flutter + 仅 2 个依赖**：`flutter_tts`、`shared_preferences`（红线：不新增 pub 依赖）
- **纯离线**：`AndroidManifest` 显式 `tools:node="remove"` 掉 INTERNET 权限
- **语音**：edge-tts 在开发机预生成为 mp3（2297 条 × 慢速/原速双档），打包进 APK，
  运行时经 Kotlin `MethodChannel('wanqing/audio')` + 原生 MediaPlayer 播放，**不走系统 TTS**
- **复习**：间隔重复 1 / 3 / 7 / 30 天四档，答对升档、答错回档

## 内容规模

| 内容 | 数量 |
|---|---|
| 汉字字库 | 357 字 / 119 课 / 43 个生活分类 |
| 拼音课程 | 声母 22 + 韵母 25 + 整体认读 17 |
| 故事屋 | 27 本 / 158 章 / 318 段 |
| 歇后语 | 41 条 |
| 预生成语音 | 2 × 2297 条 |

## ⚠️ 开发红线

1. **TTS 铁律**：只有真汉字能进语音通道，拼音字母绝不送进去（会被念成英文字母）
2. **不新增 pub 依赖**
3. **不恢复 INTERNET 权限**
4. `lib/data/voice_manifest*.dart` 自动生成，**勿手改**
5. **签名密钥不进仓库**
6. 改完语音数据**必须重新打包**才能验证（别测旧包）

详见 `docs/项目总结.md` §11。

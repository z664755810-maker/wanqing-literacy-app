# 晚晴识字 · GitHub 自动上传指南（给支持者看）

> 目的：让任何接手本项目的支持者，无需用户（鑫源）手动操作 GitHub Desktop，即可把代码与 APK 自动上传到 GitHub。

## 0. 前提（最重要，一次搞定，长期有效）

本机必须有一个可用的 GitHub 登录凭据，存在 **Windows 凭据管理器** 里：

- **最简单**：用户保持 **GitHub Desktop 登录状态**。GitHub Desktop 会把 token 存进 Windows 凭据管理器，git 命令行会自动借用，无需任何额外配置。
- **备选**：用户手动在 GitHub 建一个 **PAT（Personal Access Token）**，勾选 `repo` + `write:packages` 权限，首次 `git push` 时粘贴一次，GCM 会记住它。

验证凭据是否就绪：

```bash
cd /d/Progect-3/wanqing_shizi
git config --global --get credential.helper   # 应指向 git-credential-manager.exe
git ls-remote origin                            # 能列出 refs 即凭据有效；报 401 说明令牌失效
```

> ⚠️ 若 `git push` 突然要求输入账号密码：打开 GitHub Desktop 重新登录，或在「Windows 凭据管理器」删掉 `git:https://github.com` 那条后重 push。

## 1. 代码上传（自动认证，不要走网页）

```bash
cd /d/Progect-3/wanqing_shizi
git add .
git commit -m "feat: 简述本次改动"
git push
```

- 远端地址：`https://github.com/z664755810-maker/wanqing-literacy-app.git`（Public 仓库）。
- 认证由 GCM 现场注入，**地址里不要写明文 token**。
- `.gitignore` 已排除：签名密钥（`*.jks`/`key.properties`/`keystore`）、`build/`、`android/gradle/caches/`、`dist/`、`tool/_*.json` 等临时文件。仓库只含源码与资源，安全。

## 2. Release APK 上传（必须用脚本，别用网页）

GitHub 网页拖拽上传有 **25MB 限制**，v1.17 的 APK 约 673MB，网页传不了。用仓库内的脚本：

```bash
python tool/upload_release_asset.py
```

脚本做了什么（无需支持者改）：

1. `git credential fill` 取出本机 token（与 push 同一个）。
2. 调 GitHub API 把 `dist/晚晴识字-v1.17-arm64.apk` 传成 Release 资产。
3. **资产文件名务必用 ASCII**（如 `wanqing-shizi-v1.17-arm64.apk`）——GitHub Release 会剔除非 ASCII 字符（中文名会被吞掉，只剩 `-v1.17-arm64.apk`）；中文说明放 `label` 字段。
4. 上传前会先删掉同名坏资产，避免重复。

若要发**新版本**，改 `tool/upload_release_asset.py` 顶部的 `RELEASE_ID` / `APK` / `NAME` / `LABEL` 三处即可。

## 3. 日常收尾（上传后清理，释放 C 盘）

```bash
bash .workbuddy/cleanup.sh
```

清空项目内 `build/`、`android/gradle/caches/`，并把 C 盘全局 `C:\Users\Lenovo\.gradle` 移到 `D:\_Recycle_Hold\`（用户确认后再自删）。

## 4. 红线提醒（任何支持者都不得违反）

1. `pubspec.yaml` 禁止新增任何 pub 依赖。
2. `AndroidManifest.xml` 不得恢复 INTERNET 权限（纯离线）。
3. TTS 只送真汉字，拼音绝不送语音。
4. 仓库不得提交签名密钥与 APK 本体（APK 只走 Release 资产）。

## 5. 一句话总结

> 用户保持 GitHub Desktop 登录 = 本机有 token = `git push` 与 `tool/upload_release_asset.py` 都能自动认证上传。支持者只需跑上面三条命令，用户无需手动点任何上传按钮。

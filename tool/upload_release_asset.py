# -*- coding: utf-8 -*-
"""把 v1.17 APK 作为 Release 资产上传（修正 curl 中文文件名丢失问题）。

用法：python tool/upload_release_asset.py
"""
import json
import os
import subprocess
import sys

import requests

REPO = "z664755810-maker/wanqing-literacy-app"
RELEASE_ID = 383507992
APK = r"D:/Progect-3/wanqing_shizi/dist/晚晴识字-v1.17-arm64.apk"
# ⚠️ GitHub Release 资产名会被剔除非 ASCII 字符（实测「晚晴识字」4 字被丢弃，
#    只剩 "-v1.17-arm64.apk"），故文件名走 ASCII，中文说明放 label。
NAME = "wanqing-shizi-v1.17-arm64.apk"
LABEL = "晚晴识字 v1.17 安装包 (arm64，目标设备：荣耀 MagicPad2)"


def get_token() -> str:
    p = subprocess.run(
        ["git", "credential", "fill"],
        input="protocol=https\nhost=github.com\n\n",
        capture_output=True, text=True, encoding="utf-8",
    )
    for line in p.stdout.splitlines():
        if line.startswith("password="):
            return line[len("password="):].strip()
    sys.exit("取不到 GitHub token")


def main():
    tok = get_token()
    H = {"Authorization": f"token {tok}", "Accept": "application/vnd.github+json"}
    api = f"https://api.github.com/repos/{REPO}"

    # 1) 删掉上次因 curl 编码问题上传的坏名资产
    assets = requests.get(f"{api}/releases/{RELEASE_ID}/assets", headers=H, timeout=60).json()
    for a in assets:
        if a["name"] == NAME or a["name"].endswith("-v1.17-arm64.apk"):
            r = requests.delete(f"{api}/releases/assets/{a['id']}", headers=H, timeout=60)
            print(f"已删除坏名资产: {a['name']}  HTTP {r.status_code}")

    # 2) 重新上传（requests 负责 UTF-8 百分号编码，中文名不会丢）
    size = os.path.getsize(APK)
    print(f"开始上传 {NAME}  {size/1024/1024:.1f} MB ...")
    up = f"https://uploads.github.com/repos/{REPO}/releases/{RELEASE_ID}/assets"
    with open(APK, "rb") as f:
        r = requests.post(
            up,
            headers={**H, "Content-Type": "application/vnd.android.package-archive",
                     "Content-Length": str(size)},
            params={"name": NAME, "label": LABEL},
            data=f,
            timeout=3600,
        )
    print("HTTP", r.status_code)
    if r.status_code in (200, 201):
        d = r.json()
        print("上传成功")
        print("  名称:", d["name"])
        print("  大小: %.1f MB" % (d["size"] / 1024 / 1024))
        print("  状态:", d.get("state"))
        print("  下载:", d["browser_download_url"])
    else:
        print("失败:", r.text[:800])
        sys.exit(1)


if __name__ == "__main__":
    main()

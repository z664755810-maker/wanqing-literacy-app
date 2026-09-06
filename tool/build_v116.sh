#!/usr/bin/env bash
# v1.16+ 构建脚本（后台 + sandbox 禁用 + arm64-only）
# 用法：bash tool/build_v116.sh
# 注意：此脚本需 dangerouslyDisableSandbox:true 才能跑 Flutter 构建。

set -e

cd /d/Progect-3/wanqing_shizi

VERSION="1.16.0+20"
APK_NAME="晚晴识字-v1.16-arm64.apk"
DIST_DIR="D:/Progect-3/dist"
KEYSTORE="android/keystore/wanqing.jks"
KEY_PROPS="android/key.properties"

echo "=== 晚晴识字 v${VERSION} 构建 ==="

# 1. 自检
echo "--- [1/4] flutter analyze lib ---"
flutter analyze lib 2>&1 | tail -3

# 2. 清理 + 构建（arm64-only 单 APK）
echo "--- [2/4] flutter clean + build apk ---"
flutter clean 2>&1 | tail -2
flutter build apk \
  --release \
  --split-per-abi \
  --target-platform android-arm64 \
  2>&1 | tail -10

# 3. 验签
echo "--- [3/4] apksigner verify ---"
APK_PATH=$(find build/app/outputs/flutter-apk -name "app-arm64-v8a-release.apk" | head -1)
if [ -z "$APK_PATH" ]; then
  echo "ERROR: 未找到 APK" >&2
  exit 1
fi
echo "APK 路径: $APK_PATH"

mkdir -p "$DIST_DIR"
cp "$APK_PATH" "$DIST_DIR/$APK_NAME"
echo "已复制到: $DIST_DIR/$APK_NAME"

# v2 验签
if [ -f "$KEY_PROPS" ]; then
  source "$KEY_PROPS"
  apksigner verify \
    --verbose \
    --print-certs \
    --ks "$KEYSTORE" \
    --ks-key-alias "${keyAlias}" \
    --ks-pass "pass:${storePassword}" \
    --key-pass "pass:${keyPassword}" \
    "$DIST_DIR/$APK_NAME" 2>&1 | tail -10
else
  echo "WARN: 找不到 $KEY_PROPS，跳过验签"
fi

# 4. APK 信息
echo "--- [4/4] APK 信息 ---"
ls -lh "$DIST_DIR/$APK_NAME"
echo "音频总数（双 manifest）: $(grep -c \"  '\" lib/data/voice_manifest.dart) + $(grep -c \"  '\" lib/data/voice_manifest_norm.dart)"

echo "=== 构建完成 ==="
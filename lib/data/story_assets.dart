import 'package:flutter/services.dart' show AssetManifest, rootBundle;

/// 故事屋资源清单：预加载 APK 内真实存在的资源路径集合。
///
/// 故事数据（story.dart）里很多段落引用了插图路径，但部分插图并未打包进 APK。
/// 渲染时若直接按数据里写的路径去加载，缺失的图会退化成「空占位框」，看起来就像
/// 「有的段落该有图却没图」。这里用 [AssetManifest] 在启动时拿到真实资源集合，
/// 渲染前过滤掉不存在的路径——只给「真有图」的段落留图位，段落没有图就纯文字展示。
class StoryAssets {
  static Set<String>? _set;

  /// 是否已加载完成（AppState.init 会 await 它；未加载前 contains 保守返回 true）。
  static bool get ready => _set != null;

  /// 加载 APK 资源清单（幂等，可重复调用）。
  static Future<void> load() async {
    if (_set != null) return;
    try {
      final AssetManifest manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      _set = manifest.listAssets().toSet();
    } catch (e) {
      // 加载失败也不阻塞故事屋：置空集合，渲染时所有引用图都走 Image.asset 的 errorBuilder 兜底
      _set = const <String>{};
    }
  }

  /// 该资源路径是否真实打包进 APK。未加载完成时保守返回 true（交给 Image.asset 的 errorBuilder 兜底）。
  static bool contains(String path) => _set?.contains(path) ?? true;
}

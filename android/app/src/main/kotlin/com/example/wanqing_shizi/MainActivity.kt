package com.example.wanqing_shizi

import android.content.Context
import android.media.AudioAttributes
import android.media.AudioFocusRequest
import android.media.AudioManager
import android.media.MediaPlayer
import android.media.PlaybackParams
import android.os.Build
import android.os.Environment
import android.os.Handler
import android.os.Looper
import io.flutter.FlutterInjector
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.util.concurrent.ConcurrentHashMap

/**
 * 晚晴识字 · 原生侧。
 *
 * 本文件持两条零依赖通道：
 *  1. `wanqing/backup`：进度备份导出目录（沿用旧写法）。
 *  2. `wanqing/audio`：本地音频播放（assets + MediaPlayer）。全部调用**只在主线程**发生，
 *     这是 v1.15 重写的核心：旧实现用「同步 prepare() + 独立 Timer 线程轮询 currentPosition」，
 *     在荣耀等 ROM 上会 ANR（主线程被 prepare 阻塞 → 屏幕静止）或跨线程触碰 MediaPlayer 导致
 *     native 崩溃（Java try/catch 抓不住 → 点朗读回桌面）。本版本规则：
 *       - 播放前先把 asset 拷到 cache 文件（assets.open 对压缩/未压缩都稳），再 setDataSource(文件)，
 *         彻底绕开 AssetFileDescriptor 的 fd 生命周期与 mmap 坑。
 *       - 用 `prepareAsync()`，绝不用阻塞式 `prepare()`。
 *       - OnPrepared / OnError / OnCompletion 三个监听器收口所有结果，错误必回 Dart。
 *       - 进度改由主线程 Handler 每 200ms 轮询并推送 EventChannel，杜绝跨线程。
 *       - 设置 AudioAttributes + 请求音频焦点，避免部分 OEM 静音。
 *       - 倍速只允许 >=1.0（坑3：speed<1 在部分机型/编码会 native 崩溃；慢速已烤进音频本体，
 *         这里的倍速仅用于从"慢速母带"往上提）。speed<=1.0 一律不调 setPlaybackParams。
 */
class MainActivity : FlutterActivity() {
    private var player: MediaPlayer? = null
    private var audioChannel: MethodChannel? = null
    private var progressSink: EventChannel.EventSink? = null

    // —— 播放状态：全部只在主线程读写 ——
    private var prepared = false          // prepareAsync 已成功
    private var playing = false           // start() 之后（含暂停前）
    private var pausedByUser = false      // 用户点了暂停
    private var finished = true           // 已播完 / 已释放 / 已停止 → 不再触碰 player
    private var pendingResult: MethodChannel.Result? = null // play 的 result，prepared 或 error 时结算

    private val mainHandler = Handler(Looper.getMainLooper())
    private val assetCache = ConcurrentHashMap<String, File>()

    private val audioManager: AudioManager by lazy {
        getSystemService(Context.AUDIO_SERVICE) as AudioManager
    }
    private var focusRequest: AudioFocusRequest? = null

    // 主线程每 200ms 轮询一次进度（MediaPlayer 全部方法都在主线程调用，杜绝跨线程 native 崩溃）
    private val progressRunnable = object : Runnable {
        override fun run() {
            val p = player ?: return
            if (prepared && !finished) {
                try {
                    if (playing && !pausedByUser) {
                        val pos = p.currentPosition
                        val dur = p.duration
                        if (dur > 0) {
                            progressSink?.success(mapOf("position" to pos, "duration" to dur))
                        }
                    }
                    mainHandler.postDelayed(this, 200L)
                } catch (_: Exception) {
                    // 已释放等竞态：停止轮询
                }
            }
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // 既有备份通道（零依赖写文件，沿用旧写法）
        val backup = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "wanqing/backup")
        backup.setMethodCallHandler { call, result ->
            when (call.method) {
                "getExportDir" -> {
                    val dir = getExternalFilesDir(Environment.DIRECTORY_DOWNLOADS)
                        ?: getExternalFilesDir(null)
                        ?: filesDir
                    result.success(dir.absolutePath)
                }
                else -> result.notImplemented()
            }
        }

        // 音频播放通道（本地 assets + MediaPlayer，零依赖、零联网）
        val audio = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "wanqing/audio")
        audioChannel = audio
        audio.setMethodCallHandler { call, result ->
            when (call.method) {
                "play" -> {
                    val asset = call.argument<String>("asset") ?: "assets/audio/char_0.mp3"
                    val speed = (call.argument<Double>("speed") ?: 1.0).toFloat()
                    try {
                        // 得到 APK 内真实 key（如 flutter_assets/assets/audio/char_0.mp3）
                        val key = FlutterInjector.instance().flutterLoader().getLookupKeyForAsset(asset)
                        playAssetFile(key, speed, result)
                    } catch (e: Exception) {
                        finishPlayer()
                        result.error("PLAY_ERR", e.message ?: "play failed", null)
                    }
                }
                "pause" -> {
                    val p = player
                    if (p != null && prepared && playing && !finished) {
                        try {
                            p.pause()
                            pausedByUser = true
                        } catch (_: Exception) {}
                    }
                    result.success(null)
                }
                "resume" -> {
                    val p = player
                    if (p != null && prepared && pausedByUser && !finished) {
                        try {
                            p.start()
                            pausedByUser = false
                        } catch (_: Exception) {}
                    }
                    result.success(null)
                }
                "stop" -> {
                    stopInternal()
                    result.success(null)
                }
                // 自检用：确认通道活着
                "ping" -> result.success("pong")
                else -> result.notImplemented()
            }
        }

        // 进度事件通道（每 200ms 推 {position, duration}，单位毫秒）
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, "wanqing/audio/progress")
            .setStreamHandler(object : EventChannel.StreamHandler {
                override fun onListen(args: Any?, sink: EventChannel.EventSink) {
                    progressSink = sink
                }

                override fun onCancel(args: Any?) {
                    progressSink = null
                }
            })
    }

    /** 播放单个 asset（拷贝到 cache 后从文件播）。[result] 在 prepared 或 error 时结算一次。 */
    private fun playAssetFile(key: String, speed: Float, result: MethodChannel.Result) {
        stopInternal()
        pendingResult = result
        try {
            val cacheFile = cachedAssetFile(key) // 失败抛异常 → 走下方 catch，pendingResult 被清
            val p = MediaPlayer()
            player = p
            prepared = false
            playing = false
            pausedByUser = false
            finished = false
            p.setAudioAttributes(
                AudioAttributes.Builder()
                    .setUsage(AudioAttributes.USAGE_MEDIA)
                    .setContentType(AudioAttributes.CONTENT_TYPE_SPEECH)
                    .build()
            )
            p.setDataSource(cacheFile.absolutePath)

            p.setOnPreparedListener { mp ->
                if (mp !== player) return@setOnPreparedListener // 已被新一轮播放取代
                prepared = true
                // 倍速只升不降：>=1.0 才调 setPlaybackParams（坑3：<1.0 会 native 崩溃）
                if (speed >= 1.0f && Build.VERSION.SDK_INT >= 23) {
                    try {
                        mp.playbackParams = PlaybackParams().setSpeed(speed)
                    } catch (_: Exception) {
                        // 个别机型不支持变速：忽略，按原速播
                    }
                }
                try {
                    mp.setVolume(1.0f, 1.0f)
                } catch (_: Exception) {}
                requestAudioFocus()
                try {
                    mp.start()
                    playing = true
                } catch (_: Exception) {
                    playing = false
                }
                val dur = try {
                    mp.duration
                } catch (_: Exception) {
                    0
                }
                val res = pendingResult
                pendingResult = null
                res?.success(dur) // Dart 拿到时长，用于浮层与看门狗
                mainHandler.removeCallbacks(progressRunnable)
                mainHandler.post(progressRunnable)
            }

            p.setOnErrorListener { mp, what, extra ->
                val res = pendingResult
                pendingResult = null
                finishPlayer()
                res?.error("PLAY_ERR", "what=$what extra=$extra", null)
                true
            }

            p.setOnCompletionListener { mp ->
                if (mp !== player) return@setOnCompletionListener // 迟到的完成：已被替换
                finishPlayer()
                audioChannel?.invokeMethod("onComplete", null) // 通知 Dart 浮层自动消失
            }

            p.prepareAsync() // 异步准备，绝不阻塞主线程
        } catch (e: Exception) {
            val res = pendingResult
            pendingResult = null
            finishPlayer()
            res?.error("PLAY_ERR", e.message ?: "prepare failed", null)
        }
    }

    /** 把 asset 拷到 cache 文件（只拷一次，HashMap 缓存）。asset 必须存在，否则抛异常。 */
    private fun cachedAssetFile(key: String): File {
        assetCache[key]?.let { f ->
            if (f.exists() && f.length() > 0L) return f
        }
        val dir = File(cacheDir, "wanqing_audio").apply { mkdirs() }
        val name = key.substringAfterLast('/').ifEmpty { "clip.mp3" }
        val out = File(dir, name)
        val input = applicationContext.assets.open(key) // 对压缩/未压缩 asset 都稳定
        input.use { i ->
            out.outputStream().use { o -> i.copyTo(o) }
        }
        if (!out.exists() || out.length() == 0L) {
            throw RuntimeException("audio asset copy failed: $key")
        }
        assetCache[key] = out
        return out
    }

    /** 用户主动 stop / 新一轮 play 前的清理：结算悬挂的 play result + 释放。 */
    private fun stopInternal() {
        val res = pendingResult
        if (res != null) {
            pendingResult = null
            try {
                res.error("STOPPED", "superseded", null)
            } catch (_: Exception) {}
        }
        finishPlayer()
    }

    /** 释放 MediaPlayer、停轮询、放弃焦点、清状态。不结算 result、不发 onComplete。 */
    private fun finishPlayer() {
        mainHandler.removeCallbacks(progressRunnable)
        val p = player
        player = null
        prepared = false
        playing = false
        pausedByUser = false
        finished = true
        if (p != null) {
            try {
                p.setOnCompletionListener(null)
                p.setOnErrorListener(null)
                p.setOnPreparedListener(null)
                p.stop()
            } catch (_: Exception) {
                // 未 prepared 的 stop 会抛：忽略
            }
            try {
                p.release()
            } catch (_: Exception) {}
        }
        abandonAudioFocus()
    }

    private fun requestAudioFocus() {
        try {
            if (Build.VERSION.SDK_INT >= 26) {
                val fr = AudioFocusRequest.Builder(AudioManager.AUDIOFOCUS_GAIN)
                    .setAudioAttributes(
                        AudioAttributes.Builder()
                            .setUsage(AudioAttributes.USAGE_MEDIA)
                            .setContentType(AudioAttributes.CONTENT_TYPE_SPEECH)
                            .build()
                    )
                    .build()
                focusRequest = fr
                audioManager.requestAudioFocus(fr)
            } else {
                @Suppress("DEPRECATION")
                audioManager.requestAudioFocus(null, AudioManager.STREAM_MUSIC, AudioManager.AUDIOFOCUS_GAIN)
            }
        } catch (_: Exception) {
            // 拿不到焦点也照播（部分 OEM 总返回失败但声音正常）
        }
    }

    private fun abandonAudioFocus() {
        try {
            val fr = focusRequest
            if (Build.VERSION.SDK_INT >= 26 && fr != null) {
                audioManager.abandonAudioFocusRequest(fr)
            } else {
                @Suppress("DEPRECATION")
                audioManager.abandonAudioFocus(null)
            }
        } catch (_: Exception) {}
        focusRequest = null
    }

    // —— 生命周期：离开页面/应用时静音，避免"人走了还在念" ——
    override fun onPause() {
        super.onPause()
        val p = player
        if (p != null && prepared && playing && !finished) {
            try {
                p.pause()
            } catch (_: Exception) {}
        }
    }

    override fun onResume() {
        super.onResume()
        // 不自动续播（回到界面由用户再点一次更符合识字场景），保持暂停态即可
    }

    override fun onDestroy() {
        stopInternal()
        super.onDestroy()
    }
}

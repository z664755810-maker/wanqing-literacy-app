import 'package:flutter/material.dart';

import '../services/voice_player.dart';
import '../theme/app_dimens.dart';
import '../theme/app_theme.dart';

/// 全局语音浮层进度条。
///
/// 挂在 [MaterialApp] 的 builder 里、Navigator 之上（见 `main.dart`），因此覆盖所有界面。
/// 仅在 [VoicePlayer] 处于「播放中 / 暂停」时显示，否则返回 [SizedBox.shrink]。
///
/// - 音频态（有进度）：显示可拖动进度的进度条 + 暂停/继续 + 终止；
/// - 系统 TTS 回落态（无进度）：进度条显示不确定态 + 仅终止（系统 TTS 暂停不可靠，按需求用 stop 代替）。
///
/// ⚠️ 当前 MethodChannel 未实现 `seek`，进度条为**只读**（不拖）。
class VoicePlayerBar extends StatelessWidget {
  const VoicePlayerBar({super.key});

  @override
  Widget build(BuildContext context) {
    final AppDimens d = AppDimens.of(context);
    final double bottomPad = MediaQuery.of(context).padding.bottom;

    return ListenableBuilder(
      listenable: VoicePlayer.instance,
      builder: (BuildContext ctx, Widget? child) {
        final VoicePlayer vp = VoicePlayer.instance;
        if (!vp.isPlaying && !vp.isPaused) return const SizedBox.shrink();

        final String label = vp.currentLabel ?? '正在朗读';
        final bool canPause = vp.hasAudioProgress; // 回落态只给终止
        final bool paused = vp.isPaused;

        return Positioned(
          left: d.fs(AppDimens.gapM),
          right: d.fs(AppDimens.gapM),
          bottom: bottomPad + d.fs(AppDimens.gapS),
          child: Material(
            color: AppTheme.paper,
            elevation: 8,
            borderRadius: BorderRadius.circular(AppDimens.radius),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: d.fs(16),
                vertical: d.fs(12),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppDimens.radius),
                border: Border.all(color: AppTheme.line, width: 1),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          label,
                          style: AppTheme.serif(
                            size: d.fs(18),
                            w: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: d.fs(8)),
                        LinearProgressIndicator(
                          // 系统 TTS 回落态：无进度 → 不确定态动画
                          value: vp.usingFallback ? null : vp.progress,
                          minHeight: d.fs(8),
                          borderRadius: BorderRadius.circular(d.fs(4)),
                          color: AppTheme.dai,
                          backgroundColor: AppTheme.daiSoft,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: d.fs(AppDimens.gapS)),
                  // 暂停 / 继续（仅音频态可用）
                  if (canPause)
                    IconButton(
                      icon: Icon(
                        paused ? Icons.play_arrow_outlined : Icons.pause_outlined,
                        size: d.fs(30),
                        color: AppTheme.dai,
                      ),
                      tooltip: paused ? '继续' : '暂停',
                      onPressed: () {
                        if (paused) {
                          VoicePlayer.instance.resume();
                        } else {
                          VoicePlayer.instance.pause();
                        }
                      },
                    ),
                  // 终止（两种路径都给）
                  IconButton(
                    icon: Icon(
                      Icons.stop_circle_outlined,
                      size: d.fs(32),
                      color: AppTheme.seal,
                    ),
                    tooltip: '终止',
                    // v1.16 调 VoicePlayer.stop()（单一权威入口）+ 乐观 UI 更新：让浮层立刻消失，
                    // 不必等原生通道异步返回后再 notifyListeners（母亲体感更流畅）。
                    onPressed: () {
                      VoicePlayer.instance.stop();
                      VoicePlayer.instance.hideImmediately();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

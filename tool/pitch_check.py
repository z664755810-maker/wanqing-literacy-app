"""用 praat-parselmouth 提取 mp3 的基频(F0)曲线，客观判定每个样本是几声。
一声=平、二声=升、四声=降。用于平息"听着像四声"的主观争议。"""
import parselmouth
import sys
import numpy as np


def analyze(path):
    snd = parselmouth.Sound(path)
    pitch = snd.to_pitch(time_step=0.01, pitch_floor=75, pitch_ceiling=500)
    ts = pitch.ts()
    f0 = pitch.selected_array['frequency']
    voiced = f0[f0 > 0]
    if len(voiced) < 3:
        return f"{path}: 无基频帧，无法判定"
    voiced_times = ts[f0 > 0]
    t0, t1 = voiced_times[0], voiced_times[-1]

    def at(frac):
        tt = t0 + (t1 - t0) * frac
        idx = int(np.argmin(np.abs(ts - tt)))
        return f0[idx] if f0[idx] > 0 else float('nan')

    v20, v50, v80 = at(0.2), at(0.5), at(0.8)
    mean = float(np.mean(voiced))
    slope = float(np.polyfit(voiced_times, voiced, 1)[0])  # Hz / 秒
    if abs(slope) < 8:
        tone = "一声(平调)"
    elif slope > 8:
        tone = "二声(升调)"
    else:
        tone = "四声(降调)"
    return (f"{path}\n  均值={mean:.1f}Hz  @20%={v20:.1f}  @50%={v50:.1f}  @80%={v80:.1f}  "
            f"斜率={slope:+.1f}Hz/s  => {tone}")


if __name__ == "__main__":
    for p in sys.argv[1:]:
        print(analyze(p))
        print()

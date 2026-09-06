"""v1.17 验证脚本：测试 edge-tts 合成拼音字母 vs 汉字字面声调的效果差异。

生成 5 个对照样本：
- tē / dē / nē：拼音字母 + 二声标记（v1.17 候选方案）
- 特 / 得：汉字字面声调（v1.16 现状）

让用户试听后决定 v1.17 方案。
"""
import asyncio
import edge_tts
import sys

VOICE = "zh-CN-XiaoxiaoNeural"
RATE = "-30%"  # 与项目现有慢速档一致


async def gen(text: str, file: str):
    communicate = edge_tts.Communicate(text, VOICE, rate=RATE)
    await communicate.save(file)
    print(f"  ✓ {text!r:8s} -> {file}")


async def main():
    samples = [
        # 拼音字母方案（v1.17 候选）
        ("tē",  "D:/Progect-3/wanqing_shizi/tool/pinyin_te_2sheng.mp3"),
        ("dē",  "D:/Progect-3/wanqing_shizi/tool/pinyin_de_2sheng.mp3"),
        ("nē",  "D:/Progect-3/wanqing_shizi/tool/pinyin_ne_2sheng.mp3"),
        # 汉字字面方案（v1.16 现状，对照组）
        ("特",  "D:/Progect-3/wanqing_shizi/tool/hanzi_te_4sheng.mp3"),
        ("得",  "D:/Progect-3/wanqing_shizi/tool/hanzi_de_pingsheng.mp3"),
    ]
    print(f"edge-tts 合成测试：voice={VOICE}, rate={RATE}")
    print(f"输出目录: D:\\Progect-3\\wanqing_shizi\\tool\\")
    print()
    for text, file in samples:
        await gen(text, file)
    print()
    print("✅ 5 个样本已生成。请试听后告诉我：")
    print("   1. tē / dē / nē（拼音字母二声）听起来是自然的拼音二声，还是拆成字母 t-ē？")
    print("   2. 与 特 / 得（汉字字面声调）对比，哪个更符合母亲学习的预期？")


if __name__ == "__main__":
    asyncio.run(main())
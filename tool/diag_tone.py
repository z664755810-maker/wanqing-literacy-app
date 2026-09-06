"""v1.17 诊断脚本：摸清 edge-tts 对各类拼音输入的真实发音行为。

背景：用户实测发现，tts_text 用拼音字母时——
  - 'tē' / 'dē'（声母+单韵母）发音正确
  - 'āi' / 'ēr'（复韵母/卷舌韵母）被念成了四声

所以不能再用"拼音字母"一条路走到底。本脚本对同一目标音生成多种输入方式的对照样本，
让用户试听后确定每种情况该用哪种输入方式。

每组样本说明：
  letter_tone  = 拼音字母 + 声调符号（当前做法）
  letter_plain = 拼音字母，无声调
  hanzi_N      = N 声汉字（作为标准参照）
"""
import asyncio
import edge_tts

VOICE = "zh-CN-XiaoxiaoNeural"
RATE = "-30%"
OUT = r"D:/Progect-3/wanqing_shizi/tool"


async def gen(text, name, note):
    path = f"{OUT}/{name}.mp3"
    comm = edge_tts.Communicate(text, VOICE, rate=RATE, pitch="+0Hz")
    await comm.save(path)
    print(f"  {name:28s}  输入={text!r:8s}  {note}")


async def main():
    print(f"诊断样本 voice={VOICE} rate={RATE}")
    print(f"输出目录: {OUT}\n")

    print("=== ai 组（目标：一声 āi；用户反馈当前念成四声）===")
    await gen("āi", "diag_ai_letter_tone", "拼音字母+一声符【当前做法】")
    await gen("ai", "diag_ai_letter_plain", "拼音字母无声调")
    await gen("哀", "diag_ai_hanzi_1", "汉字「哀」一声【标准参照】")
    await gen("爱", "diag_ai_hanzi_4", "汉字「爱」四声【App 现状，错的】")

    print("\n=== er 组（目标：一声 ēr；用户反馈当前念成四声）===")
    await gen("ēr", "diag_er_letter_tone", "拼音字母+一声符【当前做法】")
    await gen("er", "diag_er_letter_plain", "拼音字母无声调")
    await gen("儿", "diag_er_hanzi_2", "汉字「儿」二声")

    print("\n=== te 组（对照组：用户已确认 tē 合格）===")
    await gen("tē", "diag_te_letter_tone", "拼音字母+一声符【已验证合格】")
    await gen("特", "diag_te_hanzi_4", "汉字「特」四声【App 旧读音】")

    print("\n=== ri 组（判断整体认读该不该改）===")
    await gen("rī", "diag_ri_letter_tone", "拼音字母+一声符")
    await gen("日", "diag_ri_hanzi_4", "汉字「日」四声【教材标准读音】")

    print("\n=== e / ao / ang 组（同样需确认）===")
    await gen("婀", "diag_e_hanzi_1", "汉字「婀」一声 ē")
    await gen("鹅", "diag_e_hanzi_2", "汉字「鹅」二声 é【App 现状】")
    await gen("熬", "diag_ao_hanzi_1", "汉字「熬」一声 āo")
    await gen("奥", "diag_ao_hanzi_4", "汉字「奥」四声【App 现状】")
    await gen("肮", "diag_ang_hanzi_1", "汉字「肮」一声 āng")
    await gen("昂", "diag_ang_hanzi_2", "汉字「昂」二声 áng【App 现状】")

    print("\n✅ 16 个诊断样本已生成，请逐组试听。")


if __name__ == "__main__":
    asyncio.run(main())

#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""给 char_library.dart 的 60 个 CharCard 插入 picFile 字段（幂等）。

命名规则：拼音去声调（ascii），避免非 ASCII 资源路径风险。
同音冲突：一/衣 -> yi.png / yi2.png；水/睡 -> shui.png / shui2.png。
目标资源：assets/images/chars/<name>.png （pubspec 已声明该目录，自动打包）。
"""
import io, os, re, sys

SRC = r"D:\Progect-3\wanqing_shizi\lib\data\char_library.dart"

# char -> pic 文件名（不含目录，含 .png）
PIC = {
    '我':'wo','你':'ni','好':'hao','人':'ren','口':'kou','手':'shou',
    '大':'da','小':'xiao','多':'duo','一':'yi','二':'er','三':'san',
    '上':'shang','下':'xia','中':'zhong','天':'tian','日':'ri','月':'yue',
    '家':'jia','门':'men','开':'kai','关':'guan','出':'chu','入':'ru',
    '来':'lai','去':'qu','回':'hui','吃':'chi','饭':'fan','水':'shui',
    '喝':'he','米':'mi','面':'mian','菜':'cai','肉':'rou','汤':'tang',
    '碗':'wan','筷':'kuai','锅':'guo','衣':'yi2','鞋':'xie','帽':'mao',
    '洗':'xi','脸':'lian','牙':'ya','睡':'shui2','起':'qi','床':'chuang',
    '走':'zou','路':'lu','车':'che','买':'mai','钱':'qian','给':'gei',
    '看':'kan','听':'ting','说':'shuo','是':'shi','不':'bu','有':'you',
}

assert len(PIC) == 60, f"应有 60 字，实际 {len(PIC)}"

with io.open(SRC, 'r', encoding='utf-8') as f:
    lines = f.readlines()

out = []
cur_char = None          # 当前 CharCard 的汉字 key
block_has_pic = False    # 当前 block 是否已含 picFile
inserted = 0
skipped = 0

# 匹配  'X': CharCard(   行，捕获汉字
re_block = re.compile(r"^\s*'([^']+)':\s*CharCard\(")
# 匹配 sentence: '...', 行（4 空格缩进）
re_sentence = re.compile(r"^(\s*)sentence:\s*'.*',\s*$")
re_pic = re.compile(r"^\s*picFile:")

for line in lines:
    m = re_block.match(line)
    if m:
        cur_char = m.group(1)
        block_has_pic = False
        out.append(line)
        continue

    if re_pic.match(line):
        block_has_pic = True
        out.append(line)
        continue

    ms = re_sentence.match(line)
    if ms and cur_char is not None and not block_has_pic and cur_char in PIC:
        # 先写 sentence 行
        out.append(line)
        # 在其后插入 picFile
        indent = ms.group(1)
        pic = PIC[cur_char]
        out.append(f"{indent}picFile: '{pic}.png',\n")
        block_has_pic = True
        inserted += 1
        continue

    out.append(line)

with io.open(SRC, 'w', encoding='utf-8') as f:
    f.writelines(out)

print(f"inserted={inserted} skipped/existing={skipped} total_chars={len(PIC)}")

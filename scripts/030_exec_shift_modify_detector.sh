#!/bin/bash

img1="reports/2022_動物実験計画書_フロンティア医科学/2022_動物実験計画書_フロンティア医科学_01.jpeg"
img2="reports/2022_動物実験計画書_フロンティア医科学-Uso/2022_動物実験計画書_フロンティア医科学-Uso_01.jpeg"
output="diff-01.jpeg"

cp -f "$img1" shift_modify_detector/src/input/template.jpeg
cp -f "$img2" shift_modify_detector/src/input/target.jpeg

(
    cd shift_modify_detector/src/ || exit 1
    python shift_modification.py --conf_path conf/shift.yml
    python detect_diff.py --conf_path conf/detect.yml
    cp detect_result/target.jpeg ../../reports/"$output"
)

# cd shift_modify_detector
# cd src
# python shift_modification.py

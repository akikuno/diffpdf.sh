#!/bin/bash

output_pdf="$1"

[ -z "$output_pdf" ] && echo "ERROR: 出力するPDF名を入力してください" && exit 1

# もし拡張子にPDFがついていなかったら.pdfをつける
(echo "$output_pdf" | grep -q ".pdf") || output_pdf="$output_pdf".pdf

mkdir -p reports/log

# ログファイルの生成
_date=$(date "+%Y%m%d-%H%M%S")
log=reports/log/"$_date".txt
: >"$log"

# エラー処理
num_docs=$(find data/ -type f | grep ".pdf$" | wc -l)
[ "$num_docs" -eq 0 ] && echo "ERROR: dataフォルダにPDFファイルが見つかりませんでした" | tee -a "$log" && exit 1
[ $(("$num_docs" % 2)) = 1 ] && echo "ERROR: PDFファイルが奇数枚あります。ペアではないかもしれません" | tee -a "$log" && exit 1

echo "opencv tqdm pyyaml numpy pandas img2pdf pdf2image poppler pillow" | tr " " "\n" | sort >data/tmp_required_pkgs
conda list | awk '{print $1}' | sort >data/tmp_installed_pkgs
join -v 1 data/tmp_required_pkgs data/tmp_installed_pkgs >data/tmp_uninstalled_pkgs

if [ -s data/tmp_uninstalled_pkgs ]; then
    echo "ERROR: 以下のツールをインストールしてください" | tee -a "$log"
    cat data/tmp_uninstalled_pkgs | tee -a "$log"
    rm data/tmp_* 2>/dev/null
    exit 1
fi
rm data/tmp_* 2>/dev/null

#############################
# メインの処理開始
#############################

echo "ファイルをペアに並べます" >>"$log"

find data/ -type f |
    grep ".pdf$" |
    sort |
    grep -v original |
    paste - - |
    awk '{printf "%012d\t",NR}1' |
    tee -a "$log" |
    while read -r num_docs pdf1 pdf2; do
        # ペアごとにひとつずつ処理
        output="$(basename ${pdf1%.pdf})"
        echo "$output" を処理中です... | tee -a "$log"
        mkdir -p data/tmp_image data/tmp_output
        # PDFを1枚ずつJPEGに変換
        python scripts/convert_pdf_to_image.py "$pdf1" "template"
        python scripts/convert_pdf_to_image.py "$pdf2" "target"
        # JPEG1枚ずつをペアで比較
        find data/tmp_image/ -type f |
            sort |
            paste - - |
            awk '{printf "%012d\t",NR}1' |
            tee -a "$log" |
            while read -r num_pages target template; do
                # もしtargetとtemplateのなかに違う画像が入っていたら無視する
                if ! echo "$target" | grep -q "target"; then
                    continue
                fi
                if ! echo "$template" | grep -q "template"; then
                    continue
                fi
                cp -f "$template" shift_modify_detector/src/input/template.jpeg
                cp -f "$target" shift_modify_detector/src/input/target.jpeg

                (
                    cd shift_modify_detector/src/ || exit 1
                    python shift_modification.py --conf_path conf/shift.yml 2>&1 | tee -a "$log"
                    python detect_diff.py --conf_path conf/detect.yml 2>&1 | tee -a "$log"
                    cp detect_result/target.jpeg ../../data/tmp_output/"$num_docs"_"$num_pages".jpeg
                )
            done
        rm -rf data/tmp_image
    done

python scripts/jpeg_to_pdf.py "reports/$output_pdf"

rm -rf data/tmp_output

echo "=================================="
echo "終わりました！"
echo "reports/${output_pdf}をご確認ください"
echo "=================================="

exit 0

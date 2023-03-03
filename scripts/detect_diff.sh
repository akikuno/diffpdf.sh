#!/bin/bash

mkdir -p reports

find data/ -type f |
    grep ".pdf$" |
    sort |
    grep -v original |
    paste - - |
    awk '{printf "%05d\t",NR}1' |
    while read -r num_docs pdf1 pdf2; do
        output="$(basename ${pdf1%.pdf})"
        echo "$output" is now processing...
        mkdir -p data/tmp_image data/tmp_output
        python scripts/convert_pdf_to_image.py "$pdf1" "template"
        python scripts/convert_pdf_to_image.py "$pdf2" "target"
        # detect diff
        find data/tmp_image/ -type f |
            sort |
            paste - - |
            awk '{printf "%03d\t",NR}1' |
            while read -r num_pages target template; do
                cp -f "$template" shift_modify_detector/src/input/template.jpeg
                cp -f "$target" shift_modify_detector/src/input/target.jpeg

                (
                    cd shift_modify_detector/src/ || exit 1
                    python shift_modification.py --conf_path conf/shift.yml
                    python detect_diff.py --conf_path conf/detect.yml
                    cp detect_result/target.jpeg ../../data/tmp_output/"$num_docs"_"$num_pages".jpeg
                )
            done
        rm -rf data/tmp_image
    done

python scripts/jpeg_to_pdf.py test.pdf

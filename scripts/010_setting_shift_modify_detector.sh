#!/bin/bash
mamba install conda mamba --yes
mamba create -n opencv --yes
mamba install -n opencv -c conda-forge opencv tqdm pyyaml numpy pandas img2pdf pdf2image poppler pillow --yes
conda activate opencv

git clone https://github.com/sUeharaE4/shift_modify_detector.git

# cd shift_modify_detector
# cd src
# python shift_modification.py

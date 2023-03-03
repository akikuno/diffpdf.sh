#!/bin/bash
sudo apt update --yes
sudo apt upgrade --yes
sudo apt install make cmake libopencv-dev python3-opencv --yes

mamba install conda mamba --yes
mamba create -n ximg --yes python=2.7
mamba install -n ximg -c conda-forge opencv=2 cmake --yes
conda activate ximg
which cmake

find /home/kuno/miniconda3/envs/ximg/ |
    grep opencv.hpp

# https://github.com/Quramy/x-img-diff
rm -rf x-img-diff
git clone https://github.com/Quramy/x-img-diff.git
mkdir -p x-img-diff/build
(
    cd x-img-diff/build || .
    cmake ..
    make
)

#
git clone https://github.com/sUeharaE4/shift_modify_detector.git

mamba install conda mamba --yes
mamba create -n opencv --yes
mamba install -n opencv -c conda-forge opencv tqdm pyyaml numpy pandas pdf2image poppler pillow --yes
conda activate opencv

cd shift_modify_detector
cd src
python shift_modification.py

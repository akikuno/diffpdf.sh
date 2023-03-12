
# `diffpdf.sh`: PDF画像の差分比較ツール

- PDF画像の差分を比較します
- `data`ディレクトリにあるすべてのPDFに対して、ファイル名の順番に2枚ずつ差分を比較します
- `reports`ディレクトリに差分を比較した結果を1枚のPDFファイルにして出力します

## 事前に必要なもの

- Unix (検証環境: Ubuntu 20.04.5 LTS on WSL2)
- `bash`
- `conda` (https://docs.conda.io/en/latest/miniconda.html)

## セットアップ

```bash
type mamba >/dev/null 2>&1 || conda install -y mamba
mamba update -y conda mamba
mamba create -y -n diffpdf
mamba install -y -n diffpdf -c conda-forge git opencv tqdm pyyaml numpy pandas img2pdf pdf2image poppler pillow

rm -rf shift_modify_detector
git clone https://github.com/sUeharaE4/shift_modify_detector.git
```


## 使い方

- `data`ディレクトリにPDFファイルを入れてください
- ファイル名が辞書順に近い2つがペアとなります
  - 例えば01.pdf, 02.pdf, 03.pdf, 04.pdfの4枚があると、{01, 02}と{03,04}が比較するペアになります

- 続いて以下のコマンドと叩くと、`reports`フォルダが作られて結果が出力されます

```bash
bash diffpdf.sh <出力ファイル名(PDF)>
```

- 以下の例ですと`reports/protocols.pdf`が結果として出力されます

```bash
bash diffpdf.sh protocols.pdf
```

## 謝辞:pray:

- sUeharaE4さんの[`shift_modify_detector`](https://github.com/sUeharaE4/shift_modify_detector)を利用させていただきました。素晴らしいツールをありがとうございました。


# `detect_diff.sh`: 動物実験計画書の差分比較ツール

- PDF画像の差分を比較します
- `data`ディレクトリにあるすべてのPDFに対して、2枚ずつ差分を比較します
- `reports`に1枚のPDFファイルとして、差分を比較した結果を出力します。

## セットアップ

```bash
type mamba >/dev/null 2>&1 || conda install mamba --yes
mamba update conda mamba --yes
mamba create --yes
mamba install -c conda-forge git opencv tqdm pyyaml numpy pandas img2pdf pdf2image poppler pillow --yes

git clone https://github.com/sUeharaE4/shift_modify_detector.git
```


## 使い方

- `data`ディレクトリにPDFファイルを入れてください
- ファイル名が辞書順に近い2つがペアとなります
  - 例：01.pdf, 02.pdf, 03.pdf, 04.pdfの4枚があると、{01, 02}と{03,04}が比較するペアになります

- あとは以下のコマンドと叩くと、`reports`フォルダが作られて結果が出力されます

```bash
bash detect_diff.sh <出力ファイル名(PDF)>
```

- 以下の例ですと`reports/protocols.pdf`が結果です

```bash
bash detect_diff.sh protocols.pdf
```

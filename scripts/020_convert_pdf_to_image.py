from pathlib import Path
from pdf2image import convert_from_path

# PDFファイルのパス
pdf_path = Path("data", "pairs", "pair1", "2022_動物実験計画書_フロンティア医科学-Uso.pdf")

# PDF -> Image に変換（150dpi）
pages = convert_from_path(str(pdf_path), 600)

# 画像ファイルを１ページずつ保存
image_dir = Path("reports", "2022_動物実験計画書_フロンティア医科学-Uso")
image_dir.mkdir(parents=True, exist_ok=True)

for i, page in enumerate(pages):
    file_name = pdf_path.stem + "_{:02d}".format(i + 1) + ".jpeg"
    image_path = image_dir / file_name
    # JPEGで保存
    page.save(str(image_path), "JPEG")

import sys
from pathlib import Path
from pdf2image import convert_from_path

pdf_path = sys.argv[1]
output_file_name = sys.argv[2]
pages = convert_from_path(str(pdf_path), 600)

image_dir = Path("data/tmp_image")
image_dir.mkdir(parents=True, exist_ok=True)

for i, page in enumerate(pages):
    image_path = Path(image_dir, f"{i+1:03}_{output_file_name}.jpeg")
    page.save(str(image_path), "JPEG")

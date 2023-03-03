import os
import sys
import img2pdf
from PIL import Image

pdf_name = sys.argv[1]
jpeg_dir = "data/tmp_output/"
extension  = ".jpeg"

with open(pdf_name,"wb") as f:
    f.write(img2pdf.convert([Image.open(jpeg_dir+j).filename for j in os.listdir(jpeg_dir) if j.endswith(extension)]))

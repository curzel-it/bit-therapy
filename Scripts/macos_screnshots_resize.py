import os
import pdb
import sys
from PIL import Image

if len(sys.argv) < 2:
    print("Usage: python3 macos_screnshots_resize.py input_directory")
    sys.exit(1)

input_dir = sys.argv[1]
output_dir = "generated/screenshots"

if not os.path.exists(output_dir): os.mkdir(output_dir)

for lang in os.listdir(input_dir):
    if '.' in lang: continue
    path = f'{input_dir}/{lang}/macOS'

    for filename in os.listdir(path):
        if not filename.lower().endswith(".png"): continue
        input_path = f'{path}/{filename}'
        
        image = Image.open(input_path)
        resized_image = image.resize((2880, 1870))
        cropped_image = resized_image.crop((0, 70, 2880, 1870))

        output_sub_path = f'{output_dir}/{lang}'
        if not os.path.exists(output_sub_path): os.mkdir(output_sub_path)
        output_path = f'{output_sub_path}/{filename}'
        
        cropped_image.save(output_path)
        print(f"Processed {input_path} -> {output_path}")
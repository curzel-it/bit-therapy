import os
from sprites_checker import check_sprites_for_all_species

aseprite_path = "/Applications/Aseprite.app/Contents/MacOS/aseprite"
aseprite_assets = "../Aseprite"
pngs_folder = "../PetsAssets"

def export_aseprite(file_path, destination_folder):
    asset_name = file_path.split('/')[-1].split('.')[0]
    asset_name = asset_name[:-1] if asset_name.endswith('-') else asset_name
    os.system(f'{aseprite_path} -b {file_path} --save-as {destination_folder}/{asset_name}-0.png')

def find_aseprite_files(folder):
    paths = []
    for root, dirs, files in os.walk(folder):
        for file in files:
            if file.endswith('.aseprite') or file.endswith('.ase'):
                paths.append(os.path.join(root, file))
    return paths

def export_all_aseprite(root_folder, destination_folder):
    print(f'Looking for *.aseprite and *.ase file in {root_folder}...')
    files = find_aseprite_files(root_folder)
    print(f'Found {len(files)} files')
    for i, file in enumerate(files): 
        if i % 10 == 0: 
            print(f'Exported {i} files out of {len(files)}')
        export_aseprite(file, destination_folder)

export_all_aseprite(aseprite_assets, pngs_folder)
check_sprites_for_all_species()
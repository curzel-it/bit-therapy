import sys
import pdb
import json
import os

SPECIES_FOLDER_PATH = '../Species'
ASEPRITE_BIN = "/Applications/Aseprite.app/Contents/MacOS/aseprite"
ASEPRITE_FOLDER_PATH = "../Aseprite"
PNGS_FOLDER = "../PetsAssets"
IGNORE_LAYERS = '--ignore-layer "Talking" --ignore-layer "talking"'

def species_json(path):
    with open(path, 'r') as f:
        species = json.load(f)
    return species

def species_from_file():
    print(f'Looking Species...')
    paths = []
    for root, _, files in os.walk(SPECIES_FOLDER_PATH):
        for file in files:
            if file.endswith('.json'):
                paths.append(os.path.join(root, file))
    return [species_json(path) for path in paths]

def animation_ids(json):
    animations = list(map(lambda a: a['id'], json['animations']))
    animations += ['idle', 'drag', 'front', 'walk', 'fly']
    animations = sorted(list(set(animations)))
    return animations

def export_list():
    species = species_from_file()
    species_and_animations = [(species['id'], animation_ids(species)) for species in species]
    species_and_animation = [(species, animation) for species, animations in species_and_animations for animation in animations]
    filenames = [f'{species}_{animation}.aseprite' for species, animation in species_and_animation]
    return sorted(filenames)

def find_aseprite_files(folder):
    paths = []
    for root, dirs, files in os.walk(folder):
        for file in files:
            if file.endswith('.aseprite'):
                paths.append(os.path.join(root, file))
    return paths

def export_aseprite(file_path, destination_folder):
    asset_name = file_path.split('/')[-1].split('.')[0]
    asset_name = asset_name[:-1] if asset_name.endswith('-') else asset_name
    os.system(f'{ASEPRITE_BIN} -b {file_path} {IGNORE_LAYERS} --save-as {destination_folder}/{asset_name}-0.png')

def exportable_file_paths():
    print(f'Building export list...')
    paths = find_aseprite_files(ASEPRITE_FOLDER_PATH)
    valid_file_names = export_list()
    return [path for path in paths if any(path.endswith(filename) for filename in valid_file_names)]

def export_all_valid_files(name):
    paths = exportable_file_paths()
    for path in paths:
        if not name in path: continue
        print(f'Exporting {path}')
        export_aseprite(path, PNGS_FOLDER)

if __name__ == '__main__':
    name = sys.argv[-1] if len(sys.argv) == 2 else ""
    export_all_valid_files(name)
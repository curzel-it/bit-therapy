import json
import os

def _load_species_from_file(path):
    with open(path, 'r') as f:
        species = json.load(f)
    return species

def _load_species():
    paths = []
    for root, _, files in os.walk('../Species'):
        for file in files:
            if file.endswith('.json'):
                paths.append(os.path.join(root, file))
    return [_load_species_from_file(path) for path in paths]

def _load_all_sprites():
    paths = []
    for root, _, files in os.walk('../PetsAssets'):
        for file in files:
            if file.endswith('.png'):
                paths.append(os.path.join(root, file))
    return paths

def _load_sprites_by_species_and_animation():
    sprites = _load_all_sprites()
    grouped_sprites = {}

    def species_animation(path):
        name = path.split('/')[-1].split('.')[0].split('-')[0]
        animation = name.split('_')[-1]
        species = '_'.join(name.split('_')[:-1])
        return path, species, animation

    for path, species, animation in [species_animation(path) for path in sprites]:
        if not grouped_sprites.get(species): grouped_sprites[species] = {}
        if not grouped_sprites[species].get(animation): grouped_sprites[species][animation] = []
        grouped_sprites[species][animation].append(path)

    return grouped_sprites

def _animations_from_species(json):
    return map(lambda a: a['id'], json['animations'])

def _check_assets_for_species(species, all_animations):
    for animation in _animations_from_species(species):
        id = species['id']
        if not all_animations.get(id): 
            print(f'Missing species {id}!')
            return

        if not all_animations[id].get(animation): 
            print(f'Missing all assets for {id}@{animation}!')
            return

        assets = all_animations[id][animation]
        indeces = [asset.split('-')[-1].split('.')[0] for asset in assets]
        indeces = [int(index) for index in indeces]
        indeces = sorted(indeces)

        expected_indeces = sorted(list(range(len(indeces))))
        if indeces != expected_indeces:
            print(f'Missing assets for {id}@{animation}:')
            print(f'{indeces} vs {expected_indeces}')
            missing = set(indeces) - set(range(len(indeces)))
            missing = sorted(list(missing))
            for index in missing:
                print(f'  {id}_{animation}-{index}.png')

def check_sprites_for_all_species():
    print('Checking assets...')
    all_animations = _load_sprites_by_species_and_animation()
    species = _load_species()
    for species in species: 
        _check_assets_for_species(species, all_animations)
    print("If you don't see any errors, you are good to go!")

if __name__ == '__main__':
    check_sprites_for_all_species()
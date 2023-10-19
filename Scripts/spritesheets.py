import os
from PIL import Image

def spritesheet_from_pngs(paths):
    images = [Image.open(path) for path in paths]

    image_width, image_height = images[0].size
    grid_width = image_width * len(images)
    grid_height = image_height
    final_image = Image.new("RGBA", (grid_width, grid_height))

    for i in range(grid_width):
        for j in range(grid_height):
            index = i + j * grid_width
            if index < len(images):
                x_offset = i * image_width
                y_offset = j * image_height
                final_image.paste(images[index], (x_offset, y_offset))
    return final_image

def all_images_paths(assets_root):
    get_species = lambda path: '_'.join(path.split('_')[:-1])
    get_animation = lambda path: path.split('_')[-1].split('.')[0].split('-')[0]
    get_index = lambda path: int(path.split('-')[-1].split('.')[0])

    paths = os.listdir(assets_root)
    paths = [os.path.join(assets_root, path) for path in paths]
    paths = [path for path in paths if path.endswith('.png')]
    paths = sorted(paths, key=get_index)

    assets = {}    
    for path in paths:
        filename = os.path.split(path)[-1]
        species = get_species(filename)
        animation = get_animation(filename)
        if not assets.get(species): assets[species] = {}
        if not assets[species].get(animation): assets[species][animation] = []
        assets[species][animation].append(path)

    return assets

def generate_all_spritesheets(assets_root):
    print('Loading assets')
    assets = all_images_paths(assets_root)
    print(f'Found {len(assets)} assets')

    for (i, species) in enumerate(assets.keys()):
        print(f'  Generating spritesheets for {species} ({i}/{len(assets)})')
        for animation in assets[species].keys():
            filename = f'{species}_{animation}_spritesheet.png'
            folder = f'generated/spritesheets/{species}'
            image = spritesheet_from_pngs(assets[species][animation]) 
            if not os.path.exists(folder): os.makedirs(folder)
            image.save(f'{folder}/{filename}')

def generate_pngs_from_spritesheet(path):
    filename = os.path.split(path)[-1]
    species = '_'.join(filename.split('_')[:-2])
    animation = filename.split('_')[-2]
    out_folder = 'generated/from_spritesheets'
    if not os.path.exists(out_folder): 
        os.makedirs(out_folder)

    image = Image.open(path)
    width, height = sprites_size_from_spritesheet(image.size)
    number_of_assets = int(image.size[0] / width)

    cropped_at_column = lambda i: image.crop((i*width, 0, (i+1)*width, height))

    assets = [cropped_at_column(i) for i in range(number_of_assets)]
    for i, asset in enumerate(assets):
        asset.save(f'{out_folder}/{species}_{animation}-{i}.png')

    return assets

def generate_all_spritesheets(root):
    paths = os.listdir(root)
    paths = [os.path.join(root, path) for path in paths]
    paths = [path for path in paths if path.endswith('spritesheet.png')]
    for path in paths:
        generate_pngs_from_spritesheet(path)


def sprites_size_from_spritesheet(image_size):
    sheet_width, sheet_height = image_size
    for sprite_size in [50, 60, 75, 100]:
        if sheet_width % sprite_size == 0: 
            return sprite_size, sheet_height
    raise Exception("Unknown spritesheet size!")


os.system('rm -rf generated/spritesheets')
os.system('rm -rf generated/from_spritesheets')

#generate_all_spritesheets('../PetsAssets')
generate_all_spritesheets('/Users/curzel/Downloads')
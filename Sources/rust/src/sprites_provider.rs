use std::collections::HashMap;
use std::path::Path;

use crate::sprite_set::SpriteSet;
use crate::sprite_set_builder::sprite_sets_from_root;

pub struct SpritesProvider {
    assets: HashMap<String, SpriteSet>,
    default_set: SpriteSet
}

impl SpritesProvider {
    pub fn new(path: &Path) -> Self {
        let assets = sprite_sets_from_root(path);
        
        SpritesProvider {
            assets,
            default_set: SpriteSet::empty()
        }
    }
}

impl SpritesProvider {
    pub fn sprite_set(&self, species: String) -> &SpriteSet {
        let set = self.assets.get(&species);
        return match set {
            Some(set) => set,
            None => &self.default_set
        }
    }
}
use crate::entity::Entity;
use crate::sprites_provider::SpritesProvider;

pub struct EntityBuilder {
    sprites_provider: SpritesProvider,
    fps: f32,
    speed: f32,
    size: f32
}

impl EntityBuilder {
    pub fn new(sprites_provider: SpritesProvider, fps: f32, speed: f32, size: f32) -> Self {
        EntityBuilder {
            sprites_provider,
            fps,
            speed,
            size
        }
    }
}

impl EntityBuilder {
    pub fn entity(&self, species: String) -> Entity {
        let sprite_set = self.sprites_provider.sprite_set(species);
        return Entity::new(sprite_set.clone(), self.size, self.speed, self.fps);
    }
}
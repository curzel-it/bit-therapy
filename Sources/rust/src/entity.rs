use crate::geometry::{Rect, Vector2d};
use crate::sprite::Sprite;
use crate::sprite_set::{SpriteSet, SpriteName};

pub struct Entity {
    sprite_set: SpriteSet,
    pub current_sprite: Sprite,
    pub body: Rect,
    speed: f32,
    fps: f32,
    direction: Vector2d
}

impl Entity {
    pub fn new(sprite_set: SpriteSet, size: f32, speed: f32, fps: f32) -> Self {
        let mut entity = Entity {
            sprite_set: sprite_set,
            current_sprite: Sprite::new(vec![], fps),
            body: Rect::new_square(size),
            speed: speed,
            fps: fps,
            direction: Vector2d::zero()
        };
        entity.load_sprite(SpriteName::Front);
        return entity;
    }
}

impl Entity {
    pub fn update(&mut self, time_since_last_update: u128) {
        let offset = self.offset(time_since_last_update);
        self.body.move_by(offset);
        self.current_sprite.update(time_since_last_update);
    }

    pub fn load_sprite(&mut self, name: SpriteName) {
        let frames = self.sprite_set.sprites(name);
        self.current_sprite = Sprite::new(frames, self.fps);
    }

    fn offset(&self, time_since_last_update: u128) -> Vector2d {
        return self.direction * self.speed * time_since_last_update as f32;
    }
}
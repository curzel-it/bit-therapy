use std::collections::HashMap;

#[derive(Debug, Clone)]
pub struct SpriteSet {
    movement: Vec<String>,
    fall: Vec<String>,
    front: Vec<String>,
    animations: HashMap<String, Vec<String>>
}

pub enum SpriteName {
    Movement,
    Front,
    Fall,
    Animation { name: String }
}

impl SpriteSet {
    pub fn new(
        movement: Vec<String>,
        fall: Vec<String>,
        front: Vec<String>,
        animations: HashMap<String, Vec<String>>
    ) -> Self {
        SpriteSet { movement, fall, front, animations }
    }

    pub fn empty() -> Self {
        SpriteSet {
            movement: Vec::new(),
            fall: Vec::new(),
            front: Vec::new(),
            animations: HashMap::new()
        }
    }
}

impl SpriteSet {
    pub fn movement_sprites(&self) -> Vec<String> {
        return self.sprites(SpriteName::Movement);
    }

    pub fn fall_sprites(&self) -> Vec<String> {
        return self.sprites(SpriteName::Fall);
    }

    pub fn front_sprites(&self) -> Vec<String> {
        return self.sprites(SpriteName::Front);
    }

    pub fn sprites(&self, sprite_name: SpriteName) -> Vec<String> {
        return match sprite_name {
            SpriteName::Movement => self.movement.clone(),
            SpriteName::Front => self.front.clone(),
            SpriteName::Fall => self.fall.clone(),
            SpriteName::Animation { name } => self.sprites_by_animation_name(name)
        }
    }

    fn sprites_by_animation_name(&self, name: String) -> Vec<String> {
        return self.animations.get(&name).unwrap_or(&Vec::new()).clone()
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_can_reference_standard_sprites() {
        let sprite_set = SpriteSet {
            movement: (0..3).map(|n| { format!("movement-{}", n) }) .collect(),
            fall: (0..3).map(|n| { format!("fall-{}", n) }) .collect(),
            front: (0..3).map(|n| { format!("front-{}", n) }) .collect(),
            animations: HashMap::new()
        };
        assert_eq!(sprite_set.sprites(SpriteName::Movement)[0], "movement-0".to_string());
        assert_eq!(sprite_set.sprites(SpriteName::Fall)[0], "fall-0".to_string());
        assert_eq!(sprite_set.sprites(SpriteName::Front)[0], "front-0".to_string());
    }

    #[test]
    fn test_can_reference_animations() {
        let sprite_set = SpriteSet {
            movement: Vec::new(),
            fall: Vec::new(),
            front: Vec::new(),
            animations: {
                let mut map = HashMap::new();
                map.insert("jump".to_string(), vec!["jump-1".to_string(), "jump-2".to_string()]);
                map.insert("run".to_string(), vec!["run-1".to_string(), "run-2".to_string()]);
                map.insert("slide".to_string(), vec!["slide-1".to_string(), "slide-2".to_string()]);
                map
            },
        };
        assert_eq!(sprite_set.sprites(SpriteName::Animation { name: "jump".to_string() })[0], "jump-1".to_string());
        assert_eq!(sprite_set.sprites(SpriteName::Animation { name: "run".to_string() })[0], "run-1".to_string());
        assert_eq!(sprite_set.sprites(SpriteName::Animation { name: "slide".to_string() })[0], "slide-1".to_string());
    }
}

use crate::entity::Entity;
use crate::entity_builder::EntityBuilder;
use crate::geometry::Rect;

pub struct Game {
    entity_builder: EntityBuilder,
    pub bounds: Rect,
    pub entities: Vec<Entity>
}

impl Game {
    pub fn new(entity_builder: EntityBuilder, bounds: Rect) -> Self {
        Game {
            entity_builder,
            bounds,
            entities: Vec::new()
        }
    }
}

impl Game {
    pub fn update(&mut self, time_since_last_update: u128) {
        for entity in self.entities.iter_mut() {
            entity.update(time_since_last_update);
        }
    }

    pub fn add(&mut self, species: String) -> &Entity {
        let entity = self.entity_builder.entity(species);
        self.entities.push(entity);
        return self.entities.last().unwrap();
    }
}
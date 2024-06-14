use std::collections::HashMap;
use std::path::Path;
use regex::Regex;

use crate::file_utils::list_files;
use crate::sprite_set::SpriteSet;

pub fn sprite_sets_from_root(path: &Path) -> HashMap<String, SpriteSet> { 
    let assets = list_files(path, "png");
    return sprite_sets_from_file_paths(assets)
}

fn sprite_sets_from_file_paths(files: Vec<String>) -> HashMap<String, SpriteSet> {
    let mut frames: Vec<SpriteFrame> = files
        .iter()
        .map(|path| { sprite_frame_from_path(path) })
        .flatten()
        .collect();

    frames.sort_by(|a, b| {
        a.species.cmp(&b.species)
            .then_with(|| a.animation.cmp(&b.animation))
            .then_with(|| a.index.cmp(&b.index))
    });

    let all_species = frames
        .iter()
        .map(|frame| { frame.species.to_string() })
        .collect();

    return sprite_sets_for_species(frames, all_species);
}

fn sprite_sets_for_species(frames: Vec<SpriteFrame>, all_species: Vec<String>) -> HashMap<String, SpriteSet> {
    return all_species.iter().fold(HashMap::new(), |mut acc, species| {
        let aggregated_frames = frames
            .iter()
            .filter(|frame| { frame.species == *species })
            .fold(HashMap::new(), |mut acc, frame| {
                let key = frame.animation.to_string();
                let list = acc.entry(key).or_insert(Vec::new());
                list.push(frame);
                acc
            });

        let movement = get_animation_paths(&aggregated_frames, "movement");
        let front = get_animation_paths(&aggregated_frames, "front");
        let fall = get_animation_paths(&aggregated_frames, "fall");
            
        let animations = aggregated_frames.keys().fold(HashMap::new(), |mut acc, animation_name| {
            let frames = aggregated_frames.get(animation_name).unwrap();
            let paths: Vec<String> = frames.iter().map(|frame| { frame.path.to_string() }).collect();
            acc.insert(animation_name.clone(), paths);
            acc
        });

        let set = SpriteSet::new(movement, fall, front, animations);
        acc.insert(species.to_string(), set);
        
        acc
    });
} 

fn get_animation_paths(aggregated_frames: &HashMap<String, Vec<&SpriteFrame>>, animation_key: &str) -> Vec<String> {
    aggregated_frames
        .get(animation_key)
        .unwrap_or(&Vec::new())
        .iter()
        .map(|frame| frame.path.to_string())
        .collect()
}

#[derive(PartialEq, Eq, Debug)]
struct SpriteFrame {
    path: String, 
    species: String, 
    animation: String, 
    index: i32
}

fn sprite_frame_from_path(path: &str) -> Option<SpriteFrame> {
    let file_name = file_name(path)
        .replace("_walk.", "_movement.")
        .replace("_fly.", "_movement.");

    let re = Regex::new(r"^(?P<species>[a-z_]+)_(?P<animation>[a-z]+)-(?P<index>\d+)$").unwrap();
    
    match re.captures(file_name.as_str()) {
        Some(caps) => {
            let species = caps.name("species").unwrap().as_str().to_string();
            let animation = caps.name("animation").unwrap().as_str().to_string();
            let index_string = caps.name("index").unwrap().as_str().to_string();
            let index = index_string.parse::<i32>().unwrap_or(-1);
            
            return if index >= 0 { 
                Some(SpriteFrame { 
                    path: path.to_string(), 
                    species, 
                    animation, 
                    index 
                }) 
            } else { 
                None 
            };
        },
        None => None
    }
}

fn file_name(path: &str) -> &str {
    return Path::new(path)
        .file_stem()
        .and_then(|name| name.to_str())
        .unwrap_or("");
}

#[cfg(test)]
mod tests {
    use crate::sprite_set::SpriteName;

    use super::*;
    use std::collections::HashMap;

    fn create_test_files() -> Vec<String> {
        vec![
            "ape_eat-0".to_string(),
            "ape_eat-1".to_string(),
            "ape_movement-0".to_string(),
            "ape_movement-1".to_string(),
            "ape_front-0".to_string(),
            "ape_fall-0".to_string(),
            "cat_eat-0".to_string(),
            "cat_movement-0".to_string(),
            "cat_fall-0".to_string(),
            "cat_front-0".to_string(),
        ]
    }

    #[test]
    fn test_sprite_sets_aggregation() {
        let files = create_test_files();
        let sprite_sets = sprite_sets_from_file_paths(files);

        assert_eq!(sprite_sets.len(), 2, "Should have sprite sets for two species: ape and cat");

        let ape_set = sprite_sets.get("ape").unwrap();
        let cat_set = sprite_sets.get("cat").unwrap();

        assert_eq!(ape_set.movement_sprites().len(), 2, "Ape should have 2 movement frames");
        assert_eq!(ape_set.fall_sprites().len(), 1, "Ape should have 1 fall frame");
        assert_eq!(ape_set.front_sprites().len(), 1, "Ape should have 1 front frame");

        assert_eq!(cat_set.movement_sprites().len(), 1, "Cat should have 1 movement frame");
        assert_eq!(cat_set.fall_sprites().len(), 1, "Cat should have 1 fall frame");
        assert_eq!(cat_set.front_sprites().len(), 1, "Cat should have 1 front frame");
    }

    #[test]
    fn test_sprite_sets_correct_animation_paths() {
        let files = create_test_files();
        let sprite_sets = sprite_sets_from_file_paths(files);

        let ape_set = sprite_sets.get("ape").unwrap();
        let cat_set = sprite_sets.get("cat").unwrap();

        assert_eq!(ape_set.sprites(SpriteName::Animation { name: "eat".to_string()}).len(), 2);
        assert_eq!(cat_set.sprites(SpriteName::Animation { name: "eat".to_string()}).len(), 1);
    }

    #[test]
    fn test_empty_input() {
        let files = Vec::new();
        let sprite_sets = sprite_sets_from_file_paths(files);

        assert!(sprite_sets.is_empty(), "Sprite sets should be empty for empty input");
    }

    #[test]
    fn test_file_name_from_path() {
        assert_eq!(file_name("/asd/sdf/dfg/some_file_name.txt"), "some_file_name");
        assert_eq!(file_name("/asd/sdf/dfg/some_file_name"), "some_file_name");
        assert_eq!(file_name("file:///asd/sdf/dfg/some_file_name.txt"), "some_file_name");
        assert_eq!(file_name("some_file_name.txt"), "some_file_name");
    }

    #[test]
    fn test_sprite_frame_from_path() {
        let result = sprite_frame_from_path("ape_eat-0");
        let expected = Some(SpriteFrame { 
            path: "ape_eat-0".to_string(), 
            species: "ape".to_string(), 
            animation: "eat".to_string(), 
            index: 0 
        });
        assert_eq!(expected, result);
    }

    #[test]
    fn test_sprite_frame_from_path_with_complicated_species_name() {
        let result = sprite_frame_from_path("ape_chef_eat-0");
        let expected = Some(SpriteFrame { 
            path: "ape_chef_eat-0".to_string(), 
            species: "ape_chef".to_string(), 
            animation: "eat".to_string(), 
            index: 0 
        });
        assert_eq!(expected, result);
    }

    #[test]
    fn test_sprite_frame_from_invalid_path() {
        let result = sprite_frame_from_path("apechefeat-0");
        assert_eq!(None, result);
    }

    #[test]
    fn test_get_animation_paths_with_existing_key() {
        let frame1 = SpriteFrame { 
            path: "path1".to_string(), 
            species: "species1".to_string(), 
            animation: "run".to_string(), 
            index: 1 
        };
        let frame2 = SpriteFrame { 
            path: "path2".to_string(), 
            species: "species1".to_string(), 
            animation: "run".to_string(), 
            index: 2 
        };
        let mut aggregated_frames = HashMap::new();
        aggregated_frames.insert(String::from("run"), vec![&frame1, &frame2]);

        let paths = get_animation_paths(&aggregated_frames, "run");
        assert_eq!(paths, vec!["path1", "path2"]);
    }

    #[test]
    fn test_get_animation_paths_with_nonexistent_key() {
        let frame1 = SpriteFrame { 
            path: "path1".to_string(), 
            species: "species1".to_string(), 
            animation: "run".to_string(), 
            index: 1 
        };
        let frame2 = SpriteFrame { 
            path: "path2".to_string(), 
            species: "species1".to_string(), 
            animation: "run".to_string(), 
            index: 2 
        };
        let mut aggregated_frames = HashMap::new();
        aggregated_frames.insert(String::from("run"), vec![&frame1, &frame2]);

        let paths = get_animation_paths(&aggregated_frames, "walk");
        assert!(paths.is_empty());
    }
}
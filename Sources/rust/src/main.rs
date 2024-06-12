#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]
#![allow(rustdoc::missing_crate_level_docs)]

use eframe::egui;
use eframe::epaint::Color32;
use egui::{Frame, ViewportBuilder};
use entity_builder::EntityBuilder;
use game::Game;
use geometry::Rect;
use sprites_provider::SpritesProvider;
use std::path::Path;
use std::thread::{self, JoinHandle};
use std::time::{Duration, Instant};

pub mod timed_content_provider;
pub mod sprite;
pub mod sprite_set;
pub mod sprite_set_builder;
pub mod game;
pub mod geometry;
pub mod entity;
pub mod entity_builder;
pub mod file_utils;
pub mod sprites_provider;

fn main() -> Result<(), eframe::Error> {
    env_logger::init(); 

    let path = Path::new("../../PetsAssets");
    let sprites_provider = SpritesProvider::new(path);
    let entity_builder = EntityBuilder::new(sprites_provider, 10.0, 1.0, 100.0);
    let bounds = Rect::new_at_origin(1920.0, 1080.0);
    
    let mut game = Game::new(entity_builder, bounds);
    game.add("ape".to_string());
    game.add("cat_blue".to_string());
    
    let options = eframe::NativeOptions {
        viewport: ViewportBuilder::default()
            .with_position([0.0, 0.0])
            .with_inner_size([game.bounds.size.w, game.bounds.size.h])
            .with_always_on_top()
            // .with_transparent(true)
            .with_drag_and_drop(true),
            // .with_decorations(false),
        ..Default::default()
    };
    start_game_loop();

    eframe::run_native(
        "My egui App",
        options,
        Box::new(|cc: &eframe::CreationContext| {
            egui_extras::install_image_loaders(&cc.egui_ctx);

            Box::new(MyApp::new(cc, game))
        })
    )
}

struct MyApp {
    game: Game
}

impl MyApp {
    fn new(_cc: &eframe::CreationContext<'_>, game: Game) -> Self {
        Self {
            game
        }
    }
}

impl eframe::App for MyApp {
    fn update(&mut self, ctx: &egui::Context, _frame: &mut eframe::Frame) {
        egui::CentralPanel::default()
            .frame(Frame::none().fill(Color32::from_black_alpha(0)))
            .show(ctx, |ui| {                
                for entity in self.game.entities.iter() {
                    let image_path = entity.current_sprite.current_frame();
                    ui.add(
                        egui::Image::new(format!("file://{image_path}"))
                            .texture_options(egui::TextureOptions::NEAREST)
                            .max_height(entity.body.size.h)
                            .max_width(entity.body.size.w)
                    );                    
                }
            });
    }

    fn clear_color(&self, _visuals: &eframe::egui::Visuals) -> [f32; 4] {
        [0.0, 0.0, 0.0, 0.0]
    }
}

fn start_game_loop() -> JoinHandle<i32> {
    let handle: JoinHandle<i32> = thread::spawn(move || {
        let frame_duration = Duration::from_millis(1000 / 30);
        let start_time = Instant::now();

        loop {
            let elapsed_time = Instant::now() - start_time;
            update(elapsed_time.as_millis());
            thread::sleep(frame_duration);
        }
    });

    return handle;
}

fn update(time: u128) {
    // println!("Next frame scheduled at {:?}", time);
}
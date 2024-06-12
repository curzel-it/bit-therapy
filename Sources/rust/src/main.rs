#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]
#![allow(rustdoc::missing_crate_level_docs)]

use std::path::Path;
use std::sync::mpsc;
use std::thread::{self, JoinHandle};
use std::time::{Duration, Instant};

use eframe::egui;
use eframe::epaint::Color32;
use egui::{Frame, ViewportBuilder};

use entity::Entity;
use entity_builder::EntityBuilder;
use game::Game;
use geometry::Rect;
use sprites_provider::SpritesProvider;

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
    
    let options = eframe::NativeOptions {
        viewport: ViewportBuilder::default()
            .with_position([0.0, 0.0])
            .with_inner_size([1000.0, 1000.0])
            .with_always_on_top()
            // .with_transparent(true)
            .with_drag_and_drop(true),
            // .with_decorations(false),
        ..Default::default()
    };

    eframe::run_native(
        "My egui App",
        options,
        Box::new(|cc: &eframe::CreationContext| {
            egui_extras::install_image_loaders(&cc.egui_ctx);

            Box::new(MyApp::new(cc))
        })
    )
}

struct MyApp {
    game: Game
}

impl MyApp {
    fn new(_cc: &eframe::CreationContext<'_>) -> Self {
        let path = Path::new("../../PetsAssets");
        let sprites_provider = SpritesProvider::new(path);
        let entity_builder = EntityBuilder::new(sprites_provider, 10.0, 1.0, 100.0);
        let bounds = Rect::new_at_origin(1920.0, 1080.0);
        
        let mut game = Game::new(entity_builder, bounds);
        game.add("ape".to_string());
        game.add("cat_blue".to_string());
        
        let mut app = MyApp { game };
        app.start_game_loop();
        return app;
    }
}

impl eframe::App for MyApp {
    fn update(&mut self, ctx: &egui::Context, _frame: &mut eframe::Frame) {
        egui::CentralPanel::default()
            .frame(Frame::none().fill(Color32::from_black_alpha(0)))
            .show(ctx, |ui| {                
                for entity in self.game.entities.iter() {            
                    self.render_entity(ui, entity);   
                }
            });
    }

    fn clear_color(&self, _visuals: &eframe::egui::Visuals) -> [f32; 4] {
        [0.0, 0.0, 0.0, 0.0]
    }
}

impl MyApp {
    fn render_entity(&self, ui: &mut egui::Ui, entity: &Entity) {
        let image_path = entity.current_sprite.current_frame();                    
        let position = egui::pos2(entity.body.origin.x, entity.body.origin.y);
        let size = egui::Vec2::new(entity.body.size.w, entity.body.size.h);
        let rect = egui::Rect::from_min_size(position, size);

        ui.put(
            rect,
            egui::Image::new(format!("file://{image_path}"))
                .texture_options(egui::TextureOptions::NEAREST)
                .max_width(entity.body.size.w)
                .max_height(entity.body.size.h)
        );     
    }
}

impl MyApp {
    fn start_game_loop(&mut self) -> JoinHandle<i32> {
        let (tx, rx) = mpsc::channel::<u128>();

        let handler = thread::spawn(move || {
            let frame_duration = Duration::from_millis(1000 / 60);
            let mut last_update_time = Instant::now();

            loop {
                let now = Instant::now();
                let elapsed_time = (now - last_update_time).as_millis();
                last_update_time = now;

                tx.send(elapsed_time).unwrap();
                thread::sleep(frame_duration);
            }
        });
        
        while let Ok(elapsed_time) = rx.recv() {
            self.game.update(elapsed_time); 
        }

        return handler;
    }
}
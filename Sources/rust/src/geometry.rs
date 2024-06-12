use std::ops::{AddAssign, Mul};

#[derive(Debug, Clone, Copy)]
pub struct Vector2d {
    pub x: f32,
    pub y: f32
}

impl Vector2d {
    pub fn zero() -> Self {
        return Vector2d { x: 0.0, y: 0.0 };
    }
}

impl Mul<f32> for Vector2d {
    type Output = Vector2d;

    fn mul(self, scalar: f32) -> Self::Output {
        Vector2d {
            x: self.x * scalar,
            y: self.y * scalar,
        }
    }
}

impl AddAssign<Vector2d> for Vector2d {
    fn add_assign(&mut self, other: Vector2d) {
        self.x += other.x;
        self.y += other.y;
    }
}

use Vector2d as Point;

#[derive(Debug, Clone, Copy)]
pub struct Size {
    pub w: f32,
    pub h: f32
}

#[derive(Debug, Clone, Copy)]
pub struct Rect {
    pub origin: Point, 
    pub size: Size
}

impl Rect {
    pub fn new(x: f32, y: f32, w: f32, h: f32) -> Self {
        Rect {
            origin: Point { x, y },
            size: Size { w, h }
        }
    }

    pub fn new_at_origin(w: f32, h: f32) -> Self {
        return Rect::new(0.0, 0.0, w, h);
    }


    pub fn new_square(w: f32) -> Self {
        return Rect::new(0.0, 0.0, w, w);
    }
}

impl Rect {
    pub fn move_by(&mut self, vec: Vector2d) {
        self.origin += vec;
    }
}
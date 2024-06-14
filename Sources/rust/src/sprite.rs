use crate::timed_content_provider::TimedContentProvider;

pub struct Sprite {
    content_provider: TimedContentProvider<String>
}

impl Sprite {
    pub fn new(frames: Vec<String>, fps: f32) -> Self {
        let content_provider = TimedContentProvider::new(frames, fps);
        return Sprite {
            content_provider
        };
    }

    pub fn update(&mut self, time_since_last_update: u128) {
        self.content_provider.update(time_since_last_update);
    }

    pub fn current_frame(&self) -> &String {
        return self.content_provider.current_frame();
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_current_frame() {
        let sprite = Sprite::new(vec!["10".to_string(), "20".to_string(), "30".to_string()], 1.0);
        assert_eq!(*sprite.current_frame(), "10".to_string());
    }

    #[test]
    fn test_next_frame_advance() {
        let mut sprite = Sprite::new(vec!["10".to_string(), "20".to_string(), "30".to_string()], 1.0);
        
        sprite.update(500);
        assert_eq!(*sprite.current_frame(), "10".to_string());
        
        sprite.update(500);
        assert_eq!(*sprite.current_frame(), "20".to_string());
        
        sprite.update(1000);
        assert_eq!(*sprite.current_frame(), "30".to_string());
    }

    #[test]
    fn test_next_frame_with_insufficient_time_does_not_advance() {
        let mut sprite = Sprite::new(vec!["10".to_string(), "20".to_string(), "30".to_string()], 1.0);
        
        sprite.update(300);
        assert_eq!(*sprite.current_frame(), "10".to_string());
        
        sprite.update(300);
        assert_eq!(*sprite.current_frame(), "10".to_string());
        
        sprite.update(300);
        assert_eq!(*sprite.current_frame(), "10".to_string());
        
        sprite.update(300);
        assert_eq!(*sprite.current_frame(), "20".to_string());
        
        sprite.update(1000);
        assert_eq!(*sprite.current_frame(), "30".to_string());
    }
}

pub struct TimedContentProvider<T> {
    frames: Vec<T>,
    frame_duration: u128,
    on_loop_completed: Option<Box<dyn Fn(u128)>>,
    current_frame_index: usize,
    completed_loops: u128,
    last_update_time: u128,
    last_frame_change_time: u128
}

impl<T> TimedContentProvider<T> {
    pub fn new(
        frames: Vec<T>,
        fps: f32,
        on_loop_completed: Option<Box<dyn Fn(u128)>>,
    ) -> Self {
        let frame_duration = if fps > 0.0 {
            (1000.0 / fps) as u128
        } else {
            0
        };

        TimedContentProvider {
            frames,
            frame_duration,
            on_loop_completed,
            current_frame_index: 0,
            completed_loops: 0,
            last_update_time: 0,
            last_frame_change_time: 0
        }
    }

    pub fn current_frame(&self) -> &T {
        &self.frames[self.current_frame_index]
    }

    pub fn update(&mut self, time_since_last_update: u128) {
        self.last_update_time = self.last_update_time + time_since_last_update;

        let elapsed = self.last_update_time - self.last_frame_change_time;
        if elapsed >= self.frame_duration {
            self.load_next_frame();
            self.last_frame_change_time = self.last_update_time;
        }
    }

    fn load_next_frame(&mut self) {
        let next_index = (self.current_frame_index + 1) % self.frames.len();
        
        if self.current_frame_index != next_index {
            self.check_loop_completion(next_index);
            self.current_frame_index = next_index;
        }
    }

    fn check_loop_completion(&mut self, next_index: usize) {
        if next_index < self.current_frame_index {
            self.completed_loops += 1;
            
            if let Some(ref mut callback) = self.on_loop_completed {
                callback(self.completed_loops);
            }
        }
    }

    pub fn clear_hooks(&mut self) {
        self.on_loop_completed = None;
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_initialization() {
        let provider = TimedContentProvider::<i32>::new(vec![1, 2, 3], 2.0, None);
        assert_eq!(provider.frames.len(), 3);
        assert_eq!(provider.frame_duration, 500);
    }

    #[test]
    fn test_current_frame() {
        let provider = TimedContentProvider::new(vec![10, 20, 30], 1.0, None);
        assert_eq!(*provider.current_frame(), 10);
    }

    #[test]
    fn test_next_frame_advance() {
        let mut provider = TimedContentProvider::new(vec![10, 20, 30], 1.0, None);
        
        provider.update(500);
        assert_eq!(provider.current_frame(), &10);
        
        provider.update(500);
        assert_eq!(provider.current_frame(), &20);
        
        provider.update(1000);
        assert_eq!(provider.current_frame(), &30);
    }

    #[test]
    fn test_next_frame_with_insufficient_time_does_not_advance() {
        let mut provider = TimedContentProvider::new(vec![10, 20, 30], 1.0, None);
        
        provider.update(300);
        assert_eq!(provider.current_frame(), &10);
        
        provider.update(300);
        assert_eq!(provider.current_frame(), &10);
        
        provider.update(300);
        assert_eq!(provider.current_frame(), &10);
        
        provider.update(300);
        assert_eq!(provider.current_frame(), &20);
        
        provider.update(1000);
        assert_eq!(provider.current_frame(), &30);
    }

    #[test]
    fn test_clear_hooks() {
        let mut provider = TimedContentProvider::new(vec![10, 20, 30], 1.0, None);
        provider.clear_hooks();
        assert!(provider.on_loop_completed.is_none());
    }
}

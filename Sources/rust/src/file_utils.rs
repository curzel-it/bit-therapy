use std::fs;
use std::path::Path;

pub fn list_files(path: &Path, extension: &str) -> Vec<String> {
    let mut files = Vec::new();
    if path.is_dir() {
        if let Ok(entries) = fs::read_dir(path) {
            for entry in entries.flatten() {
                let path = entry.path();
                
                if path.is_file() && path.extension().unwrap_or_default() == extension {
                    if let Some(str_path) = path.to_str() {
                        files.push(str_path.to_owned());
                    }
                }
            }
        }
    }
    files
}
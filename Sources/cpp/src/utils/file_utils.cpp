#include "file_utils.h"

std::vector<std::string> listFiles(const std::string& directory, const std::string& extension) {
    std::vector<std::string> files;
    for (const auto& entry : std::filesystem::directory_iterator(directory)) {
        if (entry.is_regular_file()) {
            auto& path = entry.path();
            if (path.extension() == extension) {
                files.push_back(path.string());
            }
        }
    }
    return files;
}

std::string fileName(const std::string& path) {
    std::filesystem::path fs_path(path);
    return fs_path.stem().string(); 
}

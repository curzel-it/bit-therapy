#ifndef FILE_UTILS_H
#define FILE_UTILS_H

#include <filesystem>
#include <iostream>
#include <string>
#include <vector>

std::vector<std::string> listFiles(const std::string& directory, const std::string& extension);
std::string fileName(const std::string& path);

#endif

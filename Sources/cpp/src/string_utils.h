#ifndef STRING_UTILS_H
#define STRING_UTILS_H

#include <iostream>
#include <optional>
#include <string>

void updateByReplacing(std::string& input, const std::string& old_token, const std::string& new_token);
std::string replace(const std::string input, const std::string& old_token, const std::string& new_token);

std::optional<int> parseInt(const std::string s);

#endif
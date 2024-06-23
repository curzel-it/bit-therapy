#ifndef STRING_UTILS_H
#define STRING_UTILS_H

#include <algorithm>
#include <cctype>
#include <iostream>
#include <optional>
#include <string>

void updateByReplacing(std::string& input, const std::string& old_token, const std::string& new_token);
std::string replace(const std::string input, const std::string& old_token, const std::string& new_token);

std::optional<uint32_t> parseInt(const std::string s);

std::string lowered(std::string s);

void trim(std::string &s);
void ltrim(std::string &s);
void rtrim(std::string &s);
std::string ltrim_copy(std::string s);
std::string rtrim_copy(std::string s);
std::string trim_copy(std::string s);

#endif
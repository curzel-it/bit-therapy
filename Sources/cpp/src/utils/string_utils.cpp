#include "string_utils.h"

void updateByReplacing(std::string& input, const std::string& old_token, const std::string& new_token) {
    if (old_token == "") { 
        return; 
    }
    size_t start_pos = input.find(old_token);

    while (start_pos != std::string::npos) {
        input.replace(start_pos, old_token.length(), new_token);
        start_pos = input.find(old_token, start_pos + new_token.length());
    }
}

std::string replace(const std::string input, const std::string& old_token, const std::string& new_token) {
    std::string working = input;
    updateByReplacing(working, old_token, new_token);
    return working;
}

std::optional<uint32_t> parseInt(const std::string s) {
    try {
        uint32_t value = std::stoi(s);
        return value;
    } catch (...) {
        return std::nullopt;
    }
}

std::string lowered(std::string s) {
    std::transform(
        s.begin(), s.end(), s.begin(),
        [](unsigned char c) -> unsigned char { return std::tolower(c); }
    );
    return s;
}

void trim(std::string &s) {
    rtrim(s);
    ltrim(s);
}

void ltrim(std::string &s) {
    s.erase(s.begin(), std::find_if(s.begin(), s.end(), [](unsigned char ch) {
        return !std::isspace(ch);
    }));
}

void rtrim(std::string &s) {
    s.erase(std::find_if(s.rbegin(), s.rend(), [](unsigned char ch) {
        return !std::isspace(ch);
    }).base(), s.end());
}

std::string ltrim_copy(std::string s) {
    ltrim(s);
    return s;
}

std::string rtrim_copy(std::string s) {
    rtrim(s);
    return s;
}

std::string trim_copy(std::string s) {
    trim(s);
    return s;
}
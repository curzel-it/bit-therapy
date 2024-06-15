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

std::optional<int> parseInt(const std::string s) {
    try {
        int value = std::stoi(s);
        return value;
    } catch (...) {
        return std::nullopt;
    }
}
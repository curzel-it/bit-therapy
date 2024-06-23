#ifndef VECTOR_UTILS_H
#define VECTOR_UTILS_H

#include <functional>
#include <map>
#include <numeric>
#include <optional>
#include <set>
#include <vector>

template <typename T>
std::set<T> setFrom(const std::vector<T>& items) {
    std::set<T> uniqueItems;
    for (const auto& item : items) {
        uniqueItems.insert(item);
    }
    return uniqueItems;
}

template <typename T, typename K>
std::vector<K> map(const std::vector<T>& items, std::function<K(const T&)> mapper) {
    std::vector<K> results;
    for (const auto& item : items) {
        results.push_back(mapper(item));
    }
    return results;
}

template <typename T, typename K>
std::vector<K> compactMap(const std::vector<T>& items, std::function<std::optional<K>(const T&)> mapper) {
    std::vector<K> results;
    for (const auto& item : items) {
        std::optional<K> value = mapper(item);
        if (value.has_value()) {
            results.push_back(value.value());
        }        
    }
    return results;
}

template <typename T>
std::vector<T> distinct(const std::vector<T>& items) {
    std::vector<T> output;
    auto itemsSet = setFrom(items);
    std::copy(itemsSet.begin(), itemsSet.end(), std::back_inserter(output));
    return output;
}

template <typename T, typename K>
std::map<K, std::vector<T>> aggregate(const std::vector<T>& items, std::function<K(const T&)> keyer) {
    auto merger = [keyer](std::map<K, std::vector<T>> accum, const T& item) -> std::map<K, std::vector<T>> {
        K key = keyer(item);
        accum[key].push_back(item);
        return accum;
    };
    return std::reduce(
        items.begin(), items.end(),
        std::map<K, std::vector<T>>{},
        merger
    );
}

template <typename T, typename K, typename V>
std::map<K, std::vector<V>> aggregateMap(
    const std::vector<T>& items, 
    std::function<K(const T&)> keyer, 
    std::function<V(const T&)> mapper
) {
    auto merger = [keyer, mapper](std::map<K, std::vector<V>> accum, const T& item) -> std::map<K, std::vector<V>> {
        K key = keyer(item);
        V value = mapper(item);
        accum[key].push_back(value);
        return accum;
    };
    return std::reduce(
        items.begin(), items.end(),
        std::map<K, std::vector<V>>{},
        merger
    );
}

template <typename T, typename K>
std::map<K, T> makeLookup(
    const std::vector<T>& items, 
    std::function<K(const T&)> keyer
) {
    auto merger = [keyer](std::map<K, T> accum, const T& item) -> std::map<K, T> {
        accum.emplace(keyer(item), item);
        return accum;
    };
    return std::reduce(
        items.begin(), items.end(),
        std::map<K, T>{},
        merger
    );
}

template <typename T, typename K>
void sort(std::vector<T>& items, std::function<K(const T&)> mapper) {
    std::sort(
        items.begin(), items.end(), 
        [mapper](const T& a, const T& b) { return mapper(a) < mapper(b); }
    );
}

#endif
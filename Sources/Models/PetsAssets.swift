import Schwifty
import SwiftUI

class PetsAssetsProvider {
    static let shared = PetsAssetsProvider()
    
    private var allAssetsUrls: [URL] = []
    private var sortedAssetsByKey: [String: [Asset]] = [:]
    
    init() {
        reloadAssets()
    }
    
    func frames(for species: String, animation: String) -> [String] {
        let assets = sortedAssetsByKey[key(for: species, animation: animation)] ?? []
        return assets.map { $0.sprite }
    }
    
    func images(for species: String, animation: String) -> [NSImage] {
        frames(for: species, animation: animation)
            .compactMap { image(sprite: $0) }
    }
    
    func image(sprite: String?) -> NSImage? {
        guard let sprite else { return nil }
        guard let url = url(sprite: sprite) else { return nil }
        return NSImage(contentsOf: url)
    }
    
    func allAssets(for species: String) -> [URL] {
        allAssetsUrls.filter { $0.absoluteString.contains(species) }
    }
    
    func reloadAssets() {
        allAssetsUrls = originalUrls() + customUrls()
        
        sortedAssetsByKey = allAssetsUrls
            .map { Asset(url: $0) }
            .sorted { $0.frame < $1.frame }
            .reduce([String: [Asset]](), { previousCache, asset in
                var cache = previousCache
                let previousFrames = (cache[asset.key] ?? []).map { $0.frame }
                if !previousFrames.contains(asset.frame) {
                    cache[asset.key] = (cache[asset.key] ?? []) + [asset]
                }
                return cache
            })
    }
    
    private func url(sprite: String) -> URL? {
        guard let key = key(fromSprite: sprite) else { return nil }
        return sortedAssetsByKey[key]?
            .filter { $0.sprite == sprite }
            .first?
            .url
    }
    
    private func key(for species: String, animation: String) -> String {
        "\(species)_\(animation)"
    }
    
    private func key(fromSprite sprite: String) -> String? {
        sprite.components(separatedBy: "-").first
    }
}

private extension PetsAssetsProvider {
    func originalUrls() -> [URL] {
        Bundle.main.urls(forResourcesWithExtension: "png", subdirectory: "PetsAssets") ?? []
    }
    
    func customUrls() -> [URL] {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        guard let url else { return [] }
        let urls = try? FileManager.default
            .contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
            .filter { $0.pathExtension == "png" }
        return urls ?? []
    }
}

private struct Asset {
    let url: URL
    let key: String
    let sprite: String
    let frame: Int
    
    init(url: URL) {
        self.url = url
        let sprite = url.spriteName
        let tokens = sprite.components(separatedBy: "-")
        key = tokens.first ?? ""
        frame = Int(tokens.last ?? "") ?? 0
        self.sprite = sprite
    }
}

private extension URL {
    var spriteName: String {
        absoluteString
            .components(separatedBy: "/")
            .last?
            .components(separatedBy: ".")
            .first ?? ""
    }
}

import Schwifty
import SwiftUI

class PetsAssetsProvider {
    static let shared = PetsAssetsProvider()
    
    func frames(for species: String, animation: String) -> [String] {
        let assets = sortedAssetsByKey[key(for: species, animation: animation)] ?? []
        return assets.map { $0.sprite }
    }
    
    func image(sprite: String?) -> NSImage? {
        guard let sprite else { return nil }
        guard let url = url(sprite: sprite) else { return nil }
        return NSImage(contentsOf: url)
    }
        
    private lazy var sortedAssetsByKey: [String: [Asset]] = {
        Bundle.main
            .urls(forResourcesWithExtension: "png", subdirectory: "PetsAssets")?
            .map { Asset(url: $0) }
            .sorted { $0.frame < $1.frame }
            .reduce([String: [Asset]](), { previousCache, asset in
                var cache = previousCache
                cache[asset.key] = (cache[asset.key] ?? []) + [asset]
                return cache
            }) ?? [:]
    }()
    
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

private extension String {
    var frameIndex: Int {
        let indexString = components(separatedBy: "-")
            .last?
            .components(separatedBy: ".")
            .first
        return Int(indexString ?? "") ?? 99
    }
}

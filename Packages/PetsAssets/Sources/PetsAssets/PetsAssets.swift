import SwiftUI

public class PetsAssetsProvider {
    public static let shared = PetsAssetsProvider()

    public func assetsAvailable(for species: String) -> Bool {
        frames(for: species, animation: "front").count > 0
    }

    public func frames(for species: String, animation: String) -> [String] {
        let assets = sortedAssetsByKey[key(for: species, animation: animation)] ?? []
        return assets.map { $0.url.spriteName }
    }

    public func image(sprite: String?) -> NSImage? {
        guard let sprite else { return nil }
        if let cached = cachedImages[sprite] { return cached }
        guard let url = url(sprite: sprite) else { return nil }
        guard let image = NSImage(contentsOf: url) else { return nil }
        cachedImages[sprite] = image
        return image
    }

    private func url(sprite: String?) -> URL? {
        Bundle.module.url(forResource: sprite, withExtension: "png", subdirectory: assetsPath)
    }

    private let assetsPath = "Assets/Pets"

    private var cachedImages: [String: NSImage] = [:]

    private lazy var urls: [URL] = {
        Bundle.module.urls(forResourcesWithExtension: "png", subdirectory: assetsPath) ?? []
    }()

    private lazy var assets: [Asset] = urls.map { Asset(url: $0) }

    private lazy var sortedAssetsByKey: [String: [Asset]] = {
        let availableKeys = Set(assets.map { $0.key })
        return availableKeys.reduce([:]) { previousCache, key in
            var cache = previousCache
            cache[key] = assets
                .filter { $0.key == key }
                .sorted { $0.frame < $1.frame }
            return cache
        }
    }()

    private func key(for species: String, animation: String) -> String {
        "\(species)_\(animation)"
    }
}

private struct Asset {
    let url: URL
    let key: String
    let frame: Int

    init(url: URL) {
        self.url = url
        let tokens = url.spriteName.components(separatedBy: "-")
        key = tokens.first ?? ""
        frame = Int(tokens.last ?? "") ?? 0
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

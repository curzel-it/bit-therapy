import NotAGif
import Schwifty
import Squanch
import SwiftUI
import Yage

public class PetsAssets {
    public static func isAvailable(_ baseName: String) -> Bool {
        frames(for: baseName).count > 0
    }
    
    public static func frames(for baseName: String) -> [ImageFrame] {
        let paths = baseName.components(separatedBy: "_")
        
        if paths.count > 2 {
            let path = paths.joined(separator: "/")
            return frames(fromDirectory: "Assets/pets/\(path)")
        }
        if paths.count == 2 {
            let species = paths[0]
            let action = paths[1]
            let path = [species, "original", action].joined(separator: "/")
            return frames(fromDirectory: "Assets/pets/\(path)")
        }
        return frames(fromDirectory: "Assets/\(baseName)")
    }
    
    private static func frames(fromDirectory dir: String) -> [ImageFrame] {
#if os(macOS)
        let urls = Bundle.module.urls(forResourcesWithExtension: "png", subdirectory: dir) ?? []
        return urls
            .sortedByFrameIndex()
            .compactMap { NSImage(contentsOf: $0) }
#else
        let paths = Bundle.module.paths(forResourcesOfType: "png", inDirectory: dir)
        return paths
            .sortedByFrameIndex()
            .compactMap { UIImage(contentsOfFile: $0) }
#endif
    }
}

private extension Array where Element == URL {
    func sortedByFrameIndex() -> [Element] {
        sorted { $0.absoluteString.frameIndex < $1.absoluteString.frameIndex }
    }
}

private extension Array where Element == String {
    func sortedByFrameIndex() -> [Element] {
        sorted { $0.frameIndex < $1.frameIndex }
    }
}

private extension String {
    var frameIndex: Int {
        let indexString = self
            .components(separatedBy: "-")
            .last?
            .components(separatedBy: ".")
            .first
        return Int(indexString ?? "") ?? 99
    }
}

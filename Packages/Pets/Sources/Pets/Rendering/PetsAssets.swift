//
// Pet Therapy.
//

import NotAGif
import Schwifty
import Squanch
import SwiftUI

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
        let urls = Bundle.module.urls(
            forResourcesWithExtension: "png",
            subdirectory: dir
        ) ?? []
        
        return urls
            .sorted {$0.absoluteString < $1.absoluteString }
            .compactMap { NSImage(contentsOf: $0) }
    }
}

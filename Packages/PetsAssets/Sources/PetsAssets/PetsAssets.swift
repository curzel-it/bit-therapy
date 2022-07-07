//
// Pet Therapy.
//

import AppKit
import Schwifty
import Squanch

public class PetsAssets {
    
    public static func isAvailable(_ baseName: String) -> Bool {
        frames(for: baseName).count > 0
    }
    
    public static func frames(for baseName: String) -> [NSImage] {
        let paths = baseName.components(separatedBy: "_")
        
        if paths.count > 2 {
            let path = paths.joined(separator: "/")
            return frames(fromDirectory: "Resources/pets/\(path)")
        }
        if paths.count == 2 {
            let species = paths[0]
            let action = paths[1]
            let path = [species, "original", action].joined(separator: "/")
            return frames(fromDirectory: "Resources/pets/\(path)")
        }
        return frames(fromDirectory: "Resources/\(baseName)")
    }
    
    private static func frames(fromDirectory dir: String) -> [NSImage] {
        Bundle.module
            .paths(forResourcesOfType: "png", inDirectory: dir)
            .sorted()
            .compactMap {
                NSImage(contentsOfFile: $0)
            }
    }
}

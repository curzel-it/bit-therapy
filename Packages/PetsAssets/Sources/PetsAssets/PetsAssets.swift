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
    
    public static func animator(
        baseName: String,
        onFirstFrameLoaded: ((Int) -> Void)? = nil,
        onLoopCompleted: ((Int) -> Void)? = nil
    ) -> ImageAnimator {
        let frames = frames(for: baseName)
        
        return ImageAnimator(
            baseName: baseName,
            frames: frames,
            onFirstFrameLoaded: onFirstFrameLoaded,
            onLoopCompleted: onLoopCompleted
        )
    }
    
    private static func frames(for baseName: String) -> [NSImage] {
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

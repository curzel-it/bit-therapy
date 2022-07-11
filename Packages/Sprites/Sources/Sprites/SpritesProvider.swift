//
// Pet Therapy.
//

import Biosphere
import SwiftUI

open class SpritesProvider: Capability, ObservableObject {
    
    open func frames(for name: String) -> [NSImage] {
        frames(for: name, in: .main)
    }
            
    public func frames(for name: String, in bundle: Bundle) -> [NSImage] {
        var frames: [NSImage] = []
        var frameIndex = 0
        
        while true {
            if let path = bundle.path(forResource: "\(name)-\(frameIndex)", ofType: "png"),
               let image = NSImage(contentsOfFile: path) {
                frames.append(image)
            } else {
                if frameIndex != 0 { break }
            }
            frameIndex += 1
        }
        return frames
    }
}

extension Entity {
    
    public var spritesProvider: SpritesProvider? {
        capability(for: SpritesProvider.self)
    }
}

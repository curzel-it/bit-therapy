//
// Pet Therapy.
//

import Biosphere
import SwiftUI

open class SpritesProvider: Capability, ObservableObject {
    
    open func frames(for name: String) -> [CGImage] {
        frames(for: name, in: .main)
    }
            
    public func frames(for name: String, in bundle: Bundle) -> [CGImage] {
        var frames: [CGImage] = []
        var frameIndex = 0
        
        while true {
            let name = "\(name)-\(frameIndex)"
            
            if let url = bundle.url(forResource: name, withExtension: "png"),
               let image = CGImage.from(contentsOfPng: url) {
                frames.append(image)
            } else {
                if frameIndex == 0 { break }
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

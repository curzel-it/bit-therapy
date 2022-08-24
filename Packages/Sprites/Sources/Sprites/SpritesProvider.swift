//
// Pet Therapy.
//

import Biosphere
import NotAGif
import SwiftUI

open class SpritesProvider: Capability, ObservableObject {
    
    let framesProvider = FramesProvider(format: "%@-%d", fileExtension: .png, in: Bundle.main)
    
    open func frames(for name: String) -> [ImageFrame] {
        framesProvider.frames(baseName: name)
    }
}

extension Entity {
    
    public var spritesProvider: SpritesProvider? {
        capability(for: SpritesProvider.self)
    }
}

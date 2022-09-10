import NotAGif
import SwiftUI
import Yage

open class SpritesProvider: DKCapability, ObservableObject {
    let framesProvider = FramesProvider(format: "%@-%d", fileExtension: .png, in: Bundle.main)
    
    open func frames(for name: String) -> [NSImage] {
        framesProvider.frames(baseName: name)
    }
}

extension Entity {
    public var spritesProvider: SpritesProvider? {
        capability(for: SpritesProvider.self)
    }
}

import NotAGif
import SwiftUI

public typealias ImageFrame = NotAGif.ImageFrame

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

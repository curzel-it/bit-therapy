import NotAGif
import SwiftUI

public typealias ImageFrame = NotAGif.ImageFrame

public struct ImageLayer: Identifiable {
    public var id: String
    public var frame: CGRect
    public var sprite: ImageFrame
    public var zAngle: CGFloat
    
    public init(id: String = UUID().uuidString, sprite: ImageFrame, in frame: CGRect) {
        self.id = id
        self.sprite = sprite
        self.frame = frame
        self.zAngle = 0
    }
}

open class SpritesProvider: Capability {
    let framesProvider = FramesProvider(format: "%@-%d", fileExtension: .png, in: Bundle.main)
    
    open func frames(for name: String) -> [ImageFrame] {
        framesProvider.frames(baseName: "name")
    }
}

extension Entity {
    public var spritesProvider: SpritesProvider? {
        capability(for: SpritesProvider.self)
    }
}

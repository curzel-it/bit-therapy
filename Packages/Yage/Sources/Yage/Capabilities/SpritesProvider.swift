import NotAGif
import SwiftUI

open class SpritesProvider: Capability {
    open func sprite(state: EntityState) -> String {
        fatalError("Extend with your own implementation")
    }

    open func frames(state: EntityState) -> [String] {
        fatalError("Extend with your own implementation")
    }
}

public extension Entity {
    var spritesProvider: SpritesProvider? {
        capability(for: SpritesProvider.self)
    }
}

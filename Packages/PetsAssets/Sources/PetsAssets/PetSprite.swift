//
// Pet Therapy.
//

import AppKit
import Biosphere
import Schwifty
import Squanch

open class PetSpritesProvider: SpritesProvider {
    
    open override func frames(for name: String) -> [NSImage] {
        PetsAssets.frames(for: name)
    }
}

//
// Pet Therapy.
//

import Biosphere
import NotAGif
import Schwifty
import Squanch
import SwiftUI

open class PetSpritesProvider: SpritesProvider {
    
    open override func frames(for name: String) -> [ImageFrame] {
        PetsAssets.frames(for: name)
    }
}

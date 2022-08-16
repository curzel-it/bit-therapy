//
// Pet Therapy.
//

import Biosphere
import Schwifty
import Squanch
import SwiftUI

open class PetSpritesProvider: SpritesProvider {
    
    open override func frames(for name: String) -> [CGImage] {
        PetsAssets.frames(for: name)
    }
}

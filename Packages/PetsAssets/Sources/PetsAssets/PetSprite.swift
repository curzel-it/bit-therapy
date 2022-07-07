//
// Pet Therapy.
//

import AppKit
import Biosphere
import Schwifty
import Squanch

public class PetSprite: AnimatedSprite {
    
    open override func frames(for name: String) -> [NSImage] {
        PetsAssets.frames(for: name)
    }
}

import DesktopKit
import SwiftUI

open class PetSpritesProvider: SpritesProvider {
        
    open override func frames(for name: String) -> [NSImage] {
        PetsAssets.frames(for: name)
    }
}

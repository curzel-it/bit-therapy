import Foundation
import Yage

open class PetSpritesProvider: SpritesProvider {        
    open override func frames(for name: String) -> [ImageFrame] {
        PetsAssets.frames(for: name)
    }
}

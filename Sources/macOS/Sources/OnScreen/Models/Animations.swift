import Combine
import Schwifty
import SwiftUI
import Yage

class PetsSpritesProvider: SpritesProvider {    
    @Inject var assets: PetsAssetsProvider
    
    override func sprite(state: EntityState) -> String {
        guard let species = subject?.species else { return "" }
        switch state {
        case .freeFall: return species.dragPath
        case .drag: return species.dragPath
        case .move: return species.movementPath
        case .action(let action, _): return action.id
        }
    }

    override func frames(state: EntityState) -> [String] {
        guard let species = subject?.species.id else { return [] }
        let path = sprite(state: state)
        return assets.frames(for: species, animation: path)
    }
}

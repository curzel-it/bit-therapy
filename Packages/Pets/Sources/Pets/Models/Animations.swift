import Combine
import PetsAssets
import Schwifty
import SwiftUI
import Yage
import YageLive

class PetsSpritesProvider: SpritesProvider {
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
        return PetsAssetsProvider.shared.frames(for: species, animation: path)
    }
}

class PetAnimationsProvider: AnimationsProvider {
    override func action(whenTouching required: Hotspot) -> EntityAnimation? {
        subject?.species.action(whenTouching: required)
    }

    override func randomAnimation() -> EntityAnimation? {
        subject?.species.randomAnimation()
    }
}

extension EntityAnimation {
    public static let front = EntityAnimation(id: "front")

    static let eat = EntityAnimation(id: "eat")
    static let idle = EntityAnimation(id: "idle")
    static let jump = EntityAnimation(id: "jump")
    static let love = EntityAnimation(id: "love")
    static let side = EntityAnimation(id: "side")
    static let sleep = EntityAnimation(id: "sleep")

    static func lightsaber(size: CGSize) -> EntityAnimation {
        .init(id: "lightsaber", size: size, chance: 0.1)
    }
}

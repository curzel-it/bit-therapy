import Pets
import SwiftUI
import Yage

class GameEnvironment: PetsEnvironment {
    override init(with settings: PetsSettings, bounds: CGRect) {
        super.init(with: settings, bounds: bounds)
        reloadGround()
    }
    
    override func set(bounds: CGRect) {
        super.set(bounds: bounds)
        reloadGround()
    }
    
    private func reloadGround() {
        if let ground = ground() {
            ground.kill()
            state.children.remove(ground)
        }
        state.children.append(buildGround())
    }
    
    func ground() -> Entity? {
        state.children.first { $0.id == kGround }
    }
    
    func buildGround() -> Entity {
        let entity = Entity(
            id: kGround,
            frame: CGRect(
                x: -1000,
                y: state.bounds.maxY - 100,
                width: state.bounds.width + 2000,
                height: 1000
            ),
            in: state.bounds
        )
        entity.isStatic = true
        return entity
    }
}

private let kGround = "ground"

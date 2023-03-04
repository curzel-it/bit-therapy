import Foundation
import Yage

class WorldElementsServiceImpl: WorldElementsService {
    func elements(for world: World) -> [Entity] {
        [ground(for: world)]
    }
    
    private func ground(for world: World) -> Entity {
        GroundEntity(for: world)
    }
}

private class GroundEntity: Entity {
    init(for world: World) {
        super.init(species: .environmentElement, id: "ground", frame: .zero, in: world)
        isStatic = true
        updateFrame()
    }
    
    override func worldBoundsChanged() {
        super.worldBoundsChanged()
        updateFrame()
    }
    
    private func updateFrame() {
        guard let world else { return }
        frame = CGRect(
            x: 0,
            y: world.bounds.height - 100,
            width: world.bounds.width,
            height: 50
        )
    }
}

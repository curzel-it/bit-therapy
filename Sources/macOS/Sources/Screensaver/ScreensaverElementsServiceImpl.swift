import Foundation
import Yage

protocol ScreensaverElementsService: WorldElementsService {
    // ...
}

class ScreensaverElementsServiceImpl: ScreensaverElementsService {
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
            y: groundLevel(for: world.bounds.size),
            width: world.bounds.width,
            height: 50
        )
    }
    
    private func groundLevel(for size: CGSize) -> CGFloat {
        if size.width > size.height { return size.height - 100 }
        if size.height / size.width > 1.7 { return size.height * 0.75 }
        return size.height - 200
    }
}

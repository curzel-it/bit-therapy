import SwiftUI
import Yage

protocol DesktopObstaclesService {
    func start(in world: World)
    func stop()
    func obstacles(from frame: CGRect, borderThickness: CGFloat) -> [CGRect]
}

extension Species {
    static let desktopObstacle = Species(id: "desktopObstacle")
}

extension Entity {
    var isWindowObstacle: Bool { species == .desktopObstacle }
}

extension World {
    func update(withObstacles obstacles: [Entity]) {
        let incomingRects = obstacles.map { $0.frame }
        let existingRects = children
            .filter { $0.isWindowObstacle }
            .map { $0.frame }

        children.removeAll { child in
            guard child.isWindowObstacle else { return false }
            if incomingRects.contains(child.frame) {
                return false
            } else {
                child.kill()
                return true
            }
        }
        obstacles
            .filter { !existingRects.contains($0.frame) }
            .forEach { children.append($0) }
    }
}

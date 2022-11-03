import Combine
import Schwifty
import SwiftUI
import WindowsDetector
import Yage

class DesktopObstaclesService: ObservableObject {
    private let world: LiveWorld
    private let windowsDetector = WindowsDetector().started(pollInterval: 1)
    private var windowsCanc: AnyCancellable!
    
    public init(world: LiveWorld) {
        self.world = world
    }
    
    public func start() {
        windowsCanc = windowsDetector.$userWindows.sink { [weak self] in
            self?.onWindows($0)
        }
    }
    
    func onWindows(_ windowInfos: [WindowInfo]) {
        let windows = windowInfos.map { SomeWindow(from: $0) }
        let obstacles = obstacles(from: windows)
        world.update(withObstacles: obstacles)
    }
    
    func obstacles(from windows: [SomeWindow]) -> [Entity] {
        windows
            .reversed()
            .filter { isValidWindow(owner: $0.owner, frame: $0.frame) }
            .map { $0.frame }
            .reduce([]) { obstacles, rect in
                let visibleObstacles = obstacles.flatMap { $0.parts(bySubtracting: rect) }
                let newObstacles = self.obstacles(fromWindowFrame: rect)
                return visibleObstacles + newObstacles
            }
            .filter { isValidObstacle(frame: $0) }
            .map { WindowObstacle(of: $0, in: world) }
    }
    
    func obstacles(fromWindowFrame frame: CGRect) -> [CGRect] {
        obstacles(from: frame, borderThickness: 10)
    }
    
    func obstacles(from frame: CGRect, borderThickness: CGFloat) -> [CGRect] {
        [CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: borderThickness)]
    }
    
    func isValidWindow(owner: String, frame: CGRect) -> Bool {
        guard !frame.isNull && !frame.isEmpty && !frame.isInfinite else { return false }
        guard frame != NSScreen.main?.frame.bounds else { return false }
        guard !frame.contains(world.state.bounds) else { return false }
        if owner.contains("desktop pets") {
            return frame.width >= 450 && frame.height >= 450
        }
        if owner == "shades" { return false }
        return true
    }
    
    func isValidObstacle(frame: CGRect) -> Bool {
        frame.minY > 100
    }
    
    public func stop() {
        windowsDetector.stop()
        windowsCanc?.cancel()
    }
}

struct SomeWindow: Codable {
    let owner: String
    let frame: CGRect
    
    init(from info: WindowInfo) {
        owner = info.processName?.lowercased() ?? ""
        frame = info.frame
    }
}

class WindowObstacle: Entity {
    init(of frame: CGRect, in world: LiveWorld) {
        super.init(id: WindowObstacle.nextId(), frame: frame, in: world.state.bounds)
        self.isStatic = true
    }
    
    static func nextId() -> String {
        id += 1
        return "window-\(id)"
    }
    
    static var id: Int = 0
}

extension Entity {
    var isWindowObstacle: Bool { self is WindowObstacle }
}

extension LiveWorld {
    func update(withObstacles obstacles: [Entity]) {
        let incomingRects = obstacles.map { $0.frame }
        let existingRects = state.children
            .filter { $0.isWindowObstacle }
            .map { $0.frame }
        
        state.children.removeAll { child in
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
            .forEach { state.children.append($0) }
    }
}

//
// Pet Therapy.
//

import Biosphere
import Combine
import WindowsDetector
import CoreGraphics

open class WindowObstaclesService: ObservableObject {
        
    private let habitat: LiveEnvironment
    private let windowsDetector = WindowsDetector().started(pollInterval: 1)
    private var windowsCanc: AnyCancellable!
    
    public init(habitat: LiveEnvironment) {
        self.habitat = habitat
    }
    
    public func start() {
        self.windowsCanc = windowsDetector.$userWindows.sink { [weak self] in
            self?.onWindows($0)
        }
    }
    
    func onWindows(_ windows: [WindowInfo]) {
        let obstacles = obstacles(from: windows)
        habitat.update(withObstacles: obstacles)
    }
    
    func obstacles(from windows: [WindowInfo]) -> [Entity] {
        windows
            .reversed()
            .filter { isValid(owner: $0.owner, frame: $0.frame) }
            .map { $0.frame }
            .reduce([]) { obstacles, rect in
                let visibleObstacles = obstacles.flatMap { $0.parts(bySubtracting: rect) }
                let newObstacles = self.obstacles(fromWindowFrame: rect)
                return visibleObstacles + newObstacles
            }
            .map { WindowObstacle(of: $0, in: habitat) }
    }
    
    open func obstacles(fromWindowFrame frame: CGRect) -> [CGRect] {
        [frame]
    }
    
    open func isValid(owner: String, frame: CGRect) -> Bool {
        !frame.isNull && !frame.isEmpty && !frame.isInfinite
    }
    
    public func stop() {
        windowsDetector.stop()
        windowsCanc?.cancel()
    }
}

private extension WindowInfo {
    var owner: String { processName?.lowercased() ?? "" }
}

class WindowObstacle: Entity {
    
    init(of frame: CGRect, in habitat: LiveEnvironment) {
        super.init(id: WindowObstacle.nextId(), frame: frame, in: habitat.state.bounds)
        self.backgroundColor = habitat.debug ? .red.opacity(0.5) : .clear
        self.isDrawable = habitat.debug
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

extension LiveEnvironment {
    
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
                child.kill(animated: false)
                return true
            }
        }
        obstacles
            .filter { !existingRects.contains($0.frame) }
            .forEach { state.children.append($0) }
    }
}

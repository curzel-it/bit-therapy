//
// Pet Therapy.
//

import Biosphere
import Combine
import WindowsDetector
import CoreGraphics

class DesktopObstaclesService: ObservableObject {
    
    @Published var obstacles: [Entity] = []
    
    private let habitatBounds: CGRect
    
    private let debug: Bool
    
    private let petSize: CGFloat
    
    private let windowsDetector = WindowsDetector().started(pollInterval: 1)
    
    private var windowsCanc: AnyCancellable!
    
    init(habitatBounds: CGRect, petSize: CGFloat, debug: Bool=true) {
        self.debug = debug
        self.habitatBounds = habitatBounds
        self.petSize = petSize
        windowsCanc = windowsDetector.$userWindows.sink { [weak self] in
            self?.onWindows($0)
        }
    }
    
    private func onWindows(_ windows: [WindowInfo]) {
        obstacles = obstacles(from: windows)
    }
    
    func obstacles(from windows: [WindowInfo]) -> [WindowRoof] {
        windows
            .reversed()
            .filter { isValid(process: $0) }
            .map { $0.frame }
            .reduce([]) { obstacles, rect in
                let newObstacles = obstacles.flatMap { $0.parts(bySubtracting: rect) }
                return newObstacles + rect.obstacles()
            }
            .map { WindowRoof(of: $0, in: habitatBounds, debug: debug) }
    }
    
    func isValid(process window: WindowInfo) -> Bool {
        let name = (window.processName ?? "").lowercased()
        if name.contains("desktop pets") {
            return window.frame.width >= 450 && window.frame.height >= 450
        }
        return true
    }
    
    func stop() {
        windowsDetector.stop()
        windowsCanc?.cancel()
    }
}

extension CGRect {
        
    func obstacles(borderThickness: CGFloat = 20) -> [CGRect] {
        [
            CGRect(x: minX, y: minY, width: width, height: borderThickness)
        ]
    }
}

class WindowRoof: Entity {
    
    init(of frame: CGRect, in habitatBounds: CGRect, debug: Bool) {
        super.init(id: WindowRoof.id(), frame: frame, in: habitatBounds)
        self.backgroundColor = debug ? .red.opacity(0.5) : .clear
        self.isDrawable = debug
        self.isStatic = true
    }
    
    private static func id() -> String {
        incrementalId += 1
        return "window-\(incrementalId)"
    }
    
    private static var incrementalId: Int = 0
}

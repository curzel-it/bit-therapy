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
    
    private let petSize: CGFloat
    
    private let windowsDetector = WindowsDetector().started(pollInterval: 1)
    
    private var windowsCanc: AnyCancellable!
    
    init(habitatBounds: CGRect, petSize: CGFloat) {
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
            .filter { isValid(process: $0.processName) }
            .map { $0.frame }
            .reduce([]) { obstacles, rect in
                let newObstacles = obstacles.flatMap { $0.parts(bySubtracting: rect) }
                return newObstacles + [rect.roofRect()]
            }
            .filter { isValid(frame: $0) }
            .map { WindowRoof(of: $0, in: habitatBounds) }
    }
    
    func isValid(process: String?) -> Bool {
        let name = (process ?? "").lowercased()
        guard !name.contains("desktop pets") else { return false }
        return true
    }
    
    func isValid(frame: CGRect) -> Bool {
        frame.minY > petSize
    }
    
    func stop() {
        windowsDetector.stop()
        windowsCanc?.cancel()
    }
}

extension CGRect {
        
    func roofRect() -> CGRect {
        CGRect(x: minX, y: minY, width: width, height: min(height, 50))
    }
}

class WindowRoof: Entity {
    
    init(of frame: CGRect, in habitatBounds: CGRect) {
        super.init(id: WindowRoof.id(), frame: frame, in: habitatBounds)
        self.isDrawable = false
        self.isStatic = true
    }
    
    private static func id() -> String {
        incrementalId += 1
        return "window-\(incrementalId)"
    }
    
    private static var incrementalId: Int = 0
}

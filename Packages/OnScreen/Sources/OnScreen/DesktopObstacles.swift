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
    
    private let windowsDetector = WindowsDetector().started(pollInterval: 5)
    
    private var windowsCanc: AnyCancellable!
    
    init(habitatBounds: CGRect, petSize: CGFloat) {
        self.habitatBounds = habitatBounds
        self.petSize = petSize
        windowsCanc = windowsDetector.$userWindows.sink { [weak self] in
            self?.onWindows($0)
        }
    }
    
    private func onWindows(_ windows: [WindowInfo]) {
        obstacles = windows
            .filter { !isValidProcess(window: $0) }
            .filter { isValidObstacle(window: $0) }
            .map { WindowRoof(of: $0, in: habitatBounds) }
            .sorted { $0.id < $1.id }
    }
    
    private func isValidObstacle(window: WindowInfo) -> Bool {
        window.frame.minY < petSize
    }
    
    private func isValidProcess(window: WindowInfo) -> Bool {
        window.processName?.contains("Desktop Pets") == false
    }
    
    func stop() {
        windowsDetector.stop()
        windowsCanc?.cancel()
    }
}

class WindowRoof: Entity {
    
    init(of window: WindowInfo, in habitatBounds: CGRect) {
        let roofBounds = CGRect(
            x: window.frame.minX,
            y: window.frame.minY,
            width: window.frame.width,
            height: min(window.frame.height, 100)
        )
        super.init(
            id: "window-\(window.id)",
            frame: roofBounds,
            in: habitatBounds
        )
    }
}

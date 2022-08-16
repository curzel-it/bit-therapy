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
    
    private func onWindows(_ windows: [Window]) {
        obstacles = windows
            .filter { isValidObstacle(window: $0) }
            .map { WindowRoof(of: $0, in: habitatBounds) }
            .sorted { $0.id < $1.id }
    }
    
    func isValidObstacle(window: Window) -> Bool {
        guard window.frame.minY > petSize else { return false }
        let process = window.processName?.lowercased() ?? ""
        guard !process.contains("desktop pets") else { return false }
        guard !process.contains("xcode") else { return false }
        return true
    }
    
    func stop() {
        windowsDetector.stop()
        windowsCanc?.cancel()
    }
}

protocol Window {
    var id: Int { get }
    var frame: CGRect { get }
    var processName: String? { get }
}

extension WindowInfo: Window {
    // ...
}

class WindowRoof: Entity {
    
    init(of window: Window, in habitatBounds: CGRect) {
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
        self.backgroundColor = .red
        self.isDrawable = true
    }
}

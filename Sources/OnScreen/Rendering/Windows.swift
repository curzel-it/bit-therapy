import AppKit
import Combine
import MacWidgets
import Schwifty
import SwiftUI
import Yage

class OnScreenWindows: NSObject, NSWindowDelegate {
    private var widgets = WidgetsCoordinator()
    private var worlds: [World]
    private let tag = "OnScreenWindows"
    private var timer: Timer!
    private var lastUpdate = Date.timeIntervalSinceReferenceDate
    private var disposables = Set<AnyCancellable>()

    init(for worlds: [World]) {
        self.worlds = worlds
        super.init()
        start(fps: 15)
    }
    
    func start(fps: Double) {
        Logger.log(tag, "Starting...")
        timer?.invalidate()
        timer = Timer(timeInterval: 1 / fps, repeats: true) { [weak self] timer in
            guard let self else {
                timer.invalidate()
                return
            }
            self.loop()
        }
        RunLoop.main.add(timer, forMode: .common)
    }

    private func loop() {
        let now = Date.timeIntervalSinceReferenceDate
        let frameTime = now - lastUpdate
        updateWorlds(after: frameTime)
        updateWidgets()
        spawnWidgets()
        lastUpdate = now
    }
    
    private func updateWorlds(after frameTime: TimeInterval) {
        worlds.forEach {
            $0.update(after: frameTime)
        }
    }
    
    private func updateWidgets() {
        widgets.currentWidgets()
            .compactMap { $0 as? EntityWidget }
            .forEach { $0.update() }
    }
    
    private func spawnWidgets() {
        worlds
            .flatMap { $0.children }
            .filter { !$0.isStatic && $0.sprite != nil }
            .sorted { $0.zIndex < $1.zIndex }
            .forEach { spawnWidget(for: $0) }
    }
    
    private func spawnWidget(for child: Entity) {
        let widget = EntityWidget(representing: child)
        widgets.add(widget: widget)
    }

    func kill() {
        disposables.removeAll()
        worlds.removeAll()
        widgets.kill()
        Logger.log(tag, "Terminated.")
    }
}

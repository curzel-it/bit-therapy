import Combine
import Schwifty
import SwiftUI
import Yage

class WorldViewModel {
    let world: World
    var worldBounds: CGRect { world.bounds }
    
    private var lastUpdate = Date.timeIntervalSinceReferenceDate
    private let tag: String
    private var timer: Timer!
    
    init(representing world: World) {
        self.world = world
        tag = "Win-\(world.name)"
    }
    
    func start() {
        start(fps: 20)
    }
    
    func stop() {
        timer?.invalidate()
        world.kill()
        Logger.log(tag, "Terminated.")
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

    func loop() {
        let now = Date.timeIntervalSinceReferenceDate
        let frameTime = now - lastUpdate
        world.update(after: frameTime)
        lastUpdate = now
    }
}

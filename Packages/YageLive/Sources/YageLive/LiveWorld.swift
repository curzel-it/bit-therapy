import Schwifty
import SwiftUI
import Yage

open class LiveWorld: ObservableObject {
    @Published public var children: [Entity] = []

    public var debug = false
    public let fps: Double = 15
    public let state: World
    public var name: String { state.name }
    var events: [ScheduledEvent] = []

    private var timer: Timer!
    private var lastUpdate: TimeInterval

    public init(name: String, bounds: CGRect) {
        lastUpdate = Date.timeIntervalSinceReferenceDate
        state = World(name: name, bounds: bounds)
        start()
    }

    public func start() {
        Logger.log(name, "Starting...")
        timer?.invalidate()
        timer = Timer(timeInterval: 1 / fps, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            self.loop()
            self.children = self.state.children
        }
        RunLoop.main.add(timer, forMode: .common)
    }

    public func pause() {
        Logger.log(name, "Paused...")
        timer?.invalidate()
        timer = nil
    }

    public func loop() {
        let now = Date.timeIntervalSinceReferenceDate
        let frameTime = now - lastUpdate
        state.update(after: frameTime)
        lastUpdate = now
    }

    open func set(bounds: CGRect) {
        state.set(bounds: bounds)
    }

    open func kill() {
        pause()
        state.children.forEach { $0.kill() }
        state.children.removeAll()
        Logger.log(name, "Terminated.")
    }
}

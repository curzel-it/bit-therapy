import Schwifty
import SwiftUI
import Yage

open class LiveWorld: ObservableObject {
    @Published public var children: [Entity] = []
    
    public var debug = false
    public let id: String
    public let fps: Double = 15
    public let state: World
    public let tag: String
    
    private var timer: Timer!
    private var lastUpdate: TimeInterval
    
    public init(id: String, bounds: CGRect) {
        self.id = id
        self.tag = "World-\(id)"
        lastUpdate = Date.timeIntervalSinceReferenceDate
        state = World(bounds: bounds)
        start()
    }
    
    public func start() {
        printDebug(self.tag, "Starting...")
        timer?.invalidate()
        timer = Timer(timeInterval: 1/fps, repeats: true) { [weak self] timer in
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
        printDebug(tag, "Paused...")
        timer?.invalidate()
        timer = nil
    }
    
    public func loop() {
        let now = Date.timeIntervalSinceReferenceDate
        let frameTime = now - lastUpdate
        state.update(after: frameTime)
        lastUpdate = now
    }
    
    public func scheduleAtTimeOfDay(hour: Int, minute: Int, action: @escaping () -> Void) {
        state.schedule(every: .timeOfDay(hour: hour, minute: minute)) { _ in action() }
    }
    
    open func set(bounds: CGRect) {
        state.set(bounds: bounds)
    }
    
    open func kill() {
        pause()
        state.children.forEach { $0.kill() }
        state.children.removeAll()
        printDebug(self.tag, "Terminated.")
    }
}

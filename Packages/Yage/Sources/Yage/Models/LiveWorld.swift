import Schwifty
import SwiftUI

open class LiveWorld: ObservableObject {    
    @Published public var state: World
    
    public var debug = false
    public let id: String
    public let tag: String
    public let fps: Double = 15
    private var timer: Timer!
    private var lastUpdate: TimeInterval
    
    public init(id: String, bounds: CGRect) {
        self.id = id
        self.tag = "World-\(id)"
        lastUpdate = Date.timeIntervalSinceReferenceDate
        state = World(bounds: bounds)
        startRendering()
    }
    
    public func startRendering() {
        printDebug(self.tag, "Starting to render...")
        timer?.invalidate()
        timer = Timer(timeInterval: 1/fps, repeats: true) { [weak self] timer in
            guard timer == self?.timer else { return }
            self?.render()
        }
        RunLoop.main.add(timer, forMode: .common)
    }
    
    public func render() {
        let now = Date.timeIntervalSinceReferenceDate
        let frameTime = now - lastUpdate
        state.update(after: frameTime)
        lastUpdate = now
    }
    
    public func pauseRendering() {
        printDebug(tag, "Paused rendering")
        timer?.invalidate()
        timer = nil
    }
    
    public func scheduleAtTimeOfDay(hour: Int, minute: Int, action: @escaping () -> Void) {
        state.schedule(every: .timeOfDay(hour: hour, minute: minute)) { _ in action() }
    }
    
    open func set(bounds: CGRect) {
        state.set(bounds: bounds)
    }
    
    open func kill() {
        pauseRendering()
        state.children.forEach { $0.kill() }
        state.children.removeAll()
        printDebug(self.tag, "Terminated.")
    }
}

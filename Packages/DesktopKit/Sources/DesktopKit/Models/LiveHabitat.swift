import SwiftUI
import Yage

open class LiveHabitat: ObservableObject {
    
    @Published public var state: HabitatState
        
    public var renderableChildren: [RenderableEntity] {
        state.children.compactMap { $0 as? RenderableEntity }
    }
    
    public var debug = false
    public let id: String
    public let tag: String
    public let fps: Double = 15
    public let logger: Logger? = PrintLogger()
    private var timer: Timer!    
    private var lastUpdate: TimeInterval
    
    public init(id: String, bounds: CGRect) {
        self.id = id
        self.tag = "Habitat-\(id)"
        lastUpdate = Date.timeIntervalSinceReferenceDate
        state = HabitatWithHotspots(bounds: bounds)
        startRendering()
    }
    
    public func startRendering() {
        logger?.log(self.tag, "Starting to render...")
        timer?.invalidate()
        timer = Timer(timeInterval: 1/fps, repeats: true) { [weak self] timer in
            guard timer == self?.timer else { return }
            self?.render()
        }
        RunLoop.main.add(timer, forMode: .common)
    }
    
    public func render() {
        let now = Date.timeIntervalSinceReferenceDate
        state.update(after: now - lastUpdate)
        lastUpdate = now
    }
    
    public func pauseRendering() {
        logger?.log(tag, "Paused rendering")
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
        logger?.log(self.tag, "Terminated.")
    }
}

class PrintLogger: Logger {
    func log(_ component: String, _ items: String?...) {
        let timestamp = Date().string("HH:mm:ss.SSS")
        let body = logString(for: items)
        print("\(timestamp) [\(component)] \(body)")
    }

    func logString(for items: [String?]) -> String {
        items
            .map { $0 ?? "nil" }
            .joined(separator: " ")
    }
}

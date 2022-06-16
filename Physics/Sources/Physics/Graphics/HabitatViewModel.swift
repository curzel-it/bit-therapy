//
// Pet Therapy.
//

import Squanch
import SwiftUI

open class HabitatViewModel: ObservableObject {
        
    @Published public var state: World
    
    public var timer: Timer!
    
    private var lastUpdate: TimeInterval
        
    let fps: Double = 15
    
    public init() {
        lastUpdate = Date.timeIntervalSinceReferenceDate
        let screen = NSScreen.main ?? NSScreen.screens.first
        let screenBounds = CGRect(origin: .zero, size: screen?.frame.size ?? .zero)
        state = World(bounds: screenBounds)
        startRendering()
    }
    
    public func startRendering() {
        printDebug("Habitat", "Starting to render...")
        timer = Timer(timeInterval: 1/fps, repeats: true) { [weak self] _ in
            self?.render()
        }
        RunLoop.main.add(timer, forMode: .common)
    }
    
    public func render() {
        let now = Date.timeIntervalSinceReferenceDate
        self.state.update(after: now - self.lastUpdate)
        self.lastUpdate = now
    }
    
    public func pauseRendering() {
        printDebug("Habitat", "Paused rendering")
        timer?.invalidate()
        timer = nil
    }
    
    open func kill(animated: Bool) {
        if animated {
            state.children
                .enumerated()
                .forEach { index, item in
                    if index == 0 {
                        item.kill(animated: true) { [weak self] in
                            self?.kill(animated: false)
                        }
                    } else {
                        item.kill(animated: true) { }
                    }
                }
            printDebug("Habitat", "Terminating...")
        } else {
            pauseRendering()
            state.children.forEach { $0.kill() }
            state.children.removeAll()
            printDebug("Habitat", "Terminated.")
        }
    }
}

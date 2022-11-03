import Combine
import Schwifty
import SwiftUI

public class ReactToHotspots: Capability {
    private var lastTouched: [Hotspot] = []    
    private var dragCanc: AnyCancellable!
    private var isDragging = false
    
    public override func install(on subject: Entity) {
        super.install(on: subject)
        setResetLastTouchedOnDrag()
    }
    
    // MARK: - Handle Hotspots
    
    private func handle(touched spot: Hotspot) {
        guard let animation = subject?.animationsProvider?.action(whenTouching: spot) else { return }
        printDebug(tag, "Picked", animation.description)
        let newState: EntityState = .action(action: animation, loops: 1)
        subject?.set(state: newState)
    }
    
    private func handle(touched spots: [Hotspot]) {
        spots.forEach { spot in
            printDebug(tag, "Touched", spot.description)
            self.handle(touched: spot)
        }
    }
    
    // MARK: - Handle Hotspots
    
    public override func update(with collisions: Collisions, after time: TimeInterval) {
        guard isEnabled else { return }
        guard case .move = subject?.state else { return }
        let touched = Hotspot.allCases.filter { collisions.contains($0) }
        let newTouched = touched.filter { !lastTouched.contains($0) }
        handle(touched: newTouched)
        lastTouched = touched
    }
    
    // MARK: - Drag
    
    private func setResetLastTouchedOnDrag() {
        dragCanc = subject?.$state.sink { state in
            if case .drag = state {
                self.isDragging = true
            } else {
                if self.isDragging {
                    self.lastTouched = []
                    self.isDragging = false
                }
            }
        }
    }
    
    // MARK: - Uninstall
    
    public override func kill() {
        super.kill()
        dragCanc?.cancel()
        dragCanc = nil
    }
}

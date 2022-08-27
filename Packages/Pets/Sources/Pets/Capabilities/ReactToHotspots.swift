//
// Pet Therapy.
// 

import Combine
import DesktopKit
import Squanch
import SwiftUI

public class ReactToHotspots: Capability {
    
    private let tag: String
        
    var lastTouched: [Hotspot] = []
    
    public required init(with subject: Entity) {
        tag = "Hotspot-\(subject.id)"
        super.init(with: subject)
        setResetLastTouchedOnDrag()
    }
    
    // MARK: - Handle Hotspots
    
    private func handle(touched spot: Hotspot) {
        guard let pet = subject as? PetEntity else { return }
        if let animation = pet.species.action(whenTouching: spot) {
            printDebug(tag, "Picked", animation.description)
            let newState: EntityState = .animation(animation: animation, loops: 1)
            pet.set(state: newState)
        }
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
    
    private var dragCanc: AnyCancellable!
    private var isDragging = false
    
    // MARK: - Uninstall
    
    public override func uninstall() {
        super.uninstall()
        dragCanc?.cancel()
        dragCanc = nil
    }
}

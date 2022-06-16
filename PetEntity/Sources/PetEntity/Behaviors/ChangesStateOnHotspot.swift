//
// Pet Therapy.
// 

import Combine
import Physics
import Squanch
import SwiftUI

public class ChangesStateOnHotspot: EntityBehavior {
    
    var pet: PetEntity? { body as? PetEntity }
    var tag: String { "Hotspot-\(pet?.id ?? "?")" }
        
    var lastTouched: [Hotspot] = []
    
    public required init(with body: PhysicsEntity) {
        super.init(with: body)
        setResetLastTouchedOnDrag()
    }
    
    // MARK: - Handle Hotspots
    
    private func handle(touched spot: Hotspot) {
        guard let pet = pet else { return }
        if let action = pet.species.action(whenTouching: spot) {
            printDebug(tag, "Picked", action.description)
            pet.set(state: .action(action: action))
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
        guard case .move = pet?.petState else { return }
        let touched = Hotspot.allCases.filter { collisions.with($0) }
        let newTouched = touched.filter { !lastTouched.contains($0) }
        handle(touched: newTouched)
        lastTouched = touched
    }
    
    // MARK: - Drag
    
    private func setResetLastTouchedOnDrag() {
        dragCanc = pet?.$petState.sink { state in
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

private extension Collisions {
    
    func with(_ bound: Hotspot) -> Bool {
        contains { $0.bodyId == bound.rawValue }
    }
}

//
// Pet Therapy.
//

import Combine
import Physics
import Squanch
import SwiftUI
import Schwifty

class ResumeMovementAfterAnimations: EntityBehavior {
    
    var pet: PetEntity? { body as? PetEntity }
    var tag: String { "KeepMoving-\(pet?.id ?? "?")" }
    
    let minTimePerAnimation: TimeInterval = 4
    
    private var actionCanc: AnyCancellable!

    required init(with body: PhysicsEntity) {
        super.init(with: body)
        Task { @MainActor in
            setResumeMovementAfterAnimations()
        }
    }
    
    private func setResumeMovementAfterAnimations() {
        actionCanc = pet?.$petState.sink { state in
            guard self.isEnabled else { return }
            guard case .action = state else { return }
            self.keepMovingAfterCurentAnimationCompleted()
        }
    }
    
    private func keepMovingAfterCurentAnimationCompleted() {
        let loopDuracy = pet?.mainSprite.loopDuracy ?? 0
        let loops = ceil(minTimePerAnimation / loopDuracy)
        let delay = loopDuracy * loops
        printDebug(tag, "Killing action in \(delay)")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let self = self else { return }
            guard self.pet?.petState != .move else { return }
            guard self.pet?.petState != .drag else { return }
            printDebug(self.tag, "Resuming movement")
            self.pet?.set(state: .move)
        }
    }
            
    override func uninstall() {
        super.uninstall()
        actionCanc?.cancel()
        actionCanc = nil
    }
}

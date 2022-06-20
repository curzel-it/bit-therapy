//
// Pet Therapy.
//

import Combine
import Biosphere
import Schwifty
import Squanch
import SwiftUI

public class ResumeMovementAfterAnimations: Capability {
    
    var pet: PetEntity? { body as? PetEntity }
    var tag: String { "KeepMoving-\(pet?.id ?? "?")" }
    
    let minTimePerAnimation: TimeInterval = 4
    
    private var stateCanc: AnyCancellable!

    public required init(with body: Entity) {
        super.init(with: body)
        Task { @MainActor in
            setResumeMovementAfterAnimations()
        }
    }
    
    private func setResumeMovementAfterAnimations() {
        stateCanc = pet?.$petState.sink { state in
            guard self.isEnabled else { return }
            guard case .animation = state else { return }
            self.keepMovingAfterCurentAnimationCompleted()
        }
    }
    
    private func keepMovingAfterCurentAnimationCompleted() {
        let loopDuracy = pet?.mainSprite.loopDuracy ?? 0
        let loops = ceil(minTimePerAnimation / loopDuracy)
        let delay = loopDuracy * loops
        printDebug(tag, "Killing animation in \(delay)")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let self = self else { return }
            guard self.pet?.petState != .move else { return }
            guard self.pet?.petState != .drag else { return }
            printDebug(self.tag, "Resuming movement")
            self.pet?.set(state: .move)
        }
    }
            
    public override func uninstall() {
        super.uninstall()
        stateCanc?.cancel()
        stateCanc = nil
    }
}

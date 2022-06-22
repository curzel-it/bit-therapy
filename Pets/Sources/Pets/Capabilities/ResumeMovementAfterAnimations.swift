//
// Pet Therapy.
//

import Combine
import Biosphere
import Schwifty
import Squanch
import SwiftUI

public class ResumeMovementAfterAnimations: Capability {
            
    private var animationCanc: AnyCancellable!

    public required init(with subject: Entity) {
        super.init(with: subject)
        Task { @MainActor in
            animationCanc = subject.animation?.$animation.sink { anim in
                self.onAnimationChanged(to: anim)
            }
        }
    }
    
    private func onAnimationChanged(to animation: ImageAnimator) {
        DispatchQueue.main.asyncAfter(deadline: .now() + animation.loopDuracy) {
            guard case .animation = self.subject?.state else { return }
            self.subject?.set(state: .move)
        }
    }
            
    public override func uninstall() {
        super.uninstall()
        animationCanc?.cancel()
        animationCanc = nil
    }
}

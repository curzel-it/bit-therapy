//
// Pet Therapy.
//

import Foundation
import Schwifty
import Yage

class GetsAngryWhenMeetingOtherCats: Capability {
    override func update(with collisions: Collisions, after time: TimeInterval) {
        guard isEnabled else { return }
        guard subject?.state == .move else { return }
        guard isTouchingAnotherCat(accordingTo: collisions) else { return }
        getAngry()
    }
    
    private func getAngry() {
        guard let subject else { return }
        Logger.log(subject.id, "Getting angry!")
        subject.set(state: .action(action: .angry, loops: 4))
        isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 30) { [weak self] in
            self?.isEnabled = true
        }
    }

    private func isTouchingAnotherCat(accordingTo collisions: Collisions) -> Bool {
        collisions.contains {
            $0.other?.species.id.hasPrefix("cat") == true
        }
    }
}

private extension EntityAnimation {
    static let angry = EntityAnimation(id: "angry")
}

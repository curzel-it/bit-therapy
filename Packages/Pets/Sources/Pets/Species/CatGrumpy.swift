import Foundation
import Yage

extension Species {
    static let catGrumpy = Species.cat
        .with(id: "cat_grumpy")
        .with(animation: .angry.with(loops: 7))
        .with(capability: "GetsAngryWhenMeetingOtherCats")
}

class GetsAngryWhenMeetingOtherCats: Capability {
    override func update(with collisions: Collisions, after time: TimeInterval) {
        guard let subject = subject else { return }
        guard subject.state != .freeFall && subject.state != .drag else { return }
        guard isTouchingAnotherCat(accordingTo: collisions) else { return }
        guard !isAngry() else { return }
        subject.set(state: .action(action: .angry, loops: 5))
    }

    private func isAngry() -> Bool {
        if case .action(let anim, _) = subject?.state {
            return anim.id == "angry"
        }
        return false
    }

    private func isTouchingAnotherCat(accordingTo collisions: Collisions) -> Bool {
        collisions.contains { collision in
            collision.bodyId.contains("cat")
        }
    }
}

private extension EntityAnimation {
    static let angry = EntityAnimation(id: "angry")
}

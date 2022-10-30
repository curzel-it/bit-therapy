import Foundation
import Yage

extension Pet {
    static let catGrumpy = Pet.cat.shiny(id: "cat_grumpy", isPaid: false,
        additionalBehaviors: [
            .init(
                trigger: .random,
                possibleAnimations: [
                    .angry.with(loops: 7)
                ]
            )
        ],
        additionalCapabilities: [
            GetsAngryWhenMeetingOtherCats()
        ]
    )
}

private class GetsAngryWhenMeetingOtherCats: Capability {
    override func update(with collisions: Collisions, after time: TimeInterval) {
        guard let subject = subject else { return }
        guard subject.state != .freeFall && subject.state != .drag else { return }
        guard isTouchingAnotherCat(accordingTo: collisions) else { return }
        guard !isAngry() else { return }
        subject.set(state: .action(action: .angry, loops: 5))
    }
    
    func isAngry() -> Bool {
        if case let .action(anim, _) = subject?.state {
            return anim.id == "angry"
        }
        return false
    }
    
    func isTouchingAnotherCat(accordingTo collisions: Collisions) -> Bool {
        collisions.contains { collision in
            collision.bodyId.contains("cat")
        }
    }
}

private extension EntityAnimation {
    static let angry = EntityAnimation(id: "angry")
}

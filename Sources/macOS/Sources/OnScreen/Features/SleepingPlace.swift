import Foundation
import Yage

class SleepingPlace: Capability {
    override func install(on subject: Entity) {
        super.install(on: subject)
        subject.frame.size = CGSize(
            width: subject.frame.width * 2,
            height: subject.frame.height * 2
        )
    }
    
    override func doUpdate(with collisions: Collisions, after time: TimeInterval) {
        guard self.subject?.state == .move else { return }
        guard let entity = overlappingEntityThatCanSleep(from: collisions) else { return }
        putToSleep(entity)
        isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 120) { [weak self] in
            self?.isEnabled = true
        }
    }
    
    private func putToSleep(_ entity: Entity) {
        guard let bed = subject else { return }
        guard let sleep = entity.sleepAnimation() else { return }
        let loops = sleepLoops(for: entity)
        entity.frame.origin = CGPoint(
            x: bed.frame.center.x - entity.frame.width/2,
            y: bed.frame.maxY - entity.frame.height
        )
        entity.animationsScheduler?.load(sleep, times: loops)
    }
    
    private func overlappingEntityThatCanSleep(from collisions: Collisions) -> Entity? {
        collisions
            .filter { $0.other?.canSleep() ?? false }
            .filter { $0.intersection.area() > 100 }
            .sorted { $0.intersection.area() > $1.intersection.area() }
            .first?.other
    }
    
    private func sleepLoops(for entity: Entity) -> Int {
        entity.sleepAnimation()?.requiredLoops ?? Int.random(in: 25...75)
    }
}

private extension Entity {
    func sleepAnimation() -> EntityAnimation? {
        species.animations.first { $0.id == "sleep" }
    }
    
    func canSleep() -> Bool {
        sleepAnimation() != nil
    }
}

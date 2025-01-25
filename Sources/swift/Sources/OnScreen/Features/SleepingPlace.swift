import Foundation

class SleepingPlace: Capability {
    @Inject private var appConfig: AppConfig
    
    private var blacklistedEntities = Set<String>()
    
    override func install(on subject: Entity) {
        super.install(on: subject)
        subject.frame.size = CGSize(
            width: subject.frame.width * 2,
            height: subject.frame.height * 2
        )
    }

    override func doUpdate(with collisions: Collisions, after time: TimeInterval) {
        guard subject?.state == .move else { return }
        guard let entity = overlappingEntityThatCanSleep(from: collisions) else { return }
        let entityId = entity.id
        putToSleep(entity)
        blacklistedEntities.insert(entityId)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 120) { [weak self] in
            self?.blacklistedEntities.remove(entityId)
            self?.blacklistedEntities.remove(entityId)
            self?.blacklistedEntities.remove(entityId)
            self?.blacklistedEntities.remove(entityId)
        }
    }

    private func putToSleep(_ entity: Entity) {
        guard let bed = subject else { return }
        guard let sleep = entity.sleepAnimation() else { return }
        
        let loops = sleepLoops(for: entity)
        weak var gravity = entity.capability(for: Gravity.self)
        let wasGravityEnabled = gravity?.isEnabled ?? false
        let scale = appConfig.petSize / PetSize.defaultSize
        
        entity.frame.origin = CGPoint(
            x: bed.frame.center.x - entity.frame.width / 2,
            y: bed.frame.maxY - entity.frame.height - (bed.sleepOffsetY * scale)
        )
        gravity?.isEnabled = false
        entity.animationsScheduler?.load(sleep, times: loops)
                
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            gravity?.isEnabled = wasGravityEnabled
        }
    }

    private func overlappingEntityThatCanSleep(from collisions: Collisions) -> Entity? {
        collisions
            .filter { $0.other?.canSleep() ?? false }
            .filter { $0.intersection.area() > 100 }
            .sorted { $0.intersection.area() > $1.intersection.area() }
            .first?.other
    }

    private func sleepLoops(for entity: Entity) -> Int {
        entity.sleepAnimation()?.requiredLoops ?? Int.random(in: 25 ... 75)
    }
}

private extension Entity {
    var sleepOffsetY: CGFloat {
        guard let valueString = species.params["sleepOffsetY"] else { return 0 }
        guard let valueFloat = Float(valueString) else { return 0 }
        return CGFloat(valueFloat)
    }
    
    func sleepAnimation() -> EntityAnimation? {
        species.animations.first { $0.id == "sleep" }
    }

    func canSleep() -> Bool {
        sleepAnimation() != nil
    }
}

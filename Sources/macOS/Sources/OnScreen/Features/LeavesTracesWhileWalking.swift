import Foundation
import Yage

class LeavesTracesWhileWalking: Capability {
    var speciesForTraceEntities: Species!
    var timeBetweenSpawns: TimeInterval = 5
    var traceExpirationTime: TimeInterval = 1
    
    private var traces: [Entity] = []
    private var lastSpawnDate: Date {
        traces.last?.creationDate ?? Date(timeIntervalSince1970: 0)
    }
    
    override func install(on subject: Entity) {
        isEnabled = false
        super.install(on: subject)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.isEnabled = true
        }
    }
    
    override func doUpdate(with collisions: Collisions, after time: TimeInterval) {
        if shouldSpawnTrace() {
            spawnTrace()
        }
        removeExpiredTraces()
    }
    
    override func kill(autoremove: Bool = true) {
        super.kill(autoremove: autoremove)
        traces.forEach { $0.kill() }
        traces.removeAll()
    }
    
    func shouldSpawnTrace() -> Bool {
        guard subject?.state == .move else { return false }
        guard abs(lastSpawnDate.timeIntervalSinceNow) > timeBetweenSpawns else { return false }
        return true
    }
    
    private func spawnTrace() {
        guard let species = speciesForTraceEntities else { return }
        guard let subject, let world = subject.world else { return }
        let entity = Entity(
            species: species,
            id: LeavesTracesWhileWalking.nextTraceId(),
            frame: subject.frame.offset(by: traceOffset()),
            in: world
        )
        entity.isEphemeral = true
        world.children.append(entity)
        traces.append(entity)
    }
    
    func traceOffset() -> CGPoint {
        .zero
    }
    
    private func shouldRemoveTrace() -> Bool {
        lastSpawnDate.timeIntervalSinceNow > traceExpirationTime
    }
    
    private func removeExpiredTraces() {
        traces
            .filter { abs($0.creationDate.timeIntervalSinceNow) > traceExpirationTime }
            .forEach { remove(trace: $0) }
    }
    
    private func remove(trace: Entity) {
        trace.kill()
        traces.remove(trace)
    }
    
    private static func nextTraceId() -> String {
        incrementalId += 1
        return "Trace-\(incrementalId)"
    }
    
    private static var incrementalId = 0
}

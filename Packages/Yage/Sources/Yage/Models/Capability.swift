import SwiftUI

public protocol Capability: AnyObject {
    var subject: Entity? { get set }
    var isEnabled: Bool { get set }
    func install(on subject: Entity)
    func update(with: Collisions, after: TimeInterval)
    func kill()
}

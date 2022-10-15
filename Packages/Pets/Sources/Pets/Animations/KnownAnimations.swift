import Foundation
import Yage

extension EntityAnimation {    
    public static let front = EntityAnimation(id: "front")
    
    static let eat = EntityAnimation(id: "eat")
    static let idle = EntityAnimation(id: "idle")
    static let jump = EntityAnimation(id: "jump")
    static let love = EntityAnimation(id: "love")
    static let sleep = EntityAnimation(id: "sleep")
    
    static func lightsaber(size: CGSize) -> EntityAnimation {
        .init(id: "lightsaber", size: size, chance: 0.1)
    }
}

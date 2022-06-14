// 
// Pet Therapy.
// 

import Foundation
import Physics

extension PetAction {
    
    static let idleFront = PetAction(id: "idle_front")
    
    static let backflip = PetAction(id: "backflip")
    static let eat = PetAction(id: "eat")
    static let fireball = PetAction(id: "fireball")
    static let idle = PetAction(id: "idle")
    static let jump = PetAction(id: "jump")
    static let love = PetAction(id: "love")
    static let meditate = PetAction(id: "meditate")
    static let playGuitar = PetAction(id: "guitar")
    static let roar = PetAction(id: "roar")
    static let selfie = PetAction(id: "selfie")
    static let sendText = PetAction(id: "send_text")
    static let tsundere = PetAction(id: "tsundere")
    
    static func lightsaber(size: CGSize) -> PetAction {
        .init(id: "lightsaber", size: size, chance: 0.1)
    }
}

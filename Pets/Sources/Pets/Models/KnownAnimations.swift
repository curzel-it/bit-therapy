// 
// Pet Therapy.
// 

import Biosphere
import Foundation

extension PetAnimation {
    
    public static let idleFront = PetAnimation(id: "idle_front")
    
    static let backflip = PetAnimation(id: "backflip")
    static let eat = PetAnimation(id: "eat")
    static let fireball = PetAnimation(id: "fireball")
    static let idle = PetAnimation(id: "idle")
    static let jump = PetAnimation(id: "jump")
    static let love = PetAnimation(id: "love")
    static let meditate = PetAnimation(id: "meditate")
    static let playGuitar = PetAnimation(id: "guitar")
    static let roar = PetAnimation(id: "roar")
    static let selfie = PetAnimation(id: "selfie")
    static let sendText = PetAnimation(id: "send_text")
    static let tsundere = PetAnimation(id: "tsundere")
    
    static func lightsaber(size: CGSize) -> PetAnimation {
        .init(id: "lightsaber", size: size, chance: 0.1)
    }
}

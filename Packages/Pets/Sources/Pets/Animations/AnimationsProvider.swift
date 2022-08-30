import Combine
import DesktopKit

class PetAnimationsProvider: AnimationsProvider {
    
    private var pet: PetEntity? { subject as? PetEntity }
    private var species: Pet? { pet?.species }
    
    override func action(whenTouching required: Hotspot) -> EntityAnimation? {
        species?.action(whenTouching: required)
    }
    
    override func randomAnimation() -> EntityAnimation? {
        species?.randomAnimation()
    }
}

//
// Pet Therapy.
//

import DesignSystem
import Physics
import SwiftUI
import Schwifty

class OnScreenViewModel: HabitatViewModel {
    
    var positionBeforeDrag: CGPoint?
    
    var pet: PetEntity!
    
    init(for preferredSpecies: Pet?) {
        let species = preferredSpecies ?? AppState.global.selectedPet ?? .sloth
        super.init()
        pet = PetEntity(species, in: state.bounds)
        pet.set(direction: .init(dx: 1, dy: 0))
        state.children.append(pet)
    }
    
    func onTouchDown() {
        pet.set(state: .drag)
        pet.movement?.isEnabled = false
    }
    
    func onTouchUp() {
        pet.set(state: .move)
        pet.movement?.isEnabled = true
    }
}

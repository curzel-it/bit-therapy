//
// Pet Therapy.
//

import AppKit
import Biosphere
import DesignSystem
import GameState
import LiveEnvironment
import Pets
import Squanch

class ViewModel: LiveEnvironment {
    
    init(bounds: CGRect) {
        super.init(id: "GameMode", bounds: bounds)
        addSelectedPet()
    }
    
    private func addSelectedPet() {
        addPet(for: .sloth)
    }
    
    private func addPet(for species: Pet) {
        let pet = PetEntity(
            of: species,
            size: PetSize.defaultSize,
            in: state.bounds
        )
        pet.set(direction: .init(dx: 1, dy: 0))
        state.children.append(pet)
    }
}

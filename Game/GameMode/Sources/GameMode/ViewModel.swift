//
// Pet Therapy.
//

import AppKit
import Biosphere
import GameState
import Pets
import Squanch

class ViewModel: HabitatViewModel {
    
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
            size: GameState.global.petSize,
            in: state.bounds
        )
        pet.set(origin: state.bounds.center)
        pet.set(direction: .init(dx: 1, dy: 0))
        state.children.append(pet)
    }
}

//
// Pet Therapy.
//

import Biosphere
import DesignSystem
import GameState
import LiveEnvironment
import Pets
import Squanch
import SwiftUI

class ViewModel: LiveEnvironment {
    
    init(bounds: CGRect) {
        printDebug("GameViewModel", "ViewModel init...")
        super.init(id: "GameMode", bounds: bounds)
        addSelectedPet()
    }
    
    private func addSelectedPet() {
        printDebug("GameViewModel", "Adding selected pet")
        addPet(for: .sloth)
    }
    
    private func addPet(for species: Pet) {
        let pet = PetEntity(
            of: species,
            size: PetSize.defaultSize,
            in: state.bounds
        )
        pet.set(
            origin: CGPoint(
                x: state.bounds.minX,
                y: state.bounds.maxY - pet.frame.height
            )
        )
        pet.set(direction: .init(dx: 1, dy: 0))
        state.children.append(pet)
    }
}

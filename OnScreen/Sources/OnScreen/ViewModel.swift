//
// Pet Therapy.
//

import AppKit
import AppState
import Biosphere
import EntityWindow
import Pets
import Squanch

class ViewModel: HabitatViewModel {
    
    init() {
        super.init(
            id: "OnScreen",
            bounds: NSScreen.main?.frame.bounds ?? .zero
        )
        addSelectedPet()
        scheduleEvents()
    }
    
    private func addSelectedPet() {
        let species = Pet.by(id: AppState.global.selectedPet) ?? .sloth
        addPet(for: species)
    }
    
    private func addPet(for species: Pet) {
        let pet = PetEntity(of: species, in: state.bounds)
        pet.install(MouseDraggable.self)
        pet.install(ShowsMenuOnRightClick.self)
        pet.set(direction: .init(dx: 1, dy: 0))
        state.children.append(pet)
    }
}

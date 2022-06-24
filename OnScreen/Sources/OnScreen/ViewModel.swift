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
    
    var windowsManager: WindowsManager?
    
    override init() {
        super.init()
        addSelectedPet()
        scheduleEvents()
    }
    
    private func addSelectedPet() {
        let species = Pet.by(id: AppState.global.selectedPet) ?? .sloth
        addPet(for: species)
    }
    
    private func addPet(for species: Pet) {
        let pet = PetEntity(of: species, in: state.bounds)
        pet.install(MouseDraggablePet.self)
        pet.install(ShowsMenuOnRightClick.self)
        pet.set(direction: .init(dx: 1, dy: 0))
        state.children.append(pet)
    }
    
    override func kill(animated: Bool) {
        super.kill(animated: animated)
        if !animated {
            windowsManager?.viewModel = nil
            windowsManager?.kill()
            windowsManager = nil
        }
    }
}


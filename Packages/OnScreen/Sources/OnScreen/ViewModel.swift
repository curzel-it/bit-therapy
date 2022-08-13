//
// Pet Therapy.
//

import AppKit
import AppState
import Biosphere
import Combine
import EntityWindow
import LiveEnvironment
import Pets
import Sprites
import Squanch

class ViewModel: LiveEnvironment {
    
    var desktopObstacles: DesktopObstaclesService!
    
    private var windowObstaclesCanc: AnyCancellable!
    
    init() {
        super.init(
            id: "OnScreen",
            bounds: NSScreen.main?.frame.bounds ?? .zero
        )
        addSelectedPet()
        scheduleEvents()
        observeWindowsIfNeeded()
    }
    
    private func observeWindowsIfNeeded() {
        guard AppState.global.windowsAreObstacles else { return }
        
        desktopObstacles = DesktopObstaclesService(
            habitatBounds: state.bounds,
            petSize: AppState.global.petSize
        )
        windowObstaclesCanc = desktopObstacles.$obstacles.sink { obstacles in
            self.state.children.removeAll { $0 is WindowRoof }
            self.state.children.append(contentsOf: obstacles)
        }
    }
    
    private func addSelectedPet() {
        let species = Pet.by(id: AppState.global.selectedPet) ?? .sloth
        addPet(for: species)
    }
    
    private func addPet(for species: Pet) {
        let pet = PetEntity(
            of: species,
            size: AppState.global.petSize,
            in: state.bounds
        )
        pet.install(MouseDraggable.self)
        pet.install(ShowsMenuOnRightClick.self)
        pet.set(direction: .init(dx: 1, dy: 0))
        state.children.append(pet)
    }
    
    override func kill(animated: Bool) {
        super.kill(animated: animated)
        desktopObstacles?.stop()
        windowObstaclesCanc?.cancel()
    }
}

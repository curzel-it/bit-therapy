//
// Pet Therapy.
//

import AppKit
import AppState
import Biosphere
import Combine
import EntityWindow

import Pets
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
        guard AppState.global.desktopInteractions else { return }
        desktopObstacles = DesktopObstaclesService(
            habitatBounds: state.bounds,
            petSize: AppState.global.petSize
        )
        windowObstaclesCanc = desktopObstacles.$obstacles.sink { obstacles in
            self.updateObstacles(with: obstacles)
        }
    }
    
    private func updateObstacles(with obstacles: [Entity]) {
        let incomingRects = obstacles.map { $0.frame }
        let existingRects = state.children
            .filter { $0 is WindowRoof }
            .map { $0.frame }
        
        state.children.removeAll { child in
            guard child is WindowRoof else { return false }
            if incomingRects.contains(child.frame) {
                return false
            } else {
                child.kill(animated: false)
                return true
            }
        }
        obstacles
            .filter { !existingRects.contains($0.frame) }
            .forEach { state.children.append($0) }
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

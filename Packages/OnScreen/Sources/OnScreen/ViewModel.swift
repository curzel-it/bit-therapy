import AppKit
import AppState
import Combine
import DesktopKit
import Pets
import Squanch

class ViewModel: LiveHabitat {
    
    var desktopObstacles: DesktopObstaclesService!
    
    init() {
        super.init(id: "OnScreen", bounds: NSScreen.main?.frame.bounds ?? .zero)
        addSelectedPets()
        observeWindowsIfNeeded()
        scheduleUfoAbduction()
    }
    
    private func observeWindowsIfNeeded() {
        guard AppState.global.desktopInteractions else { return }
        desktopObstacles = DesktopObstaclesService(habitat: self)
        desktopObstacles.start()
    }
    
    private func addSelectedPets() {
        let pets: [DesktopPet] = AppState.global.selectedPets.map {
            let species = Pet.by(id: $0) ?? .sloth
            return DesktopPet(of: species, in: state.bounds)
        }
        state.children.append(contentsOf: pets)
    }
    
    override func kill() {
        desktopObstacles?.stop()
        super.kill()
    }
}

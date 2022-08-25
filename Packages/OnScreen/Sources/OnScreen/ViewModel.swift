//
// Pet Therapy.
//

import AppKit
import AppState
import Biosphere
import Combine
import DesktopKit
import Pets
import Squanch

class ViewModel: LiveEnvironment {
    
    var desktopObstacles: DesktopObstaclesService!
    
    init() {
        super.init(id: "OnScreen", bounds: NSScreen.main?.frame.bounds ?? .zero)
        self.debug = false
        addSelectedPet()
        observeWindowsIfNeeded()
        scheduleUfoAbduction()
    }
    
    private func observeWindowsIfNeeded() {
        guard AppState.global.desktopInteractions else { return }
        desktopObstacles = DesktopObstaclesService(habitat: self)
        desktopObstacles.start()
    }
    
    private func addSelectedPet() {
        let species = Pet.by(id: AppState.global.selectedPet) ?? .sloth
        let pet = DesktopPet(of: species, in: state.bounds)
        state.children.append(pet)
    }
    
    override func kill(animated: Bool) {
        super.kill(animated: animated)
        desktopObstacles?.stop()
    }
}

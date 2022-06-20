//
// Pet Therapy.
//

import AppKit
import AppState
import EntityWindow
import PetEntity
import Pets
import Biosphere

class OnScreenViewModel: HabitatViewModel {
    
    fileprivate var windowsManager: WindowsManager?
    
    override init() {
        super.init()
        addSelectedPet()
    }
    
    func spawnWindows() {
        windowsManager = WindowsManager(for: self)
        
        state.children
            .filter { $0.isDrawable }
            .map { window(representing: $0) }
            .forEach { window in
                window.delegate = windowsManager
                window.show()
            }
    }
    
    func addSelectedPet() {
        addPet(for: AppState.global.selectedPet ?? .sloth)
    }
    
    private func addPet(for species: Pet) {
        let pet = PetEntity(species, in: state.bounds)
        
        pet.install(MouseDraggablePet.self)
        pet.install(ShowsMenuOnRightClick.self)
        pet.install(ReactToHotspots.self)
        pet.install(ResumeMovementAfterAnimations.self)
        pet.installAll(pet.species.movementCapabilities())
        
        pet.set(direction: .init(dx: 1, dy: 0))
        state.children.append(pet)
    }
    
    private func window(representing entity: Entity) -> EntityWindow {
        if let pet = entity as? PetEntity {
            return PetWindow(representing: pet, in: self)
        } else {
            return EntityWindow(representing: entity, in: self)
        }
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

private class WindowsManager: NSObject, NSWindowDelegate {
    
    private var windows: [EntityWindow] = []
    
    weak var viewModel: OnScreenViewModel?
    
    init(for viewModel: OnScreenViewModel) {
        self.viewModel = viewModel
    }
    
    func windowWillClose(_ notification: Notification) {
        guard windows.count > 0 else { return }
        guard let windowBeingClosed = notification.object as? EntityWindow else { return }
        windows.removeAll { $0 == windowBeingClosed }
        if windows.count == 0 { kill() }
    }
    
    func kill() {
        windows.forEach { window in
            window.delegate = nil
            if window.isVisible {
                window.close()
            }
        }
        windows = []
        viewModel?.windowsManager = nil
        viewModel?.kill(animated: false)
    }
}

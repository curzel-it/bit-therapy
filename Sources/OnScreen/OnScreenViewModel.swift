//
// Pet Therapy.
//

import AppKit
import AppState
import Biosphere
import EntityWindow
import Pets
import Squanch

class OnScreenViewModel: HabitatViewModel {
    
    fileprivate var windowsManager: WindowsManager?
    
    override init() {
        super.init()
        let selected = Pet.by(id: AppState.global.selectedPet)
        let pet = addPet(for: selected ?? .sloth)
        
        let ufo = self.addPet(for: .ufo)
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            let abduction = ufo.install(Pet.UfoAbduction.self)
            abduction.abduct(pet)
        }
    }
    
    func spawnWindows() {
        windowsManager = WindowsManager(for: self)
        state.children
            .filter { $0.isDrawable }
            .map { window(representing: $0) }
            .forEach { windowsManager?.registerAndShow($0) }
    }
    
    @discardableResult
    private func addPet(for species: Pet) -> PetEntity {
        let pet = PetEntity(of: species, in: state.bounds)
        pet.install(MouseDraggablePet.self)
        pet.install(ShowsMenuOnRightClick.self)
        pet.set(direction: .init(dx: 1, dy: 0))
        state.children.append(pet)
        return pet
    }
    
    private func window(representing entity: Entity) -> EntityWindow {
        if let existingWindow = windowsManager?.existingWindow(representing: entity) {
            return existingWindow
        }
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
    
    func registerAndShow(_ window: EntityWindow) {
        let alreadyPresent = windows.contains { $0.entity.id == window.entity.id }
        guard !alreadyPresent else { return }
        
        windows.append(window)
        window.delegate = self
        window.show()
    }
    
    func existingWindow(representing entity: Entity) -> EntityWindow? {
        windows.first { $0.entity == entity }
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

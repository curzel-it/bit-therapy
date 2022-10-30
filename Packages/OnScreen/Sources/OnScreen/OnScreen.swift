import AppKit
import Combine
import Pets
import Schwifty
import Squanch
import Yage

public struct OnScreen {
    private static var viewModel: ViewModel?
    private static var worldWindows: OnScreenWindows?
    
    public static func show(with settings: OnScreenSettings) {
        hide()
        printDebug("OnScreen", "Starting...")
        self.viewModel = ViewModel(with: settings)
        self.worldWindows = OnScreenWindows(for: viewModel)
    }
    
    public static func hide() {
        printDebug("OnScreen", "Hiding everything...")
        viewModel?.kill()
        viewModel = nil
        worldWindows?.kill()
        worldWindows = nil
    }
    
    public static func triggerUfoAbduction() {
        printDebug("OnScreen", "Triggering UFO Abduction...")
        viewModel?.startUfoAbductionOfRandomVictim()
    }
    
    public static func remove(pet: Pet) {
        viewModel?.remove(pet: pet)
    }
}

class OnScreenWindows: WorldWindows {
    override func windowWillClose(_ notification: Notification) {
        super.windowWillClose(notification)
        if isAlive && windows.count == 0 {
            printDebug("OnScreen", "No more windows, terminating")
            kill()
            OnScreen.hide()
        }
    }
}

class ViewModel: LiveWorld {
    var settings: OnScreenSettings
    var desktopObstacles: DesktopObstaclesService!
    
    init(with settings: OnScreenSettings) {
        self.settings = settings
        super.init(id: "OnScreen", bounds: NSScreen.main?.frame.bounds ?? .zero)
        addSelectedPets()
        observeWindowsIfNeeded()
        scheduleUfoAbduction()
    }
    
    private func observeWindowsIfNeeded() {
        guard settings.desktopInteractions else { return }
        desktopObstacles = DesktopObstaclesService(world: self)
        desktopObstacles.start()
    }
    
    private func addSelectedPets() {
        let pets: [DesktopPet] = settings.selectedPets.map {
            let species = Pet.by(id: $0) ?? .sloth
            return DesktopPet(of: species, in: state.bounds, settings: settings)
        }
        state.children.append(contentsOf: pets)
    }
    
    func remove(pet species: Pet) {
        settings.remove(pet: species)
        let petToRemove = state.children.first { child in
            guard let pet = child as? PetEntity else { return false }
            return pet.species == species
        }
        petToRemove?.kill()
    }
    
    override func kill() {
        desktopObstacles?.stop()
        super.kill()
    }
}

public protocol OnScreenSettings: PetsSettings {
    var desktopInteractions: Bool { get }
    var selectedPets: [String] { get }
    var ufoAbductionSchedule: String { get }
    
    func remove(pet: Pet)
}

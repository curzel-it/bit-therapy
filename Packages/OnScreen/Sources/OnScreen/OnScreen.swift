import AppKit
import AppState
import Combine
import Pets
import Schwifty
import Squanch
import Yage

public struct OnScreen {    
    private static var viewModel: ViewModel?
    private static var worldWindows: OnScreenWindows?
    
    public static func show() {
        hide()
        printDebug("OnScreen", "Starting...")
        self.viewModel = ViewModel()
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
    var desktopObstacles: DesktopObstaclesService!
    
    init() {
        super.init(id: "OnScreen", bounds: NSScreen.main?.frame.bounds ?? .zero)
        addSelectedPets()
        observeWindowsIfNeeded()
        scheduleUfoAbduction()
    }
    
    private func observeWindowsIfNeeded() {
        guard AppState.global.desktopInteractions else { return }
        desktopObstacles = DesktopObstaclesService(world: self)
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

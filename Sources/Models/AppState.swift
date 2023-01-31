import Combine
import DependencyInjectionUtils
import DesignSystem
import SwiftUI
import Yage

class AppState: ObservableObject {
    static let global = AppState()

    @Inject private var storage: AppStateStorage
        
    @Published var desktopInteractions: Bool = true
    @Published var gravityEnabled: Bool = true
    @Published var petSize: CGFloat = 0
    @Published private(set) var selectedSpecies: [Species] = []
    @Published var showInMenuBar: Bool = true
    @Published var speedMultiplier: CGFloat = 1
    @Published var disabledScreens: [String] = []
    
    init() {
        readFromStorage()
        storage.storeValues(of: self)
    }
    
    func isEnabled(screen: NSScreen) -> Bool {
        !disabledScreens.contains(screen.id)
    }
    
    func set(screen: NSScreen, enabled: Bool) {
        if enabled {
            disabledScreens.remove(screen.id)
        } else {
            disabledScreens.append(screen.id)
        }
    }
    
    func add(species: Species) {
        remove(species: species)
        selectedSpecies.append(species)
    }
    
    func remove(species: Species) {
        selectedSpecies.remove(species)
    }

    private func readFromStorage() {
        desktopInteractions = storage.desktopInteractions
        gravityEnabled = storage.gravityEnabled
        petSize = storage.petSize
        selectedSpecies = storage.selectedSpecies
        showInMenuBar = storage.showInMenuBar
        speedMultiplier = storage.speedMultiplier
        disabledScreens = storage.disabledScreens
    }
}


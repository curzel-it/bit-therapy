import Combine
import DesignSystem
import Pets
import SwiftUI
import Yage

// MARK: - App State

class AppState: ObservableObject {
    static let global = AppState()

    let speciesOnStage = CurrentValueSubject<[Species], Never>([])

    lazy var isDevApp: Bool = {
        let bundle = Bundle.main.bundleIdentifier ?? ""
        return bundle.contains(".dev")
    }()

    @Published var desktopInteractions: Bool = true {
        didSet {
            storage.desktopInteractions = desktopInteractions
        }
    }

    @Published var gravityEnabled: Bool = true {
        didSet {
            storage.gravityEnabled = gravityEnabled
        }
    }

    @Published var petSize: CGFloat = 0 {
        didSet {
            storage.petSize = petSize
        }
    }

    @Published var selectedSpecies: [String] = [] {
        didSet {
            storage.selectedSpecies = selectedSpecies
            let species = selectedSpecies.compactMap { Species.by(id: $0) }
            speciesOnStage.send(species)
        }
    }

    @Published var showInMenuBar: Bool = true {
        didSet {
            storage.showInMenuBar = showInMenuBar
        }
    }

    @Published var speedMultiplier: CGFloat = 1 {
        didSet {
            storage.speedMultiplier = speedMultiplier
        }
    }

    @Published var trackingEnabled: Bool = false {
        didSet {
            storage.trackingEnabled = trackingEnabled
        }
    }
    
    @Published var ufoAbductionSchedule: String = "" {
        didSet {
            storage.ufoAbductionSchedule = ufoAbductionSchedule
        }
    }
    
    @Published var disabledScreens: [String] = [] {
        didSet {
            storage.disabledScreens = disabledScreens
        }
    }

    private let storage = Storage()

    init() {
        reload()
    }

    func reload() {
        desktopInteractions = storage.desktopInteractions
        gravityEnabled = storage.gravityEnabled
        petSize = storage.petSize
        selectedSpecies = storage.selectedSpecies
        showInMenuBar = storage.showInMenuBar
        speedMultiplier = storage.speedMultiplier
        trackingEnabled = storage.trackingEnabled
        ufoAbductionSchedule = storage.ufoAbductionSchedule
        disabledScreens = storage.disabledScreens
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
}

private class Storage {
    @AppStorage("desktopInteractions") var desktopInteractions: Bool = true
    @AppStorage("petSize") var petSize: Double = PetSize.defaultSize
    @AppStorage("gravityEnabled") var gravityEnabled = true
    @AppStorage("petId") private var selectedSpeciesValue: String = kInitialPetId
    @AppStorage("showInMenuBar") var showInMenuBar = true
    @AppStorage("speedMultiplier") var speedMultiplier: Double = 1
    @AppStorage("trackingEnabled") var trackingEnabled = false
    @AppStorage("ufoAbductionSchedule") var ufoAbductionSchedule: String = "daily:22:30"
    @AppStorage("disabledScreens") var disabledScreensValue: String = ""
    
    var disabledScreens: [String] {
        get {
            disabledScreensValue
                .components(separatedBy: ",")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }
        }
        set {
            disabledScreensValue = newValue.joined(separator: ",")
        }
    }
    
    var selectedSpecies: [String] {
        get {
            let species = selectedSpeciesValue
                .components(separatedBy: ",")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() }
                .filter { !$0.isEmpty }
            return species.count == 0 ? [kInitialPetId] : species
        }
        set {
            selectedSpeciesValue = newValue.joined(separator: ",")
        }
    }
}

// MARK: - Pets Settings

extension AppState: PetsSettings {
    func remove(species: Species) {
        selectedSpecies = selectedSpecies.filter { $0 != species.id }
    }
}

// MARK: - Constants

private let kInitialPetId = "sloth"

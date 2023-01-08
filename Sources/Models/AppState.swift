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
    
    @Published var creatorMode: Bool = false {
        didSet {
            storage.creatorMode = creatorMode
        }
    }
    
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
    
    @Published var disabledScreens: [String] = [] {
        didSet {
            storage.disabledScreens = disabledScreens
        }
    }

    private let storage = Storage()

    init() {
        creatorMode = true // Enable creator mode for users with 2.20
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
        disabledScreens = storage.disabledScreens
        creatorMode = storage.creatorMode
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
        selectedSpecies.append(species.id)
        let newSpecies = speciesOnStage.value + [species]
        speciesOnStage.send(newSpecies)
    }
    
    func remove(species: Species) {
        selectedSpecies.remove(species.id)
        let newSpecies = speciesOnStage.value.filter { $0 != species }
        speciesOnStage.send(newSpecies)
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
    @AppStorage("creatorMode") var creatorMode = true
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

// MARK: - Constants

private let kInitialPetId = "sloth"

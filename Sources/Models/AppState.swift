import Combine
import DesignSystem
import SwiftUI
import Yage

// MARK: - App State

class AppState: ObservableObject {
    static let global = AppState()

    lazy var isDevApp: Bool = {
        let bundle = Bundle.main.bundleIdentifier ?? ""
        return bundle.contains(".dev")
    }()
    
    @Published var desktopInteractions: Bool = true {
        didSet {
            storage.desktopInteractions = desktopInteractions
        }
    }
    
    @Published var useImageInterpolation: Bool = false {
        didSet {
            storage.useImageInterpolation = useImageInterpolation
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

    @Published private(set) var selectedSpecies: [Species] = [] {
        didSet {
            storage.selectedSpecies = selectedSpecies
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
        useImageInterpolation = storage.useImageInterpolation
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
}

private class Storage {
    @AppStorage("desktopInteractions") var desktopInteractions: Bool = true
    @AppStorage("disabledScreens") var disabledScreensValue: String = ""
    @AppStorage("gravityEnabled") var gravityEnabled = true
    @AppStorage("petSize") var petSize: Double = PetSize.defaultSize
    @AppStorage("petId") private var selectedSpeciesValue: String = kInitialPetId
    @AppStorage("showInMenuBar") var showInMenuBar = true
    @AppStorage("speedMultiplier") var speedMultiplier: Double = 1
    @AppStorage("trackingEnabled") var trackingEnabled = false
    @AppStorage("useImageInterpolation") var useImageInterpolation = false
    
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
    
    var selectedSpecies: [Species] {
        get {
            let storedIds = selectedSpeciesValue
                .components(separatedBy: ",")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() }
            let speciesIds = storedIds.count == 0 ? [kInitialPetId] : storedIds
            return speciesIds.compactMap { Species.by(id: $0) }
        }
        set {
            selectedSpeciesValue = newValue.map { $0.id }.joined(separator: ",")
        }
    }
}

// MARK: - Constants

private let kInitialPetId = "cat"

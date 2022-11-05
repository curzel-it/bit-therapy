import Combine
import DesignSystem
import Pets
import SwiftUI

// MARK: - App State

class AppState: ObservableObject {
    static let global = AppState()
    
    let petsOnStage = CurrentValueSubject<[Pet], Never>([])
    
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
    
    @Published var selectedPets: [String] = [] {
        didSet {
            storage.selectedPets = selectedPets
            let species = selectedPets.compactMap { Pet.by(id: $0) }
            petsOnStage.send(species)
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
    
    private let storage = Storage()
    
    init() {
        reload()
    }
    
    func reload() {
        self.desktopInteractions = storage.desktopInteractions
        self.gravityEnabled = storage.gravityEnabled
        self.petSize = storage.petSize
        self.selectedPets = storage.selectedPets
        self.showInMenuBar = storage.showInMenuBar
        self.speedMultiplier = storage.speedMultiplier
        self.trackingEnabled = storage.trackingEnabled
        self.ufoAbductionSchedule = storage.ufoAbductionSchedule
    }
}

private class Storage {
    @AppStorage("desktopInteractions") var desktopInteractions: Bool = true
    @AppStorage("petSize") var petSize: Double = PetSize.defaultSize
    @AppStorage("gravityEnabled") var gravityEnabled = true
    @AppStorage("petId") private var selectedPetsValue: String = kInitialPetId
    @AppStorage("showInMenuBar") var showInMenuBar = true
    @AppStorage("speedMultiplier") var speedMultiplier: Double = 1
    @AppStorage("trackingEnabled") var trackingEnabled = false
    @AppStorage("ufoAbductionSchedule") var ufoAbductionSchedule: String = "daily:22:30"
    
    var selectedPets: [String] {
        get {
            let pets = selectedPetsValue
                .components(separatedBy: ",")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() }
                .filter { !$0.isEmpty }
            return pets.count == 0 ? [kInitialPetId] : pets
        }
        set {
            selectedPetsValue = newValue.joined(separator: ",")
        }
    }
}

// MARK: - Pets Settings

extension AppState: PetsSettings {
    func remove(pet: Pet) {
        selectedPets = selectedPets.filter { $0 != pet.id }
    }
}

// MARK: - Constants

private let kInitialPetId = "sloth"

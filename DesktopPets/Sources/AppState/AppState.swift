import Combine
import DesignSystem
import OnScreen
import Pets
import SwiftUI

public class AppState: ObservableObject {
    public static let global = AppState()
    
    @Published public var desktopInteractions: Bool = true {
        didSet {
            storage.desktopInteractions = desktopInteractions
        }
    }
    
    @Published public var gravityEnabled: Bool = true {
        didSet {
            storage.gravityEnabled = gravityEnabled
        }
    }
    
    @Published public var petSize: CGFloat = 0 {
        didSet {
            storage.petSize = petSize
        }
    }
    
    @Published public var selectedPets: [String] = [] {
        didSet {
            storage.selectedPets = selectedPets
        }
    }
    
    @Published public var showInMenuBar: Bool = true {
        didSet {
            storage.showInMenuBar = showInMenuBar
        }
    }
    
    @Published public var speedMultiplier: CGFloat = 1 {
        didSet {
            storage.speedMultiplier = speedMultiplier
        }
    }
    
    @Published public var trackingEnabled: Bool = false {
        didSet {
            storage.trackingEnabled = trackingEnabled
        }
    }
    
    @Published public var ufoAbductionSchedule: String = "" {
        didSet {
            storage.ufoAbductionSchedule = ufoAbductionSchedule
        }
    }
    
    private let storage = Storage()
    
    init() {
        reload()
    }
    
    public func reload() {
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

private let kInitialPetId = "sloth"

extension AppState: PetsSettings {}
extension AppState: OnScreenSettings {}

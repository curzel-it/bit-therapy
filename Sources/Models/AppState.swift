import Combine
import DesignSystem
import SwiftUI
import Yage

// MARK: - App State

class AppState: ObservableObject {
    static let global = AppState(storage: AppStateStorageImpl())

    lazy var isDevApp: Bool = {
        let bundle = Bundle.main.bundleIdentifier ?? ""
        return bundle.contains(".dev")
    }()
    
    @Published var desktopInteractions: Bool = true
    @Published var gravityEnabled: Bool = true
    @Published var petSize: CGFloat = 0
    @Published private(set) var selectedSpecies: [Species] = []
    @Published var showInMenuBar: Bool = true
    @Published var speedMultiplier: CGFloat = 1
    @Published var disabledScreens: [String] = []
    
    private let storage: AppStateStorage

    init(storage: AppStateStorage) {
        self.storage = storage
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

// MARK: - Storage Interface

protocol AppStateStorage {
    var desktopInteractions: Bool { get }
    var disabledScreens: [String] { get }
    var gravityEnabled: Bool { get }
    var petSize: Double { get }
    var selectedSpecies: [Species] { get }
    var showInMenuBar: Bool { get }
    var speedMultiplier: Double { get }
    func storeValues(of appState: AppState)
}

// MARK: - Storage Implementation

private class AppStateStorageImpl: AppStateStorage {
    @AppStorage("desktopInteractions") var desktopInteractions: Bool = true
    @AppStorage("disabledScreens") var disabledScreensValue: String = ""
    @AppStorage("gravityEnabled") var gravityEnabled = true
    @AppStorage("petSize") var petSize: Double = PetSize.defaultSize
    @AppStorage("petId") private var selectedSpeciesValue: String = kInitialPetId
    @AppStorage("showInMenuBar") var showInMenuBar = true
    @AppStorage("speedMultiplier") var speedMultiplier: Double = 1
    
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
    
    private var disposables = Set<AnyCancellable>()
        
    func storeValues(of appState: AppState) {
        appState.$desktopInteractions
            .sink { [weak self] in self?.desktopInteractions = $0 }
            .store(in: &disposables)
        
        appState.$gravityEnabled
            .sink { [weak self] in self?.gravityEnabled = $0 }
            .store(in: &disposables)
        
        appState.$petSize
            .sink { [weak self] in self?.petSize = $0 }
            .store(in: &disposables)
        
        appState.$selectedSpecies
            .sink { [weak self] in self?.selectedSpecies = $0 }
            .store(in: &disposables)
        
        appState.$showInMenuBar
            .sink { [weak self] in self?.showInMenuBar = $0 }
            .store(in: &disposables)
        
        appState.$speedMultiplier
            .sink { [weak self] in self?.speedMultiplier = $0 }
            .store(in: &disposables)
        
        appState.$disabledScreens
            .sink { [weak self] in self?.disabledScreens = $0 }
            .store(in: &disposables)
    }
}

// MARK: - Constants

private let kInitialPetId = "cat"

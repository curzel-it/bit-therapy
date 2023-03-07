import Combine
import Foundation
import SwiftUI

protocol AppStateStorage {
    var background: String { get }
    var desktopInteractions: Bool { get }
    var disabledScreens: [String] { get }
    var gravityEnabled: Bool { get }
    var names: [String: String] { get }
    var randomEvents: Bool { get }
    var petSize: Double { get }
    var selectedSpecies: [String] { get }
    var speedMultiplier: Double { get }
    func storeValues(of appState: AppState)
}

class AppStateStorageImpl: AppStateStorage {
    @Inject private var speciesProvider: SpeciesProvider
    
    @AppStorage("backgroundName") var background: String = "BackgroundMountainDynamic"
    @AppStorage("desktopInteractions") var desktopInteractions: Bool = true
    @AppStorage("disabledScreens") var disabledScreensValue: String = ""
    @AppStorage("gravityEnabled") var gravityEnabled = true
    @AppStorage("names") var namesValue: String = ""
    @AppStorage("randomEvents") var randomEvents: Bool = true
    @AppStorage("petSize") var petSize: Double = PetSize.defaultSize
    @AppStorage("petId") private var selectedSpeciesValue: String = kInitialPetId
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
    
    var names: [String: String] {
        get {
            guard let data = namesValue.data(using: .utf8) else { return [:] }
            guard let json = try? JSONSerialization.jsonObject(with: data) else { return [:] }
            return (json as? [String: String]) ?? [:]
        }
        set {
            guard let data = try? JSONSerialization.data(withJSONObject: newValue) else { return }
            guard let string = String(data: data, encoding: .utf8) else { return }
            namesValue = string
        }
    }
    
    var selectedSpecies: [String] {
        get {
            let storedIds = selectedSpeciesValue
                .components(separatedBy: ",")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() }
            return storedIds.count == 0 ? [kInitialPetId] : storedIds
        }
        set {
            selectedSpeciesValue = newValue.joined(separator: ",")
        }
    }
    
    private var disposables = Set<AnyCancellable>()
        
    func storeValues(of appState: AppState) {
        appState.$background
            .sink { [weak self] in self?.background = $0 }
            .store(in: &disposables)
        
        appState.$desktopInteractions
            .sink { [weak self] in self?.desktopInteractions = $0 }
            .store(in: &disposables)
        
        appState.$gravityEnabled
            .sink { [weak self] in self?.gravityEnabled = $0 }
            .store(in: &disposables)
        
        appState.$names
            .sink { [weak self] in self?.names = $0 }
            .store(in: &disposables)
        
        appState.$petSize
            .sink { [weak self] in self?.petSize = $0 }
            .store(in: &disposables)
        
        appState.$selectedSpecies
            .sink { [weak self] in self?.selectedSpecies = $0 }
            .store(in: &disposables)
        
        appState.$speedMultiplier
            .sink { [weak self] in self?.speedMultiplier = $0 }
            .store(in: &disposables)
        
        appState.$disabledScreens
            .sink { [weak self] in self?.disabledScreens = $0 }
            .store(in: &disposables)
        
        appState.$randomEvents
            .sink { [weak self] in self?.randomEvents = $0 }
            .store(in: &disposables)
    }
}

// MARK: - Constants

private let kInitialPetId = "cat"

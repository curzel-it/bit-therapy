import Combine
import Foundation
import SwiftUI

protocol AppConfigStorage {
    var background: String { get }
    var bounceOffPetsEnabled: Bool { get }
    var desktopInteractions: Bool { get }
    var disabledScreens: [String] { get }
    var gravityEnabled: Bool { get }
    var launchSilently: Bool { get }
    var names: [String: String] { get }
    var randomEvents: Bool { get }
    var petSize: Double { get }
    var selectedSpecies: [String] { get }
    var speedMultiplier: Double { get }
    func storeValues(of appConfig: AppConfig)
}

class AppConfigStorageImpl: AppConfigStorage {
    @Inject private var speciesProvider: SpeciesProvider
    
    @AppStorage("backgroundName") var background = "BackgroundMountainDynamic"
    @AppStorage("bounceOffPetsEnabled") var bounceOffPetsEnabled = false
    @AppStorage("desktopInteractions") var desktopInteractions = true
    @AppStorage("disabledScreens") var disabledScreensValue = ""
    @AppStorage("gravityEnabled") var gravityEnabled = true
    @AppStorage("launchSilently") var launchSilently = false
    @AppStorage("names") var namesValue: String = ""
    @AppStorage("randomEvents") var randomEvents = true
    @AppStorage("petSize") var petSize = PetSize.defaultSize
    @AppStorage("petId") private var selectedSpeciesValue = kInitialPetId
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
        
    func storeValues(of appConfig: AppConfig) {
        appConfig.$background
            .sink { [weak self] in self?.background = $0 }
            .store(in: &disposables)
        
        appConfig.$bounceOffPetsEnabled
            .sink { [weak self] in self?.bounceOffPetsEnabled = $0 }
            .store(in: &disposables)
        
        appConfig.$desktopInteractions
            .sink { [weak self] in self?.desktopInteractions = $0 }
            .store(in: &disposables)
        
        appConfig.$gravityEnabled
            .sink { [weak self] in self?.gravityEnabled = $0 }
            .store(in: &disposables)
        
        appConfig.$launchSilently
            .sink { [weak self] in self?.launchSilently = $0 }
            .store(in: &disposables)
        
        appConfig.$names
            .sink { [weak self] in self?.names = $0 }
            .store(in: &disposables)
        
        appConfig.$petSize
            .sink { [weak self] in self?.petSize = $0 }
            .store(in: &disposables)
        
        appConfig.$selectedSpecies
            .sink { [weak self] in self?.selectedSpecies = $0 }
            .store(in: &disposables)
        
        appConfig.$speedMultiplier
            .sink { [weak self] in self?.speedMultiplier = $0 }
            .store(in: &disposables)
        
        appConfig.$disabledScreens
            .sink { [weak self] in self?.disabledScreens = $0 }
            .store(in: &disposables)
        
        appConfig.$randomEvents
            .sink { [weak self] in self?.randomEvents = $0 }
            .store(in: &disposables)
    }
}

// MARK: - Constants

private let kInitialPetId = "cat"

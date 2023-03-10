import Combine
import Foundation
import Schwifty
import Yage

protocol SpeciesProvider {
    func all() -> AnyPublisher<[Species], Never>
    func doesExist(_ speciesId: String) -> Bool
    func by(id: String) -> Species?
    func hasAnyCustomPets() -> Bool
    func jsonDefinition(for speciesId: String) -> URL?
    func register(_ species: Species)
    func unregister(_ species: Species)
    func isOriginal(_ species: Species) -> Bool
}

class SpeciesProviderImpl: SpeciesProvider {
    @Inject private var appConfig: AppConfig
    
    private let speciesSubject = CurrentValueSubject<[Species], Never>([])
    
    init() {
        Task { [weak self] in
            self?.loadSpecies()
        }
    }
    
    func all() -> AnyPublisher<[Species], Never> {
        speciesSubject
            .filter { !$0.isEmpty }
            .eraseToAnyPublisher()
    }
    
    func by(id: String) -> Species? {
        speciesSubject.value.first { $0.id == id }
    }
    
    func doesExist(_ speciesId: String) -> Bool {
        speciesSubject.value.contains { $0.id == speciesId }
    }
    
    func jsonDefinition(for speciesId: String) -> URL? {
        allJsonUrls.first { $0.lastPathComponent == "\(speciesId).json" }
    }
    
    func register(_ species: Species) {
        let newSpecies = speciesSubject.value + [species]
        speciesSubject.send(newSpecies)
    }
    
    func unregister(_ species: Species) {
        appConfig.deselect(species.id)
        let newSpecies = speciesSubject.value.filter { $0 != species }
        speciesSubject.send(newSpecies)
    }
    
    func isOriginal(_ species: Species) -> Bool {
        originalsUrls.contains { $0.lastPathComponent == "\(species.id).json"}
    }
    
    func hasAnyCustomPets() -> Bool {
        !customUrls().isEmpty
    }
    
    lazy var allJsonUrls: [URL] = {
        originalsUrls + customUrls()
    }()
    
    private func loadSpecies() {
        let species = self.allJsonUrls
            .compactMap { try? Data(contentsOf: $0) }
            .compactMap { try? JSONDecoder().decode(Species.self, from: $0) }
            .sorted { $0.id < $1.id }
            .removeDuplicates(keepOrder: true)
        speciesSubject.send(species)
    }
    
    private lazy var originalsUrls: [URL] = {
        Bundle.main.urls(forResourcesWithExtension: "json", subdirectory: "Species") ?? []
    }()
    
    private func customUrls() -> [URL] {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        guard let url else { return [] }
        let urls = try? FileManager.default
            .contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
            .filter { $0.pathExtension == "json" }
        return urls ?? []
    }
}

import Combine
import Foundation
import Schwifty
import Yage

protocol SpeciesProvider {
    var all: CurrentValueSubject<[Species], Never> { get }
    
    func by(id: String) -> Species?
    func jsonDefinition(for speciesId: String) -> URL?
    func register(_ species: Species)
    func unregister(_ species: Species)
    func isOriginal(_ species: Species) -> Bool
}

class SpeciesProviderImpl: SpeciesProvider {
    @Inject private var appConfig: AppConfig
    
    lazy var all: CurrentValueSubject<[Species], Never> = {
        let species = allJsonUrls
            .compactMap { try? Data(contentsOf: $0) }
            .compactMap { try? JSONDecoder().decode(Species.self, from: $0) }
            .sorted { $0.id < $1.id }
            .removeDuplicates(keepOrder: true)
        return CurrentValueSubject<[Species], Never>(species)
    }()
    
    func by(id: String) -> Species? {
        all.value.first { $0.id == id }
    }
    
    func jsonDefinition(for speciesId: String) -> URL? {
        allJsonUrls.first { $0.lastPathComponent == "\(speciesId).json" }
    }
    
    func register(_ species: Species) {
        let newSpecies = all.value + [species]
        all.send(newSpecies)
    }
    
    func unregister(_ species: Species) {
        appConfig.deselect(species.id)
        let newSpecies = all.value.filter { $0 != species }
        all.send(newSpecies)
    }
    
    func isOriginal(_ species: Species) -> Bool {
        originalsUrls.contains { $0.lastPathComponent == "\(species.id).json"}
    }
    
    private lazy var allJsonUrls: [URL] = {
        originalsUrls + customUrls()
    }()
    
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

import Combine
import Foundation
import Schwifty
import Yage

extension Species {
    static var all: CurrentValueSubject<[Species], Never> = {
        let species = allJsonUrls
            .compactMap { try? Data(contentsOf: $0) }
            .compactMap { try? JSONDecoder().decode(Species.self, from: $0) }
            .sorted { $0.id < $1.id }
            .removeDuplicates(keepOrder: true)
        return CurrentValueSubject<[Species], Never>(species)
    }()
    
    static func by(id: String) -> Species? {
        all.value.first { $0.id == id }
    }
    
    static func jsonDefinition(for speciesId: String) -> URL? {
        allJsonUrls.first { $0.lastPathComponent == "\(speciesId).json" }
    }
    
    static func register(_ species: Species) {
        let newSpecies = all.value + [species]
        all.send(newSpecies)
    }
    
    static func unregister(_ species: Species) {
        AppState.global.remove(species: species)
        let newSpecies = all.value.filter { $0 != species }
        all.send(newSpecies)
    }
}

private extension Species {
    static var allJsonUrls: [URL] = {
        originalsUrls() + customUrls()
    }()
    
    static func originalsUrls() -> [URL] {
        Bundle.main.urls(forResourcesWithExtension: "json", subdirectory: "Species") ?? []
    }
    
    static func customUrls() -> [URL] {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        guard let url else { return [] }
        let urls = try? FileManager.default
            .contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
            .filter { $0.pathExtension == "json" }
        return urls ?? []
    }
}

extension Species {
    func isOriginal() -> Bool {
        Species.originalsUrls().contains { $0.lastPathComponent == "\(id).json"}
    }
}

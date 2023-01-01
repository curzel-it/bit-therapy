// 
// Pet Therapy.
// 

import Foundation
import Pets
import Yage

extension Species {
    private static var allJsonUrls: [URL] = {
        Bundle.main.urls(forResourcesWithExtension: "json", subdirectory: "Species") ?? []
    }()
    
    static var all: [Species] = {
        allJsonUrls
            .compactMap { try? Data(contentsOf: $0) }
            .compactMap { try? JSONDecoder().decode(Species.self, from: $0) }
            .sorted { $0.name < $1.name }
    }()
    
    static func by(id: String) -> Species? {
        all.first { $0.id == id }
    }
    
    static func jsonDefinition(for species: Species) -> URL? {
        allJsonUrls.first { $0.absoluteString.contains("\(species.id).json") }
    }
}

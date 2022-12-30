// 
// Pet Therapy.
// 

import Foundation
import Pets
import Yage

extension Species {
    static var all: [Species] = {
        Bundle.main
            .urls(forResourcesWithExtension: "json", subdirectory: "Species")?
            .compactMap { try? Data(contentsOf: $0) }
            .compactMap { try? JSONDecoder().decode(Species.self, from: $0) }
            .sorted { $0.name < $1.name } ?? []
    }()
    
    static func by(id: String) -> Species? {
        all.first { $0.id == id }
    }
}

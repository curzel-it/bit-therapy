import Foundation
import Yage

protocol WorldElementsService {
    func elements(for world: World) -> [Entity]
}

extension Species {
    static let environmentElement = Species(id: "environmentElement")
}

class WorldElementsServiceImpl: WorldElementsService {
    func elements(for world: World) -> [Entity] {
        []
    }
}

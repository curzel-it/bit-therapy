import Combine
import Yage

protocol SpeciesNamesRepository {
    func currentName(for species: Species) -> String
    func name(for species: Species) -> AnyPublisher<String, Never>
}

class SpeciesNamesRepositoryImpl: SpeciesNamesRepository {
    func currentName(for species: Species) -> String {
        AppState.global.names[species.id] ?? species.defaultName
    }
    
    func name(for species: Species) -> AnyPublisher<String, Never> {
        AppState.global.$names
            .map { $0[species.id] ?? species.defaultName }
            .eraseToAnyPublisher()
    }
}

import Combine
import Yage

protocol SpeciesNamesRepository {
    func name(for species: Species) -> AnyPublisher<String, Never>
}

class SpeciesNamesRepositoryImpl: SpeciesNamesRepository {
    func name(for species: Species) -> AnyPublisher<String, Never> {
        AppState.global.$names
            .map { $0[species.id] ?? species.name }
            .eraseToAnyPublisher()
    }
}

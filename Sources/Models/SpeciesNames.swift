import Combine

protocol SpeciesNamesRepository {
    func currentName(forSpecies species: String) -> String
    func name(forSpecies species: String) -> AnyPublisher<String, Never>
}

class SpeciesNamesRepositoryImpl: SpeciesNamesRepository {
    func currentName(forSpecies species: String) -> String {
        AppState.global.names[species] ?? Lang.Species.name(for: species)
    }
    
    func name(forSpecies species: String) -> AnyPublisher<String, Never> {
        AppState.global.$names
            .map { $0[species] ?? Lang.Species.name(for: species) }
            .eraseToAnyPublisher()
    }
    
    private func defaultName(forSpecies species: String) -> String {
        Lang.Species.name(for: species)
    }
}

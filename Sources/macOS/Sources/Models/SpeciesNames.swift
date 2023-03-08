import Combine

protocol SpeciesNamesRepository {
    func currentName(forSpecies species: String) -> String
    func name(forSpecies species: String) -> AnyPublisher<String, Never>
}

class SpeciesNamesRepositoryImpl: SpeciesNamesRepository {
    @Inject private var appState: AppState
    
    func currentName(forSpecies species: String) -> String {
        appState.names[species] ?? Lang.Species.name(for: species)
    }
    
    func name(forSpecies species: String) -> AnyPublisher<String, Never> {
        appState.$names
            .map { $0[species] ?? Lang.Species.name(for: species) }
            .eraseToAnyPublisher()
    }
    
    private func defaultName(forSpecies species: String) -> String {
        Lang.Species.name(for: species)
    }
}

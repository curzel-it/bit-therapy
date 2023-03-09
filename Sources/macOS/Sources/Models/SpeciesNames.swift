import Combine

protocol SpeciesNamesRepository {
    func currentName(forSpecies species: String) -> String
    func name(forSpecies species: String) -> AnyPublisher<String, Never>
}

class SpeciesNamesRepositoryImpl: SpeciesNamesRepository {
    @Inject private var appConfig: AppConfig
    
    func currentName(forSpecies species: String) -> String {
        appConfig.names[species] ?? Lang.Species.name(for: species)
    }
    
    func name(forSpecies species: String) -> AnyPublisher<String, Never> {
        appConfig.$names
            .map { $0[species] ?? Lang.Species.name(for: species) }
            .eraseToAnyPublisher()
    }
    
    private func defaultName(forSpecies species: String) -> String {
        Lang.Species.name(for: species)
    }
}

import Combine
import Foundation
import Schwifty
import Yage

class ScreenEnvironment: World {
    @Inject var rainyCloudUseCase: RainyCloudUseCase
    @Inject var settings: AppConfig
    @Inject var ufoAbductionUseCase: UfoAbductionUseCase
    @Inject private var desktopObstacles: DesktopObstaclesService
    @Inject private var speciesProvider: SpeciesProvider
    @Inject private var worldElements: WorldElementsService
    
    var hasAnyPets: Bool {
        children.contains { $0 is PetEntity }
    }
    
    private var disposables = Set<AnyCancellable>()

    init(for screen: Screen) {
        super.init(name: screen.localizedName, bounds: screen.frame)
        loadAdditionalElements()
        bindPetsOnStage()
        scheduleUfoAbduction()
        scheduleRainyCloud()
        observeWindowsIfNeeded()
    }
    
    func randomPet() -> PetEntity? {
        children
            .compactMap { $0 as? PetEntity }
            .filter { $0.speed != 0 && !$0.isEphemeral }
            .randomElement()
    }
    
    func add(pet species: Species) {
        let entity = PetEntity(of: species, in: self)
        children.append(entity)
    }

    func remove(species speciesToRemove: Species) {
        settings.deselect(speciesToRemove.id)
        children.first { $0.species == speciesToRemove }?.kill()
    }
    
    private func loadAdditionalElements() {
        let elements = worldElements.elements(for: self)
        children.append(contentsOf: elements)
    }
    
    private func observeWindowsIfNeeded() {
        guard settings.desktopInteractions else { return }
        guard name == Screen.main?.localizedName else { return }
        desktopObstacles.start(in: self)
    }

    private func bindPetsOnStage() {
        settings.$selectedSpecies
            .sink { [weak self] in self?.onPetSelectionChanged(to: $0) }
            .store(in: &disposables)
    }
    
    private func onPetSelectionChanged(to newSelectedSpecies: [String]) {
        removeUnselectedPets(given: newSelectedSpecies)
        addNewPets(from: newSelectedSpecies)
    }

    private func removeUnselectedPets(given newPets: [String]) {
        children
            .compactMap { $0 as? PetEntity }
            .filter { !newPets.contains($0.species.id) }
            .forEach {
                $0.kill()
                children.remove($0)
            }
    }

    private func addNewPets(from newSelectedSpecies: [String]) {
        let currentSpecies = children.map { $0.species.id }
        let missingSpecies = Set(newSelectedSpecies).subtracting(Set(currentSpecies))
        
        missingSpecies
            .forEach {
                if let newSpecies = speciesProvider.by(id: $0) {
                    add(pet: newSpecies)
                }
            }
    }

    override func kill() {
        super.kill()
        desktopObstacles.stop()
        disposables.removeAll()
    }
    
    func scheduleRandomly(withinHours range: Range<Int>, action: @escaping () -> Void) {
        let hours = TimeInterval(range.randomElement() ?? 2)
        let minutes = TimeInterval((0..<60).randomElement() ?? 30)
        let delay = hours * 3600 + minutes * 60
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: action)
    }
}

import AppKit
import Combine
import DependencyInjectionUtils
import Foundation
import Yage

class ScreenEnvironment: World {
    @Inject private var speciesProvider: SpeciesProvider
    @Inject var rainyCloudUseCase: RainyCloudUseCase
    @Inject var ufoAbductionUseCase: UfoAbductionUseCase
    
    var hasAnyPets: Bool {
        children.contains { $0 is PetEntity }
    }
    
    private var settings: AppState { AppState.global }
    private var desktopObstacles: DesktopObstaclesService!
    private var disposables = Set<AnyCancellable>()

    init(for screen: NSScreen) {
        super.init(name: screen.localizedName, bounds: screen.frame)
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
        children.append(PetEntity(of: species, in: self))
    }

    func remove(species speciesToRemove: Species) {
        settings.deselect(speciesToRemove.id)
        children
            .first { $0.species == speciesToRemove }?
            .kill()
    }
    
    private func observeWindowsIfNeeded() {
        guard settings.desktopInteractions else { return }
        guard name == NSScreen.main?.localizedName else { return }
        desktopObstacles = DesktopObstaclesService(world: self)
        desktopObstacles.start()
    }
    
    private func installJumpers() {
        guard let desktopObstacles else { return }
        children
            .compactMap { $0 as? PetEntity }
            .forEach { $0.setupJumperIfPossible(with: desktopObstacles) }
    }

    private func bindPetsOnStage() {
        settings.$selectedSpecies
            .sink { [weak self] in self?.onPetSelectionChanged(to: $0) }
            .store(in: &disposables)
    }
    
    private func onPetSelectionChanged(to newPets: [String]) {
        var newChildren: [Entity] = children.filter { !($0 is PetEntity) }
        
        let currentPets = children.compactMap { $0 as? PetEntity }
        for pet in currentPets {
            if newPets.contains(pet.species.id) {
                newChildren.append(pet)
            } else {
                pet.kill()
            }
        }
        
        let currentSpecies = currentPets.map { $0.species }
        let currentSpeciesIds = currentSpecies.map { $0.id }
        for newPet in newPets where !currentSpeciesIds.contains(newPet) {
            if let newSpecies = speciesProvider.by(id: newPet) {
                newChildren.append(PetEntity(of: newSpecies, in: self))
            }
        }
        children = newChildren
    }

    override func kill() {
        super.kill()
        desktopObstacles?.stop()
        disposables.removeAll()
    }
    
    func scheduleRandomly(withinHours range: Range<Int>, action: @escaping () -> Void) {
        let hours = TimeInterval(range.randomElement() ?? 2)
        let minutes = TimeInterval((0..<60).randomElement() ?? 30)
        let delay = hours * 3600 + minutes * 60
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: action)
    }
}

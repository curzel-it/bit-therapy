import AppKit
import Combine
import Foundation
import Yage

class ScreenEnvironment: World {
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
        observeWindowsIfNeeded()
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
        settings.speciesOnStage
            .sink { newPets in
                var newChildren: [Entity] = self.children.filter { !($0 is PetEntity) }
                
                let currentPets = self.children.compactMap { $0 as? PetEntity }
                for pet in currentPets {
                    if newPets.contains(pet.species) {
                        newChildren.append(pet)
                    } else {
                        pet.kill()
                    }
                }
                
                let currentSpecies = currentPets.map { $0.species }
                for newPet in newPets where !currentSpecies.contains(newPet) {
                    newChildren.append(PetEntity(of: newPet, in: self.bounds))
                }
                self.children = newChildren
            }
        .store(in: &disposables)
    }

    func add(pet species: Species) {
        children.append(PetEntity(of: species, in: bounds))
    }

    func remove(species speciesToRemove: Species) {
        settings.remove(species: speciesToRemove)
        children
            .first { $0.species == speciesToRemove }?
            .kill()
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

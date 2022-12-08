import Combine
import Foundation
import Yage
import YageLive

open class PetsEnvironment: LiveWorld {
    var settings: PetsSettings
    private var petsCanc: AnyCancellable!

    public init(with settings: PetsSettings, bounds: CGRect) {
        self.settings = settings
        super.init(id: "main", bounds: bounds)
        bindPetsOnStage()
        scheduleUfoAbduction()
    }

    private func bindPetsOnStage() {
        petsCanc?.cancel()
        petsCanc = settings.speciesOnStage.sink { newPets in
            var newChildren: [Entity] = self.state.children.filter { !($0 is PetEntity) }

            let currentPets = self.state.children.compactMap { $0 as? PetEntity }
            for pet in currentPets {
                if newPets.contains(pet.species) {
                    newChildren.append(pet)
                } else {
                    pet.kill()
                }
            }

            let currentSpecies = currentPets.map { $0.species }
            for newPet in newPets where !currentSpecies.contains(newPet) {
                newChildren.append(self.buildEntity(species: newPet))
            }
            self.state.children = newChildren
        }
    }

    public func add(pet species: Species) {
        state.children.append(buildEntity(species: species))
    }

    open func buildEntity(species: Species) -> PetEntity {
        PetEntity(of: species, in: state.bounds, settings: settings)
    }

    public func remove(species speciesToRemove: Species) {
        settings.remove(species: speciesToRemove)
        state
            .children
            .first { $0.species == speciesToRemove }?
            .kill()
    }

    override open func kill() {
        super.kill()
        petsCanc?.cancel()
        petsCanc = nil
    }
}

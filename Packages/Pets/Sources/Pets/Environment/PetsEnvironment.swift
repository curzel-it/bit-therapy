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
        petsCanc = settings.petsOnStage.sink { newPets in
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
                newChildren.append(self.buildEntity(pet: newPet))
            }
            self.state.children = newChildren
        }
    }
    
    public func add(pet species: Pet) {
        state.children.append(buildEntity(pet: species))
    }
    
    open func buildEntity(pet species: Pet) -> PetEntity {
        PetEntity(of: species, in: state.bounds, settings: settings)
    }
    
    public func remove(pet species: Pet) {
        settings.remove(pet: species)
        let petToRemove = state.children.first { child in
            guard let pet = child as? PetEntity else { return false }
            return pet.species == species
        }
        petToRemove?.kill()
    }
    
    override open func kill() {
        super.kill()
        petsCanc?.cancel()
        petsCanc = nil
    }
}

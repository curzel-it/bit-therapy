import PetDetails
import Pets
import SwiftUI

class PetDetailsCoordinator {
    static func view(
        isShown: Binding<Bool>,
        localizedContent lang: LocalizedContentProvider,
        pet: Pet,
        pets: PetsProvider
    ) -> some View {
        PetDetailsViewCoordinator.view(
            managedBy: DetailsManager(isShown: isShown, pet: pet, pets: pets),
            localizedContent: lang
        )
    }
}

private struct DetailsManager: PetDetailsManager {
    @Binding var isShown: Bool
    let pet: Pet
    let pets: PetsProvider
    var isSelected: Bool { pets.petsOnStage.value.contains(pet) }
    
    func close() {
        isShown = false
    }
    
    func didSelect() {
        pets.add(pet: pet)
        pets.petsOnStage.send(pets.petsOnStage.value + [pet])
    }
    
    func didRemove() {
        pets.remove(pet: pet)
        pets.petsOnStage.send(pets.petsOnStage.value.filter { $0 != pet })
    }
}

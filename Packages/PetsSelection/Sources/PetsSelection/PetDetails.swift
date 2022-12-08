import PetDetails
import Pets
import SwiftUI
import Yage

class PetDetailsCoordinator {
    static func view(
        isShown: Binding<Bool>,
        localizedContent lang: LocalizedContentProvider,
        species: Species,
        speciesProvider: PetsProvider
    ) -> some View {
        PetDetailsViewCoordinator.view(
            managedBy: DetailsManager(isShown: isShown, species: species, speciesProvider: speciesProvider),
            localizedContent: lang
        )
    }
}

private struct DetailsManager: PetDetailsManager {
    @Binding var isShown: Bool
    let species: Species
    let speciesProvider: PetsProvider
    var isSelected: Bool { speciesProvider.speciesOnStage.value.contains(species) }

    func close() {
        isShown = false
    }

    func didSelect() {
        speciesProvider.add(species: species)
        speciesProvider.speciesOnStage.send(speciesProvider.speciesOnStage.value + [species])
    }

    func didRemove() {
        speciesProvider.remove(species: species)
        speciesProvider.speciesOnStage.send(speciesProvider.speciesOnStage.value.filter { $0 != species })
    }
}

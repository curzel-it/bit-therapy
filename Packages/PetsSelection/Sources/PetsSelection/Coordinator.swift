import Combine
import PetDetails
import Pets
import SwiftUI
import Yage

public class PetsSelectionCoordinator {
    public static func view(
        localizedContent lang: LocalizedContentProvider,
        speciesProvider: PetsProvider,
        footer: AnyView
    ) -> some View {
        let vm = PetsSelectionViewModel(localizedContent: lang, speciesProvider: speciesProvider)
        return PetsSelectionView(viewModel: vm, footer: footer)
    }
}

public protocol PetsProvider {
    var speciesOnStage: CurrentValueSubject<[Species], Never> { get }
    func add(species: Species)
    func remove(species: Species)
}

public protocol LocalizedContentProvider: PetDetails.LocalizedContentProvider {
    var morePets: String { get }
    var title: String { get }
    var yourPets: String { get }
}

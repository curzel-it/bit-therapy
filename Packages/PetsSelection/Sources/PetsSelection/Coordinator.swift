import Combine
import PetDetails
import Pets
import SwiftUI

public class PetsSelectionCoordinator {
    public static func view(
        localizedContent lang: LocalizedContentProvider,
        pets: PetsProvider,
        footer: AnyView
    ) -> some View {
        let vm = PetsSelectionViewModel(localizedContent: lang, pets: pets)
        return PetsSelectionView(viewModel: vm, footer: footer)
    }
}

public protocol PetsProvider {
    var petsOnStage: CurrentValueSubject<[Pet], Never> { get }
}

public protocol LocalizedContentProvider: PetDetails.LocalizedContentProvider {
    var morePets: String { get }
    var title: String { get }
    var yourPets: String { get }
}

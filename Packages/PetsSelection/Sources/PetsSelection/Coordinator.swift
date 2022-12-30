import Combine
import Pets
import SwiftUI
import Yage

public class PetsSelectionCoordinator {
    public static func view(
        localizedContent: LocalizedContentProvider,
        speciesProvider: PetsProvider,
        assetsProvider: AssetsProvider
    ) -> some View {
        let vm = PetsSelectionViewModel(
            localizedContent: localizedContent,
            speciesProvider: speciesProvider,
            assetsProvider: assetsProvider
        )
        return PetsSelectionView(viewModel: vm)
    }
}

public protocol PetsProvider {
    var speciesOnStage: CurrentValueSubject<[Species], Never> { get }
    func add(species: Species)
    func remove(species: Species)
}

public protocol LocalizedContentProvider {
    var addPet: String { get }
    var cancel: String { get }
    var loading: String { get }
    var morePets: String { get }
    var remove: String { get }
    var screen: String { get }
    var somethingWentWrong: String { get }
    var title: String { get }
    var yourPets: String { get }

    func description(of species: Species) -> String
    func name(of species: Species) -> String
}

public protocol AssetsProvider: AnyObject {
    func frames(for species: String, animation: String) -> [String]
    func image(sprite: String?) -> NSImage?
}

import Foundation
import Schwifty
import SwiftUI
import Swinject
import Yage

protocol DeletePetButtonCoordinator {
    func view(for species: Species, completion: @escaping (Bool) -> Void) -> AnyView
}

class DeletePetButtonCoordinatorImpl: DeletePetButtonCoordinator {
    func view(for species: Species, completion: @escaping (Bool) -> Void) -> AnyView {
        let vm = DeletePetButtonViewModel(species: species, completion: completion)
        return AnyView(DeletePetButton(viewModel: vm))
    }
}

private struct DeletePetButton: View {
    @EnvironmentObject var appConfig: AppConfig
    @StateObject var viewModel: DeletePetButtonViewModel    
    
    var body: some View {
        if viewModel.isEnabled {
            IconButton(systemName: "trash", action: viewModel.delete)
        }
    }
}

private class DeletePetButtonViewModel: ObservableObject {
    @Inject private var speciesProvider: SpeciesProvider
    @Inject private var deletePetUseCase: DeletePetUseCase
    @Inject private var assets: PetsAssetsProvider
    
    var isEnabled: Bool {
        !speciesProvider.isOriginal(species)
    }
    
    private let species: Species
    private let completion: (Bool) -> Void
    
    init(species: Species, completion: @escaping (Bool) -> Void) {
        self.species = species
        self.completion = completion
    }
    
    func delete() {
        let deleted = deletePetUseCase.safelyDelete(item: species)
        if deleted {
            assets.reloadAssets()
            speciesProvider.unregister(species)
        }
        completion(deleted)
    }
}

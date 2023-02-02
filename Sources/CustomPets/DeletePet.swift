import DependencyInjectionUtils
import Foundation
import Schwifty
import SwiftUI
import Yage

protocol DeletePetCoordinator {
    func view(for species: Species, completion: @escaping (Bool) -> Void) -> AnyView
}

class DeletePetButtonCoordinator: DeletePetCoordinator {
    func view(for species: Species, completion: @escaping (Bool) -> Void) -> AnyView {
        let vm = DeletePetButtonViewModel(species: species, completion: completion)
        return AnyView(
            DeletePetButton(viewModel: vm)
        )
    }
}

private struct DeletePetButton: View {
    @EnvironmentObject var appState: AppState
    @StateObject var viewModel: DeletePetButtonViewModel    
    
    var body: some View {
        if viewModel.isEnabled {
            Button(Lang.delete, action: viewModel.delete)
                .buttonStyle(.text)
                .scaleEffect(0.8)
        }
    }
}

private class DeletePetButtonViewModel: ObservableObject {
    var isEnabled: Bool {
        deletePetUseCase.canDelete(species)
    }
    
    private let species: Species
    private let completion: (Bool) -> Void
    private let deletePetUseCase = DeletePetUseCase()
    
    init(species: Species, completion: @escaping (Bool) -> Void) {
        self.species = species
        self.completion = completion
    }
    
    func delete() {
        let deleted = deletePetUseCase.safeDelete(species)
        completion(deleted)
    }
}

private class DeletePetUseCase {
    @Inject var assets: PetsAssetsProvider
    let tag = "DeletePetUseCase"
    
    func canDelete(_ species: Species) -> Bool {
        !species.isOriginal()
    }
    
    func safeDelete(_ species: Species) -> Bool {
        do {
            try delete(species)
            assets.reloadAssets()
            Species.unregister(species)
            return true
        } catch let error {
            Logger.log(tag, "Could not delete: \(error)")
            return false
        }
    }
    
    private func delete(_ species: Species) throws {
        Logger.log(tag, "Deleting \(species.id)")
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            Logger.log(tag, "Could not find documents folder")
            return
        }
        try FileManager.default
            .contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
            .filter { $0.lastPathComponent.hasPrefix(species.id) }
            .filter { does(url: $0, referTo: species) }
            .forEach {
                Logger.log(tag, "Deleting '\($0)'...")
                try FileManager.default.removeItem(at: $0)
            }
        Logger.log(tag, "Done!")
    }
    
    private func does(url: URL, referTo species: Species) -> Bool {
        let fileName = url.lastPathComponent
        let fileExtension = fileName.components(separatedBy: ".").last ?? ""
        let delimiter = fileExtension == "png" ? "_" : "."
        return fileName.starts(with: "\(species.id)\(delimiter)")
    }
}

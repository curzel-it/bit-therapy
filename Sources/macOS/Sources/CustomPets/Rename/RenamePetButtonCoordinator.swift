import Foundation
import Schwifty
import Swinject
import SwiftUI
import Yage

protocol RenamePetButtonCoordinator {
    func view(for species: Species) -> AnyView
}

class RenamePetButtonCoordinatorImpl: RenamePetButtonCoordinator {
    func view(for species: Species) -> AnyView {
        guard DeviceRequirement.macOS.isSatisfied else {
            return AnyView(EmptyView())
        }
        let vm = RenamePetButtonViewModel(speciesId: species.id)
        return AnyView(
            RenamePetButton(viewModel: vm)
        )
    }
}

private struct RenamePetButton: View {
    @EnvironmentObject var appConfig: AppConfig
    @StateObject var viewModel: RenamePetButtonViewModel
    
    var body: some View {
        IconButton(systemName: viewModel.icon, action: viewModel.startRenaming)
            .sheet(isPresented: $viewModel.isRenaming) {
                VStack(alignment: .center, spacing: .xl) {
                    Text(Lang.CustomPets.setNameTitle)
                        .font(.largeTitle)
                        .padding(.top)
                    Text(Lang.CustomPets.setNameMessage)
                        .font(.body)
                        .multilineTextAlignment(.center)
                    
                    TextField("", text: $viewModel.name)
                    
                    HStack {
                        Button(Lang.cancel, action: viewModel.cancel)
                            .buttonStyle(.text)
                        Button(Lang.done, action: viewModel.confirm)
                            .buttonStyle(.regular)
                    }
                }
                .padding()
                .frame(width: 450)
            }
    }
}

private class RenamePetButtonViewModel: ObservableObject {
    @Inject private var appConfig: AppConfig
    @Inject private var assets: PetsAssetsProvider
    @Inject private var names: SpeciesNamesRepository
    
    @Published var isRenaming = false
    @Published var name: String = ""
    
    let icon = "character.cursor.ibeam"
    private let speciesId: String
    
    init(speciesId: String) {
        self.speciesId = speciesId
        self.name = names.currentName(forSpecies: speciesId)
    }
    
    func cancel() {
        isRenaming = false
        name = names.currentName(forSpecies: speciesId)
    }
    
    func startRenaming() {
        isRenaming = true
    }
    
    func confirm() {
        appConfig.rename(species: speciesId, to: name)
        cancel()
    }
}

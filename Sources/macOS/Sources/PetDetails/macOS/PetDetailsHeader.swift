import SwiftUI

class PetDetailsHeaderBuilderImpl: PetDetailsHeaderBuilder {
    func build(with viewModel: PetDetailsViewModel) -> AnyView {
        AnyView(Header().environmentObject(viewModel))
    }
}

private struct Header: View {
    @EnvironmentObject var viewModel: PetDetailsViewModel
    @Inject private var deletePet: DeletePetButtonCoordinator
    @Inject private var exportPet: ExportPetButtonCoordinator
    
    var body: some View {
        HStack(spacing: .xl) {
            Text(viewModel.title)
                .font(.largeTitle.bold())
                .multilineTextAlignment(.leading)
            Spacer()
            
            viewModel.renameButton()
            
            deletePet.view(for: viewModel.species) { deleted in
                if deleted {
                    viewModel.close()
                }
            }
            exportPet.view(for: viewModel.species)
        }
    }
}

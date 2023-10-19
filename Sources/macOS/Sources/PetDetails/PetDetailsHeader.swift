import Schwifty
import SwiftUI

struct PetDetailsHeader: View {
    @EnvironmentObject var viewModel: PetDetailsViewModel
    @Inject private var deletePet: DeletePetButtonCoordinator
    @Inject private var exportPet: ExportPetButtonCoordinator
    @Inject private var renamePet: RenamePetButtonCoordinator
        
    var body: some View {
        HStack(spacing: .xl) {
            Text(viewModel.title)
                .font(.boldTitle)
                .multilineTextAlignment(.leading)
            
            if DeviceRequirement.macOS.isSatisfied {
                Spacer()
                renamePet.view(for: viewModel.species)
                deletePet.view(for: viewModel.species) { deleted in
                    if deleted {
                        viewModel.close()
                    }
                }
                exportPet.view(for: viewModel.species)
            }
        }
    }
}

import DesignSystem
import InAppPurchases
import Schwifty
import SwiftUI

struct PetsSelectionView: View {
    @StateObject var viewModel: PetsSelectionViewModel
    let footer: AnyView

    var body: some View {
        ScrollView {
            VStack(spacing: .xxl) {
                if DeviceRequirement.iOS.isSatisfied {
                    Text(viewModel.localizedContent.title).title()
                }
                PetsGrid(
                    title: viewModel.localizedContent.yourPets,
                    columns: viewModel.gridColums,
                    species: viewModel.speciesOnStage
                )
                PetsGrid(
                    title: viewModel.localizedContent.morePets,
                    columns: viewModel.gridColums,
                    species: viewModel.unselectedSpecies
                )
                footer
            }
            .padding(.md)
        }
        .sheet(isPresented: viewModel.showingDetails) {
            viewModel.petDetailsView()
        }
        .environmentObject(viewModel)
        .environmentObject(PricingService.global)
    }
}

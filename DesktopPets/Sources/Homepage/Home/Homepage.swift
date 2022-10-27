import DesignSystem
import InAppPurchases
import SwiftUI

struct Homepage: View {
    
    @EnvironmentObject var appState: AppState
    
    @StateObject var viewModel = HomepageViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: .xxl) {
                PetsGrid(
                    title: Lang.PetSelection.yourPets,
                    columns: viewModel.gridColums,
                    pets: viewModel.selectedPets
                )
                PetsGrid(
                    title: Lang.PetSelection.morePets,
                    columns: viewModel.gridColums,
                    pets: viewModel.unselectedPets
                )
                RequestPetsViaSurvey()
            }
            .padding(.md)
        }
        .sheet(isPresented: viewModel.showingDetails) {
            if let pet = viewModel.selectedPet {
                PetDetails(isShown: viewModel.showingDetails, pet: pet)
            }
        }
        .environmentObject(viewModel)
        .environmentObject(PricingService.global)
    }
}

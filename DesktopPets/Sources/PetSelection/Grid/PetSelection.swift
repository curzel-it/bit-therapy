import AppState
import DesignSystem
import InAppPurchases
import SwiftUI

struct PetSelectionView: View {
    
    @EnvironmentObject var appState: AppState
    
    @StateObject var viewModel = PetSelectionViewModel()
    
    var body: some View {
        ZStack {
            ScrollView {
                PetSelectionGrid()
                    .padding(.leading, .md)
                    .padding(.top, .md)
                    .padding(.bottom, 200)
            }
        }
        .environmentObject(viewModel)
        .environmentObject(PricingService.global)
    }
}

//
// Pet Therapy.
//

import AppState
import Combine
import DesignSystem
import Schwifty
import Squanch
import SwiftUI

struct PetSelectionGrid: View {
    
    @EnvironmentObject var appState: AppState    
    @EnvironmentObject var viewModel: PetSelectionViewModel
    
    var columns: [GridItem] {
        let item = GridItem(
            .adaptive(minimum: 100, maximum: 200),
            spacing: Spacing.lg.rawValue
        )
        return [GridItem](repeating: item, count: 5)
    }
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: Spacing.xl.rawValue) {
            ForEach(viewModel.pets) {
                PetGridItem(pet: $0)
            }
        }
        .padding(.lg)
        .sheet(isPresented: viewModel.showingDetails) {
            if let pet = viewModel.selectedPet {
                PetDetails(isShown: viewModel.showingDetails, pet: pet)
            }
        }
    }
}

//
// Pet Therapy.
//

import Combine
import DesignSystem
import Physics
import Squanch
import SwiftUI
import Schwifty

struct PetSelectionGrid: View {
    
    @EnvironmentObject var appState: AppState
    
    @EnvironmentObject var viewModel: PetSelectionViewModel
    
    var columns: [GridItem] {
        [GridItem](
            repeating: .init(
                .fixed(viewModel.petSize),
                spacing: Spacing.lg.rawValue
            ),
            count: 5
        )
    }
    
    var body: some View {
        LazyVGrid(
            columns: columns,
            spacing: Spacing.xl.rawValue
        ) {
            ForEach(viewModel.state.children) { child in
                if let pet = child as? SelectablePet {
                    PetGridItem(pet: pet)
                }
            }
        }
        .sheet(isPresented: viewModel.showingDetails) {
            if let pet = viewModel.selectedPet {
                PetDetails(isShown: viewModel.showingDetails, child: pet)
            }
        }
    }
}

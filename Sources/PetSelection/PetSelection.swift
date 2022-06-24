//
// Pet Therapy.
//

import Biosphere
import DesignSystem
import InAppPurchases
import Lang
import OnScreen
import Schwifty
import SwiftUI

struct PetSelection: View {
        
    @StateObject var viewModel = PetSelectionViewModel()
    
    var body: some View {
        ZStack {
            ScrollView {
                PetSelectionGrid()
                    .padding(.leading, .md)
                    .padding(.top, .md)
                    .padding(.bottom, 200)
            }
            Button(Lang.PetSelection.showPet) { OnScreen.show() }
                .buttonStyle(.regular)
                .positioned(.trailingBottom)
                .padding(.lg)
        }
        .environmentObject(viewModel)
        .environmentObject(viewModel as HabitatViewModel)
        .environmentObject(PricingService.global)
        .onWindow { window in
            MainWindowDelegate.setup(for: window, with: viewModel)
            window.styleMask.remove(.miniaturizable)
        }
    }
}

//
// Pet Therapy.
//

import DesignSystem
import InAppPurchases
import Lang
import Physics
import Schwifty
import SwiftUI

struct PetSelection: View {
        
    @StateObject var viewModel = PetSelectionViewModel()
    
    var body: some View {
        VStack {
            ScrollView {
                PetSelectionGrid()
            }
            Footer()
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

private struct Footer: View {
    
    var body: some View {
        HStack {
            Spacer()
            Button(Lang.PetSelection.showPet) { OnScreen.show() }
                .buttonStyle(.regular)
        }
        .frame(height: DesignSystem.buttonsHeight)
    }
}

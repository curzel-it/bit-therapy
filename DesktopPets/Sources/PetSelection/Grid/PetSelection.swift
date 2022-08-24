//
// Pet Therapy.
//

import AppState
import Biosphere
import DesignSystem
import InAppPurchases
import Lang
import OnScreen
import Schwifty
import SwiftUI

public struct PetSelectionView: View {
    
    @EnvironmentObject var appState: AppState
    
    @StateObject var viewModel = PetSelectionViewModel()
    
    public init() {
        // ...
    }
    
    public var body: some View {
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
        .environmentObject(PricingService.global)
    }
}

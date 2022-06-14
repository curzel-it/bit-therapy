//
// Pet Therapy.
//

import DesignSystem
import Physics
import SwiftUI
import Schwifty

struct PetSelection: View {
    
    @EnvironmentObject var appState: AppState
    
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
            TrackingMessage()
            Spacer()
            Button(Lang.PetSelection.showPet) { OnScreenWindow.show() }
                .buttonStyle(.regular)
        }
        .frame(height: DesignSystem.buttonsHeight)
    }
}

private struct TrackingMessage: View {
        
    var body: some View {
        Text(Lang.PetSelection.trackingAlert)
            .opacity(0.7)
            .font(.regular, .sm)
            .multilineTextAlignment(.leading)
    }
}

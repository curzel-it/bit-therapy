//
// Pet Therapy.
//

import DesignSystem
import Physics
import SwiftUI
import Schwifty

struct OnScreenView: View {
        
    @StateObject var viewModel: OnScreenViewModel
    
    var body: some View {
        EntityView(child: viewModel.pet)
            .font(.bold, .sm)
            .environmentObject(viewModel as HabitatViewModel)
            .environmentObject(viewModel)
            .environmentObject(AppState.global)
    }
}

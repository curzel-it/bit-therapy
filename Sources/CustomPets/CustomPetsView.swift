// 
// Pet Therapy.
// 

import Foundation
import SwiftUI

struct CustomPetsView: View {
    @StateObject var viewModel: CustomPetsViewModel
    
    init() {
        self._viewModel = StateObject(wrappedValue: CustomPetsViewModel())
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: .xxl) {
                Text("Coming soon")
            }
            .padding(.md)
        }
        .environmentObject(viewModel)
    }
}

import SwiftUI

class PetDetailsHeaderBuilderImpl: PetDetailsHeaderBuilder {
    func build(with viewModel: PetDetailsViewModel) -> AnyView {
        AnyView(Header().environmentObject(viewModel))
    }
}

private struct Header: View {
    @EnvironmentObject var viewModel: PetDetailsViewModel
    
    var body: some View {
        Text(viewModel.title)
            .font(.largeTitle.bold())
            .multilineTextAlignment(.center)
    }
}

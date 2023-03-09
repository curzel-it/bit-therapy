import SwiftUI

struct IconButton: View {
    @StateObject private var viewModel: ViewModel
    
    init(systemName: String, action: @escaping () -> Void) {
        let vm = ViewModel(imageName: nil, systemName: systemName, in: nil, action: action)
        _viewModel = StateObject(wrappedValue: vm)
    }
    
    init(imageName: String, in bundle: Bundle? = nil, action: @escaping () -> Void) {
        let vm = ViewModel(imageName: imageName, systemName: nil, in: bundle, action: action)
        _viewModel = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        Icon()
            .font(.title)
            .onTapGesture(perform: viewModel.action)
            .environmentObject(viewModel)
    }
}

private class ViewModel: ObservableObject {
    let action: () -> Void
    let bundle: Bundle?
    let imageName: String?
    let systemName: String?
    
    init(
        imageName: String?,
        systemName: String?,
        in bundle: Bundle?,
        action: @escaping () -> Void
    ) {
        self.action = action
        self.bundle = bundle
        self.imageName = imageName
        self.systemName = systemName
    }
}

private struct Icon: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        if let name = viewModel.imageName {
            Image(name, bundle: viewModel.bundle)
        } else if let name = viewModel.systemName {
            Image(systemName: name)
        } else {
            Image(systemName: "questionmark")
        }
    }
}


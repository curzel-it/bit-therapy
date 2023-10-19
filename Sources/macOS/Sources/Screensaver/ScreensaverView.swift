import Combine
import Schwifty
import SwiftUI

struct ScreensaverView: View {
    @EnvironmentObject var appConfig: AppConfig
    @StateObject private var viewModel: ScreensaverViewModel
    @State private var worldSize: CGSize = .zero
    
    private let tag = "ScreensaverView"
    
    init() {
        let vm = ScreensaverViewModel()
        vm.start()
        _viewModel = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        ZStack {
            ForEach(viewModel.entities, id: \.entityId) {
                ScreensaverEntityView(viewModel: $0)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .frame(size: worldSize)
        .measureAvailableSize { size in
            Logger.log(tag, "Available size changed", size.description)
            guard size != worldSize else { return }
            viewModel.updateWorldSize(to: size)
        }
        .onWindow { window in
            let size = window.frame.size
            Logger.log(tag, "Window size changed", size.description)
            guard size != worldSize else { return }
            viewModel.updateWorldSize(to: size)
        }
    }
}

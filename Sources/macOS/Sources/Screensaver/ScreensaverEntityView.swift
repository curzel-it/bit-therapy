import Schwifty
import SwiftUI

struct ScreensaverEntityView: View {
    @StateObject var viewModel: EntityViewModel
    
    var body: some View {
        if let image = viewModel.image {
            Image(frame: image)
                .resizable()
                .interpolation(viewModel.interpolationMode)
                .frame(size: viewModel.frame.size)
                .offset(x: viewModel.frame.midX)
                .offset(y: viewModel.frame.midY)
                .offset(x: -viewModel.windowSize.width/2)
                .offset(y: -viewModel.windowSize.height/2)
                .gesture(
                    DragGesture()
                        .onChanged { viewModel.dragGestureChanged(translation: $0.translation) }
                        .onEnded { _ in viewModel.dragEnded() }
                )
        }
    }
}

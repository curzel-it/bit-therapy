//
// Pet Therapy.
//

import Biosphere
import LiveEnvironment
import Pets
import Squanch
import SwiftUI

public struct GameView: View {
    
    @StateObject var viewModel: ViewModel
    
    public init(size: CGSize) {
        self._viewModel = StateObject(
            wrappedValue: ViewModel(bounds: CGRect(size: size))
        )
    }
    
    public var body: some View {
        ZStack {
            Inhabitants()
        }
        .frame(sizeOf: viewModel.state.bounds)
        .environmentObject(viewModel)
        .environmentObject(viewModel as LiveEnvironment)
    }
}

private struct Inhabitants: View {
    
    @EnvironmentObject var viewModel: LiveEnvironment
    
    var body: some View {
        ForEach(viewModel.state.children) {
            Inhabitant(entity: $0)
        }
    }
}

private struct Inhabitant: View {
    
    @EnvironmentObject var viewModel: LiveEnvironment
    
    @StateObject var entity: Entity
    
    var body: some View {
        EntityView(child: entity)
            .offset(x: -viewModel.state.bounds.width/2)
            .offset(y: -viewModel.state.bounds.height/2)
            .offset(x: entity.frame.origin.x)
            .offset(y: entity.frame.origin.y)
            .offset(x: entity.frame.width/2)
            .offset(y: entity.frame.height/2)
    }
}

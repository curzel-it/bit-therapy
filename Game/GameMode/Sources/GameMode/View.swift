//
// Pet Therapy.
//

import AppKit
import Biosphere
import Pets
import Squanch
import SwiftUI

public struct GameView: View {
    
    @StateObject var viewModel = ViewModel(
        bounds: CGRect(size: CGSize(width: 1200, height: 700))
    )
    
    public init() {
        // ...
    }
    
    public var body: some View {
            ZStack {
                Inhabitants()
            }
            .frame(sizeOf: viewModel.state.bounds)
            .environmentObject(viewModel)
            .environmentObject(viewModel as HabitatViewModel)
    }
}

private struct Inhabitants: View {
    
    @EnvironmentObject var viewModel: HabitatViewModel
    
    var body: some View {
        ForEach(viewModel.state.children) {
            Inhabitant(entity: $0)
        }
    }
}

private struct Inhabitant: View {
    
    @EnvironmentObject var viewModel: HabitatViewModel
    
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

//
// Pet Therapy.
//

import AppKit
import Biosphere
import Pets
import Squanch
import SwiftUI

public struct GameView: View {
    
    @StateObject var viewModel = ViewModel(bounds: .zero)
    
    @State var size: CGSize = .zero
    
    public init() {
        // ...
    }
    
    public var body: some View {
        GeometryReader { geo in
            ZStack {
                Inhabitants()
            }
            .frame(size: size)
            .environmentObject(viewModel)
            .environmentObject(viewModel as HabitatViewModel)
            .background(.green)
            .border(.red, width: 1)
            .onAppear { update(with: geo.size) }
            .onChange(of: geo.size) { update(with: $0) }
        }
    }
    
    func update(with newSize: CGSize) {
        size = newSize
        viewModel.set(bounds: CGRect(size: newSize))
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

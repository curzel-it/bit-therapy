import Combine
import DesignSystem
import Pets
import Schwifty
import SwiftUI
import Yage
import YageLive

struct GameView: View {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        ZStack {
            Background().frame(size: viewModel.worldSize)
            Inhabitants()
            IntroDialog()
        }
        .measureAvailableSize {
            viewModel.worldSize = $0
        }
        .environmentObject(viewModel)
        .environmentObject(viewModel.world as PetsEnvironment)
        .environmentObject(viewModel.world as LiveWorld)
    }
}

private struct Inhabitants: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        ZStack {
            ForEach(viewModel.entities, id: \.self) {
                PetView(entityId: $0)
            }
        }
        .offset(x: -viewModel.worldSize.width/2)
        .offset(y: -viewModel.worldSize.height/2)
    }
}

private struct PetView: View {
    @EnvironmentObject var world: PetsEnvironment
    
    let entityId: String
    
    var body: some View {
        let entity = world.state.children.first { $0.id == entityId }
        if let pet = entity as? PetEntity {
            BaseEntityView(representing: pet, applyOffset: true)
                .draggable(pet)
        }
    }
}


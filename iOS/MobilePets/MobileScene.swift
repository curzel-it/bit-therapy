import Combine
import DesignSystem
import Pets
import Schwifty
import SwiftUI
import Yage

struct MainScene: Scene {
    @StateObject var appState = AppState.global
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                Menu()
            }
            .environmentObject(appState)
        }
    }
}

private struct ContentView: View {
    @State var worldSize: CGSize = UIScreen.main.bounds.size
    
    var body: some View {
        WorldView(worldSize: $worldSize)
            .measureScreenSize(to: $worldSize)
    }
}

private struct WorldView: View {
    @EnvironmentObject var appState: AppState
    @Binding var worldSize: CGSize
    @StateObject var world: PetsEnvironment = PetsEnvironment(with: AppState.global, bounds: .zero)
    
    var body: some View {
        ZStack {
            ForEach(world.state.children) { entity in
                if let pet = entity as? PetEntity {
                    BaseEntityView(representing: pet, applyOffset: true)
                }
            }
        }
        .offset(x: -worldSize.width/2)
        .offset(y: -worldSize.height/2)
        .environmentObject(world)
        .environmentObject(world as LiveWorld)
        .onReceive(Just(worldSize)) { newSize in
            printDebug("WorldView", "Got new size", newSize.description)
            world.set(bounds: CGRect(size: newSize))
            world.state.children
                .compactMap { $0.capability(for: AutoRespawn.self) }
                .forEach { $0.teleport() }
        }
    }
}

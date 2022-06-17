//
// Pet Therapy.
//

import AppKit
import AppState
import EntityWindow
import PetEntity
import Pets
import Physics
import SwiftUI

class FullScreenViewModel: HabitatViewModel {
        
    weak var window: NSWindow!
    
    override init() {
        super.init()
        addSelectedPet()
    }
    
    func spawnWindow() {
        guard let frame = NSScreen.main?.frame.bounds else { return }
        let window = NSWindow(
            contentRect: frame,
            styleMask: [.fullSizeContentView, .closable, .miniaturizable, .fullScreen],
            backing: .buffered,
            defer: false
        )
        let content = WorldView()
            .environmentObject(self as HabitatViewModel)
            .hosted()
        content.translatesAutoresizingMaskIntoConstraints = false
        window.contentView?.addSubview(content)
        content.constrainToFillParent()
        window.show()
    }
    
    func addSelectedPet() {
        addPet(for: AppState.global.selectedPet ?? .sloth)
    }
    
    private func addPet(for species: Pet) {
        let pet = PetEntity(species, in: state.bounds)
        pet.install(MouseDraggablePet.self)
        pet.install(ShowsMenuOnRightClick.self)
        pet.install(LinearMovement.self)
        pet.install(ReactToHotspots.self)
        pet.install(ResumeMovementAfterAnimations.self)
        pet.install(BounceOffLateralBounds.self)
        pet.set(direction: .init(dx: 1, dy: 0))
        state.children.append(pet)
    }
    
    override func kill(animated: Bool) {
        super.kill(animated: animated)
        if !animated {
            window?.close()
        }
    }
}

struct WorldView: View {
    
    @EnvironmentObject var viewModel: HabitatViewModel
    
    var body: some View {
        ZStack {
            ForEach(viewModel.state.children) { entity in
                EntityView(child: entity)
                    .frame(width: entity.frame.width)
                    .frame(height: entity.frame.height)
                    .offset(x: entity.frame.minX - viewModel.state.bounds.midX)
                    .offset(y: entity.frame.minY - viewModel.state.bounds.midY)
            }
        }
        .frame(width: viewModel.state.bounds.width)
        .frame(height: viewModel.state.bounds.height)
    }
}

import Schwifty
import Squanch
import SwiftUI
import Yage

class EntityView: NSView {
    let entity: RenderableEntity
    let habitat: LiveHabitat
            
    weak var onScreenView: NSView!
    weak var rightClickMenu: NSView!
    
    init(representing entity: RenderableEntity, in habitat: LiveHabitat) {
        self.entity = entity
        self.habitat = habitat
        super.init(frame: CGRect(size: entity.frame.size))
        self.translatesAutoresizingMaskIntoConstraints = false
        loadEntityView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - On Screen View
    
    private func loadEntityView() {
        let view = ContentView(entity: self.entity)
            .environmentObject(habitat)
            .hosted()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.frame = self.bounds
        self.addSubview(view)
        view.constrainToFillParent()
        onScreenView = view
    }
    
    // MARK: - Mouse Drag
    
    override func mouseDragged(with event: NSEvent) {
        entity.mouseDrag?.mouseDragged(with: event)
    }
    
    override func mouseUp(with event: NSEvent) {
        entity.mouseDrag?.mouseUp(with: event)
    }
    
    // MARK: - Right Click
    
    override func rightMouseUp(with event: NSEvent) {
        entity.rightClick?.onRightClick(with: event)
    }
}

private struct ContentView: View {
    
    @EnvironmentObject var viewModel: LiveHabitat
    
    @StateObject var entity: RenderableEntity
    
    var body: some View {
        ZStack {
            if let sprite = entity.sprite {
                Image(nsImage: sprite).pixelArt()
            }
            if viewModel.debug {
                Text(entity.id)
            }
        }
        .frame(sizeOf: entity.frame)
        .rotation3DEffect(.radians(entity.xAngle), axis: (x: 1, y: 0, z: 0))
        .rotation3DEffect(.radians(entity.yAngle), axis: (x: 0, y: 1, z: 0))
        .rotation3DEffect(.radians(entity.zAngle), axis: (x: 0, y: 0, z: 1))
        .background(entity.backgroundColor)
    }
}
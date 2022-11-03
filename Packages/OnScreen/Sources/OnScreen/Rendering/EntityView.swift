import Schwifty
import Squanch
import SwiftUI
import Yage

class EntityView: NSView {
    let entity: Entity
    let world: LiveWorld
            
    weak var onScreenView: NSView!
    weak var rightClickMenu: NSView!
    
    init(representing entity: Entity, in world: LiveWorld) {
        self.entity = entity
        self.world = world
        super.init(frame: CGRect(size: entity.frame.size))
        self.translatesAutoresizingMaskIntoConstraints = false
        loadEntityView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - On Screen View
    
    private func loadEntityView() {
        let view = BaseEntityView(representing: entity)
            .environmentObject(world)
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

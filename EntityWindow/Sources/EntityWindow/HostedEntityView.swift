//
// Pet Therapy.
//

import AppState
import DesignSystem
import Physics
import Squanch
import Schwifty
import SwiftUI

class HostedEntityView: NSView {
    
    let entity: PhysicsEntity
    let habitat: HabitatViewModel
        
    weak var onScreenView: NSView!
    weak var rightClickMenu: NSView!
    
    public init(representing entity: PhysicsEntity, in habitat: HabitatViewModel) {
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
        let view = EntityView(child: entity)
            .font(.bold, .sm)
            .environmentObject(habitat)
            .environmentObject(AppState.global)
            .hosted()
        
        view.translatesAutoresizingMaskIntoConstraints = false
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

import Combine
import Swinject
import Schwifty
import SwiftUI

class PixelArtEntityView: NSImageView, EntityView {
    var entityId: String { viewModel.entityId }
    var zIndex: Int { viewModel.zIndex }
    
    private let viewModel: EntityViewModel
    
    init(representing entity: RenderableEntity) {
        self.viewModel = EntityViewModel(representing: entity)
        super.init(frame: CGRect(size: .oneByOne))
        self.viewModel.screenScaleFactor = { [weak self] in self?.window?.backingScaleFactor ?? 1 }
        translatesAutoresizingMaskIntoConstraints = false
        imageScaling = .scaleProportionallyUpOrDown
    }
    
    override func hitTest(_ point: NSPoint) -> NSView? {
        if viewModel.isInteractable {
            return super.hitTest(point)
        }
        return nil
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() {
        viewModel.update()
    }
    
    override func mouseDown(with event: NSEvent) {
        viewModel.mouseDown()
    }
    
    override func mouseDragged(with event: NSEvent) {
        viewModel.mouseDragged(
            eventDelta: CGSize(width: event.deltaX, height: -event.deltaY),
            viewDelta: CGSize(width: event.deltaX, height: event.deltaY)
        )
    }
    
    override func mouseUp(with event: NSEvent) {
        viewModel.mouseUp()
    }
    
    override func rightMouseUp(with event: NSEvent) {
        viewModel.rightMouseUp(from: window, at: event.locationInWindow)
    }
}

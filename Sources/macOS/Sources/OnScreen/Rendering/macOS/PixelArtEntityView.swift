import Combine
import Swinject
import Schwifty
import SwiftUI

class PixelArtEntityView: NSImageView, EntityView {
    var entityId: String { viewModel.entityId }
    var zIndex: Int { viewModel.zIndex }
    
    private let viewModel: EntityViewModel
    private var disposables = Set<AnyCancellable>()
    
    init(representing entity: RenderableEntity) {
        viewModel = EntityViewModel(representing: entity, in: .bottomUp)
        super.init(frame: CGRect(size: .oneByOne))
        translatesAutoresizingMaskIntoConstraints = false
        imageScaling = .scaleProportionallyUpOrDown
        loadScaleFactor()
        bindFrame()
        bindImage()
        bindLifecycle()
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
        viewModel.dragged(
            eventDelta: CGSize(width: event.deltaX, height: event.deltaY),
            viewDelta: CGSize(width: event.deltaX, height: -event.deltaY)
        )
    }
    
    override func mouseUp(with event: NSEvent) {
        viewModel.dragEnded()
    }
    
    override func rightMouseUp(with event: NSEvent) {
        viewModel.rightMouseUp(from: window, at: event.locationInWindow)
    }
    
    private func loadScaleFactor() {
        viewModel.scaleFactor = window?.backingScaleFactor ?? 1
    }
    
    private func bindFrame() {
        viewModel.$frame
            .sink { [weak self] in self?.frame = $0 }
            .store(in: &disposables)
    }
    
    private func bindImage() {
        viewModel.$image
            .sink { [weak self] in self?.image = $0 }
            .store(in: &disposables)
    }
    
    private func bindLifecycle() {
        viewModel.$isAlive
            .removeDuplicates()
            .filter { !$0 }
            .sink { [weak self] _ in
                guard let self else { return }
                self.removeFromSuperview()
                self.disposables.removeAll()
                self.image = nil
            }
            .store(in: &disposables)
    }
}

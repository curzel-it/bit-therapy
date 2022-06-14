//
// Pet Therapy.
//

import Physics
import Squanch
import Schwifty
import SwiftUI

class HostView: NSView {

    let viewModel: OnScreenViewModel
    
    var isBeingDragged = false
    
    weak var onScreenView: NSView!
    weak var rightClickMenu: NSView!
    
    init(viewModel: OnScreenViewModel) {
        self.viewModel = viewModel
        super.init(frame: CGRect(size: viewModel.pet.frame.size))
        self.translatesAutoresizingMaskIntoConstraints = false
        loadOnScreenView()
        loadRightClickMenu()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - On Screen View
    
    private func loadOnScreenView() {
        let view = OnScreenView(viewModel: self.viewModel).hosted()
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        view.constrainToFillParent()
        onScreenView = view
    }
    
    // MARK: - Mouse Drag
    
    override func mouseDragged(with event: NSEvent) {
        super.mouseDragged(with: event)
        guard !isBeingDragged else { return }
        printDebug("OnScreenHost", "Dragging with mouse...")
        viewModel.onTouchDown()
        isBeingDragged = true
    }
    
    override func mouseUp(with event: NSEvent) {
        guard self.isBeingDragged else { return }
        printDebug("OnScreenHost", "Done dragging")
        isBeingDragged = false
        viewModel.setPetPosition(fromWindow: window?.frame.origin)
        viewModel.onTouchUp()
    }
    
    // MARK: - Right Click
    
    override func rightMouseUp(with event: NSEvent) {
        printDebug("OnScreenHost", "Right clicked")
        rightClickMenu?.isHidden = false
    }
    
    func loadRightClickMenu() {
        let view = RightClickMenu { [weak self] in
            self?.rightClickMenu?.isHidden = true
        }.hosted()
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        view.isHidden = true
        view.constrain(.height, to: 100)
        view.constrain(.width, to: 200)
        view.constrainToCenterInParent()
        rightClickMenu = view
    }
}

// MARK: - Attach to Window

extension HostView {
    
    func attach(to window: NSWindow) {
        window.setFrame(CGRect(size: frame.size), display: true)
        window.contentView?.addSubview(self)
        self.constrainToFillParent()
    }
}

// MARK: - Window Moved

extension OnScreenViewModel {
    
    func setPetPosition(fromWindow position: CGPoint?) {
        guard let position = position else { return }
        let maxX = state.bounds.maxX - pet.frame.width
        let maxY = state.bounds.maxY - pet.frame.height
        
        let fixedPosition = CGPoint(
            x: min(max(0, position.x), maxX),
            y: min(max(0, maxY - position.y), maxY)
        )
        pet.set(origin: fixedPosition)
    }
}

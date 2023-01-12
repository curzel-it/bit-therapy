import AppKit
import Combine
import Schwifty
import SwiftUI

class WidgetWindow: NSWindow {
    private var widget: AnyWidget?
    private weak var content: NSView?
    private weak var coordinator: WidgetsCoordinator?
    private var disposables = Set<AnyCancellable>()

    init(representing widget: AnyWidget, coordinatedBy coordinator: WidgetsCoordinator) {
        self.widget = widget
        self.coordinator = coordinator
        super.init(contentRect: .zero, styleMask: .borderless, backing: .buffered, defer: false)
        setupWindow()
        setupContent()
        bindFrame()
        bindIsAlive()
        bindZIndex()
    }
    
    private func bindZIndex() {
        widget?.windowZIndex()
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] zIndex in self?.orderedIndex = zIndex }
            .store(in: &disposables)
    }
    
    private func bindIsAlive() {
        widget?.windowShown()
            .removeDuplicates()
            .filter { !$0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.close() }
            .store(in: &disposables)
    }
    
    private func bindFrame() {
        widget?.windowFrame()
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newFrame in
                self?.setFrame(newFrame, display: true, animate: false)
            }
            .store(in: &disposables)
    }

    private func setupContent() {
        guard let contentView else { return }
        if let view = widget?.content() {
            view.frame = contentView.bounds
            contentView.addSubview(view)
            view.constrainToFillParent()
            content = view
        }
    }

    private func setupWindow() {
        isOpaque = false
        hasShadow = false
        backgroundColor = .clear
        isMovableByWindowBackground = false
        level = .statusBar
        collectionBehavior = .canJoinAllSpaces
    }
    
    override func close() {
        super.close()
        disposables.removeAll()
        guard let widget, let coordinator else { return }
        coordinator.onWindowClosed(for: widget)
        widget.onWindowClosed()
        self.coordinator = nil
        self.widget = nil
    }
}

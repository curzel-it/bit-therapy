//
// Pet Therapy.
//

import AppKit
import Combine
import Biosphere
import SwiftUI

open class EntityWindow: NSWindow {
    
    public let entity: Entity
    public let habitat: HabitatViewModel
    
    public weak var entityView: NSView!
    
    private var boundsCanc: AnyCancellable!
    private var aliveCanc: AnyCancellable!
    
    private(set) var expectedFrame: CGRect = .zero
    
    public init(representing entity: Entity, in habitat: HabitatViewModel) {
        self.entity = entity
        self.habitat = habitat
        
        super.init(
            contentRect: .zero,
            styleMask: .borderless,
            backing: .buffered,
            defer: false
        )
        makeTransparent()
        loadEntityView()
        bindToEntityFrame()
        bindToEntityLifecycle()
    }
    
    private func loadEntityView() {
        let view = HostedEntityView(representing: entity, in: habitat)
        setFrame(CGRect(size: view.frame.size), display: true)
        contentView?.addSubview(view)
        view.constrainToFillParent()
        entityView = view
    }
    
    private func makeTransparent() {
        isOpaque = false
        hasShadow = false
        backgroundColor = .clear
        isMovableByWindowBackground = true
        level = .statusBar
        collectionBehavior = .canJoinAllSpaces
    }
    
    open override func close() {
        boundsCanc?.cancel()
        boundsCanc = nil
        super.close()
    }
}

// MARK: - Frame

private extension EntityWindow {
    
    func bindToEntityFrame() {
        boundsCanc = entity.$frame.sink { frame in
            self.updateFrame(
                toShow: frame,
                in: self.habitat.state.bounds
            )
        }
    }
    
    func updateFrame(toShow entityFrame: CGRect, in habitat: CGRect) {
        let sizeChanged = expectedFrame.size != entityFrame.size
        expectedFrame = CGRect(
            origin: CGPoint(
                x: entityFrame.minX,
                y: habitat.height - entityFrame.maxY
            ),
            size: entityFrame.size
        )
        setFrame(expectedFrame, display: true, animate: sizeChanged)
    }
}

// MARK: - Alive

extension EntityWindow {
    
    func bindToEntityLifecycle() {
        aliveCanc = entity.$isAlive.sink { isAlive in
            if !isAlive {
                self.close()
            }
        }
    }
}

// MARK: - Equatable

extension EntityWindow {
    
    static func == (lhs: EntityWindow, rhs: EntityWindow) -> Bool {
        lhs.entity == rhs.entity
    }
}

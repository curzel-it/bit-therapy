import AppKit
import Combine
import SwiftUI
import Squanch
import Yage

open class EntityWindow: NSWindow {
    public let entity: Entity
    public let world: LiveWorld
    
    weak var entityView: NSView!
    
    private var boundsCanc: AnyCancellable!
    private var aliveCanc: AnyCancellable!
    
    private(set) var expectedFrame: CGRect = .zero
    
    public init(representing entity: Entity, in world: LiveWorld) {
        self.entity = entity
        self.world = world
        super.init(contentRect: .zero, styleMask: .borderless, backing: .buffered, defer: false)
        setupWindow()
        loadEntityView()
        bindToEntityFrame()
        bindToEntityLifecycle()
    }
    
    private func loadEntityView() {
        let view = buildEntityView()
        contentView?.addSubview(view)
        view.constrainToFillParent()
        entityView = view
    }
    
    open func buildEntityView() -> NSView {
        let view = EntityView(representing: entity, in: world)
        setFrame(CGRect(size: view.frame.size), display: true)
        return view
    }
    
    private func setupWindow() {
        isOpaque = false
        hasShadow = false
        backgroundColor = .clear
        isMovableByWindowBackground = !entity.isStatic        
        level = .statusBar
        collectionBehavior = .canJoinAllSpaces
        
        if !entity.isStatic, entity.capability(for: MouseDraggable.self) == nil {
            entity.install(MouseDraggable())
        }
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
            self.updateFrame(toShow: frame)
        }
    }
    
    func updateFrame(toShow entityFrame: CGRect) {
        let world = world.state.bounds
        expectedFrame = CGRect(
            origin: CGPoint(x: entityFrame.minX, y: world.height - entityFrame.maxY),
            size: entityFrame.size
        )
        setFrame(expectedFrame, display: true, animate: false)
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

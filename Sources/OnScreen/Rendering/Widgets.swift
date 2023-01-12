import AppKit
import Combine
import Foundation
import MacWidgets
import Schwifty
import Yage

class EntityWidget: PixelArtWidget {
    let entity: Entity
    let frame: CurrentValueSubject<CGRect, Never>
    let isAlive: CurrentValueSubject<Bool, Never>
    let image: CurrentValueSubject<WidgetAsset, Never>
    let zIndex: CurrentValueSubject<Int, Never>
    
    init(representing entity: Entity) {
        self.entity = entity
        frame = CurrentValueSubject<CGRect, Never>(entity.frame)
        isAlive = CurrentValueSubject<Bool, Never>(entity.isAlive)
        image = CurrentValueSubject<WidgetAsset, Never>(.none)
        zIndex = CurrentValueSubject<Int, Never>(0)
    }
    
    func update() {
        frame.send(entity.frame)
        isAlive.send(entity.isAlive)
        image.send(WidgetAsset(from: entity))
        zIndex.send(entity.species.zIndex)
    }
}

extension EntityWidget {
    var id: String { entity.id }
    
    func asset() -> AnyPublisher<any Asset, Never> {
        image
            .map { $0 as any Asset }
            .eraseToAnyPublisher()
    }
    
    func windowFrame() -> AnyPublisher<CGRect, Never> {
        frame
            .map { [weak self] frame in
                frame.toScreen(frame: self?.entity.worldBounds ?? .zero)
            }
            .eraseToAnyPublisher()
    }
    
    func windowShown() -> AnyPublisher<Bool, Never> {
        isAlive.eraseToAnyPublisher()
    }
    
    func windowZIndex() -> AnyPublisher<Int, Never> {
        zIndex.map { -$0 }.eraseToAnyPublisher()
    }
    
    func onWindowClosed() {
        entity.kill()
    }
}

extension EntityWidget: MacWidgets.RightClickable {
    func rightClicked(with event: NSEvent) {
        entity.rightClick?.onRightClick(with: event)
    }
}

extension EntityWidget: MacWidgets.MouseDraggable {
    func mouseDragged(to _: CGPoint, delta: CGSize) {
        entity.mouseDrag?.mouseDragged()
    }
    
    func mouseDragEnded(at _: CGPoint, delta: CGSize) {
        entity.mouseDrag?.mouseUp(translation: delta)
    }
}

struct WidgetAsset: Asset {
    static let none = WidgetAsset(from: nil)
    
    let id: String
    let image: NSImage?
    let flipHorizontally: Bool
    let flipVertically: Bool
    let zAngle: CGFloat?
    
    init(from entity: Entity?) {
        id = entity?.sprite ?? ""
        image = PetsAssetsProvider.shared.image(sprite: entity?.sprite)
        flipHorizontally = entity?.rotation?.isFlippedHorizontally ?? false
        flipVertically = entity?.rotation?.isFlippedVertically ?? false
        zAngle = entity?.rotation?.z
    }
}

private extension CGRect {
    func toScreen(frame screen: CGRect) -> CGRect {
        CGRect(origin: .zero, size: size)
            .offset(x: minX)
            .offset(y: screen.size.height)
            .offset(y: -maxY)
            .offset(x: screen.origin.x)
            .offset(y: -screen.origin.y)
    }
}

import Combine
import NotAGif
import Swinject
import Schwifty
import SwiftUI

class EntityViewModel: ObservableObject {
    @Inject var assetsProvider: PetsAssetsProvider
    
    @Published private(set) var frame: CGRect = .init(square: 1)
    @Published private(set) var isAlive: Bool = true
    @Published private(set) var image: ImageFrame?
    
    var entityId: String { entity.id }
    var isInteractable: Bool { entity.isInteractable }
    var scaleFactor: CGFloat = 1
    var windowSize: CGSize { entity.windowSize }
    var zIndex: Int { entity.zIndex }
    private(set) var interpolationMode: ImageInterpolationMode = .none
    
    private let coordinateSystem: CoordinateSystem
    private let entity: RenderableEntity
    private var firstMouseClick: Date?
    private var imageCache: [Int: ImageFrame] = [:]
    private let imageInterpolation = ImageInterpolationUseCase()
    private var isMouseDown = false
    private var lastDragTranslation: CGSize = .zero
    private var locationOnLastDrag: CGPoint = .zero
    private var locationOnMouseDown: CGPoint = .zero
    private var lastSpriteHash: Int = 0
    
    init(representing entity: RenderableEntity, in coordinateSystem: CoordinateSystem) {
        self.coordinateSystem = coordinateSystem
        self.entity = entity
    }
}

// MARK: - Updates

extension EntityViewModel {
    func update() {
        isAlive = entity.isAlive
        guard entity.isAlive else { return }
        updateFrameIfNeeded()
        updateImageIfNeeded()
    }
    
    private func updateFrameIfNeeded() {
        guard !entity.isBeingDragged() else { return }
        frame = coordinateSystem.frame(of: entity)
    }
    
    private func updateImageIfNeeded() {
        let hash = entity.spriteHash()
        guard needsSpriteUpdate(for: hash) else { return }
        image = nextImage(for: hash)
    }
}

// MARK: - Mouse Events

extension EntityViewModel {
    func mouseDown() {
        guard !isMouseDown else { return }
        isMouseDown = true
        lastDragTranslation = .zero
        locationOnLastDrag = frame.origin
        locationOnMouseDown = frame.origin
    }
    
    func dragGestureChanged(translation: CGSize) {
        mouseDown()
        let delta = CGSize(
            width: translation.width - lastDragTranslation.width,
            height: translation.height - lastDragTranslation.height
        )
        lastDragTranslation = translation
        dragged(eventDelta: delta, viewDelta: delta)
    }
    
    func dragged(eventDelta: CGSize, viewDelta: CGSize) {
        let newOrigin = locationOnLastDrag.offset(by: viewDelta)
        frame.origin = newOrigin
        locationOnLastDrag = newOrigin
        entity.dragged(currentDelta: eventDelta)
    }
    
    func dragEnded() {
        guard isMouseDown else { return }
        isMouseDown = false
        let delta = CGSize(
            width: locationOnLastDrag.x - locationOnMouseDown.x,
            height: locationOnMouseDown.y - locationOnLastDrag.y
        )
        entity.dragEnded(totalDelta: delta)
    }
    
    func rightMouseUp(from window: SomeWindow?, at point: CGPoint) {
        entity.rightClicked(from: window, at: point)
    }
}

// MARK: - Image Loading

private extension EntityViewModel {
    func nextImage(for hash: Int) -> ImageFrame? {
        if let cached = imageCache[hash] { return cached }
        guard let image = interpolatedImageForCurrentSprite() else { return nil }
        imageCache[hash] = image
        return image
    }
    
    func interpolatedImageForCurrentSprite() -> ImageFrame? {
        guard let asset = assetsProvider.image(sprite: entity.sprite) else { return nil }
        interpolationMode = imageInterpolation.interpolationMode(
            for: asset,
            renderingSize: frame.size,
            screenScale: scaleFactor
        )
        
        return asset
            .scaled(to: renderingSize(), with: interpolationMode)
            .rotated(by: entity.spriteRotation?.zAngle)
            .flipped(
                horizontally: entity.spriteRotation?.isFlippedHorizontally ?? false,
                vertically: entity.spriteRotation?.isFlippedVertically ?? false
            )
    }
    
    func needsSpriteUpdate(for newHash: Int) -> Bool {
        if newHash != lastSpriteHash {
            lastSpriteHash = newHash
            return true
        }
        return false
    }
    
    private func renderingSize() -> CGSize {
        CGSize(
            width: frame.size.width * scaleFactor,
            height: frame.size.height * scaleFactor
        )
    }
}

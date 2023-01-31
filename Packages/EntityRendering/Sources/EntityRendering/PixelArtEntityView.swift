import Combine
import Schwifty
import SwiftUI

class PixelArtEntityView: NSImageView, EntityView {
    var zIndex: Int { entity.zIndex }
    
    private let entity: RenderableEntity
    private let assetsProvider: AssetsProvider
    private var imageCache: [Int: NSImage] = [:]
    private var firstMouseClick: Date?
    private var locationOnLastDrag: CGPoint = .zero
    private var locationOnMouseDown: CGPoint = .zero
    private var lastSpriteHash: Int = 0
    private let imageInterpolation = ImageInterpolationUseCase()
    
    init(representing entity: RenderableEntity, with assetsProvider: AssetsProvider) {
        self.entity = entity
        self.assetsProvider = assetsProvider
        super.init(frame: CGRect(size: .oneByOne))
        translatesAutoresizingMaskIntoConstraints = false
        imageScaling = .scaleProportionallyUpOrDown
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() {
        guard entity.isAlive else {
            removeFromSuperview()
            return
        }
        updateFrameIfNeeded()
        updateImageIfNeeded()
    }
    
    private func updateFrameIfNeeded() {
        guard !entity.isBeingDragged() else { return }
        guard let size = max(entity.frame.size, .oneByOne) else { return }
        frame = CGRect(
            origin: .zero
                .offset(x: entity.frame.minX)
                .offset(y: entity.windowSize.height)
                .offset(y: -entity.frame.maxY),
            size: size
        )
    }
    
    private func updateImageIfNeeded() {
        let hash = entity.spriteHash()
        guard needsSpriteUpdate(for: hash) else { return }
        let newImage = nextImage(for: hash)
        image = newImage
    }
    
    // MARK: - Mouse Drag
    
    override func mouseDown(with event: NSEvent) {
        locationOnLastDrag = frame.origin
        locationOnMouseDown = frame.origin
    }
    
    override func mouseDragged(with event: NSEvent) {
        let newOrigin = locationOnLastDrag.offset(x: event.deltaX, y: -event.deltaY)
        frame.origin = newOrigin
        locationOnLastDrag = newOrigin
        let delta = CGSize(width: event.deltaX, height: event.deltaY)
        entity.mouseDragged(currentDelta: delta)
    }
    
    override func mouseUp(with event: NSEvent) {
        let delta = CGSize(
            width: locationOnLastDrag.x - locationOnMouseDown.x,
            height: locationOnMouseDown.y - locationOnLastDrag.y
        )
        if let finalPosition = entity.mouseUp(totalDelta: delta) {
            frame.origin = finalPosition
        }
    }
    
    // MARK: - Right Click
    
    override func rightMouseUp(with event: NSEvent) {
        entity.rightClicked(with: event)
    }
    
    // MARK: - Image Loading
    
    func nextImage(for hash: Int) -> NSImage? {
        if let cached = imageCache[hash] { return cached }
        guard let image = interpolatedImageForCurrentSprite() else { return nil }
        imageCache[hash] = image
        return image
    }
    
    func interpolatedImageForCurrentSprite() -> NSImage? {
        guard let asset = assetsProvider.image(sprite: entity.sprite) else { return nil }
        let interpolationMode = imageInterpolation.interpolationMode(
            for: asset,
            renderingSize: frame.size,
            screenScale: window?.backingScaleFactor ?? 1
        )
        
        return asset
            .scaled(to: frame.size, with: interpolationMode)
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
}

import Combine
import Schwifty
import SwiftUI
import Yage

class EntityView: NSImageView {
    private let entity: Entity
    private let assetsProvider = PetsAssetsProvider.shared
    private var imageCache: [Int: NSImage] = [:]
    private var lastMouseUp: TimeInterval = .zero
    private var locationOnLastDrag: CGPoint = .zero
    private var locationOnMouseDown: CGPoint = .zero
    private var lastSpriteHash: Int = 0
    
    init(representing entity: Entity) {
        self.entity = entity
        super.init(frame: CGRect(size: entity.frame.size))
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
        guard entity.state != .drag else { return }
        guard let size = max(entity.frame.size, .oneByOne) else { return }
        frame = CGRect(
            origin: .zero
                .offset(x: entity.frame.minX)
                .offset(y: entity.worldBounds.height)
                .offset(y: -entity.frame.maxY)
                .offset(x: entity.worldBounds.origin.x)
                .offset(y: -entity.worldBounds.origin.y),
            size: size
        )
    }
    
    private func updateImageIfNeeded() {
        let hash = entity.spriteHash()
        guard needsSpriteUpdate(for: hash) else { return }
        let newImage = nextImage(for: hash)
        layer?.transform = layerTransform(forAngle: entity.rotation?.z)
        image = newImage
    }
    
    override func draw(_ rect: NSRect) {
        NSGraphicsContext.current?.cgContext.interpolationQuality = .none
        super.draw(rect)
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
        entity.mouseDrag?.mouseDragged(currentDelta: delta)
    }
    
    override func mouseUp(with event: NSEvent) {
        let delta = CGSize(
            width: locationOnLastDrag.x - locationOnMouseDown.x,
            height: locationOnMouseDown.y - locationOnLastDrag.y
        )
        handleDoubleClickIfPossible()
        entity.mouseDrag?.mouseUp(totalDelta: delta)
    }

    // MARK: - Right Click

    override func rightMouseUp(with event: NSEvent) {
        entity.rightClick?.onRightClick(with: event)
    }
    
    // MARK: - Double Click
    
    func handleDoubleClickIfPossible() {
        let now = Date().timeIntervalSince1970
        if now - lastMouseUp < 250 {
            entity.doubleClick?.onDoubleClick()
        }
        lastMouseUp = now
    }
}

// MARK: - Hash

private extension Entity {
    func spriteHash() -> Int {
        var hasher = Hasher()
        hasher.combine(sprite)
        hasher.combine(frame.size.width)
        hasher.combine(frame.size.height)
        hasher.combine(rotation?.isFlippedHorizontally ?? false)
        hasher.combine(rotation?.isFlippedVertically ?? false)
        hasher.combine(rotation?.z ?? 0)
        return hasher.finalize()
    }
}

// MARK: - Image Loading

private extension EntityView {
    func nextImage(for hash: Int) -> NSImage? {
        if let cached = imageCache[hash] { return cached }
        guard let image = interpolatedImageForCurrentSprite() else { return nil }
        imageCache[hash] = image
        return image
    }
    
    func interpolatedImageForCurrentSprite() -> NSImage? {
        assetsProvider
            .image(sprite: entity.sprite)?
            .scaled(to: frame.size) // entity.frame.size)
            .flipped(
                horizontally: entity.rotation?.isFlippedHorizontally ?? false,
                vertically: entity.rotation?.isFlippedVertically ?? false
            )
    }
    
    func needsSpriteUpdate(for newHash: Int) -> Bool {
        if newHash != lastSpriteHash {
            lastSpriteHash = newHash
            return true
        }
        return false
    }
    
    func layerTransform(forAngle angle: CGFloat?) -> CATransform3D {
        if let angle, angle != 0 {
            var transform = CATransform3DIdentity
            transform = CATransform3DTranslate(transform, bounds.midX, bounds.midY, 0)
            transform = CATransform3DRotate(transform, angle, 0, 0, 1)
            transform = CATransform3DTranslate(transform, -bounds.midX, -bounds.midY, 0)
            return transform
        } else {
            return CATransform3DIdentity
        }
    }
}

// MARK: - Image Manipulation

extension NSImage {
    func flipped(horizontally: Bool = false, vertically: Bool = false) -> NSImage {
        let flippedImage = NSImage(size: size)
        let rect = CGRect(size: size)
        flippedImage.lockFocus()
        NSGraphicsContext.current?.imageInterpolation = .none

        let transform = NSAffineTransform()
        transform.translateX(
            by: horizontally ? size.width : 0,
            yBy: vertically ? size.height : 0
        )
        transform.scaleX(
            by: horizontally ? -1 : 1,
            yBy: vertically ? -1 : 1
        )
        transform.concat()

        draw(at: .zero, from: rect, operation: .sourceOver, fraction: 1)
        flippedImage.unlockFocus()
        return flippedImage
    }
    
    func scaled(to newSize: CGSize) -> NSImage {
        guard size != newSize else { return self }
        let targetImage = NSImage.init(size: newSize)
        targetImage.lockFocus()
        NSGraphicsContext.current?.imageInterpolation = .none
        draw(
            in: CGRect(origin: .zero, size: newSize),
            from: CGRect(origin: .zero, size: size),
            operation: .copy,
            fraction: 1.0,
            respectFlipped: true,
            hints: nil
        )
        targetImage.unlockFocus()
        return targetImage
    }
}

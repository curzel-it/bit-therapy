import Schwifty
import SwiftUI
import Yage
import YageLive

class EntityView: NSImageView {
    private let entity: Entity
    private let assetsProvider: AssetsProvider
    private var imageCache: [Int: NSImage] = [:]
    private var windowLocationOnLastDrag: CGPoint = .zero
    private var windowLocationOnMouseDown: CGPoint = .zero
    private var lastSpriteHash: Int = 0
    
    init(representing entity: Entity, assetsProvider: AssetsProvider) {
        self.assetsProvider = assetsProvider
        self.entity = entity
        super.init(frame: CGRect(size: entity.frame.size))
        translatesAutoresizingMaskIntoConstraints = false
        imageScaling = .scaleProportionallyUpOrDown
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func onEntityUpdated() {
        let hash = entity.spriteHash()
        if needsSpriteUpdate(for: hash) {
            let newImage = nextImage(for: hash)
            
            if let angle = entity.rotation?.z, angle != 0 {
                var transform = CATransform3DIdentity
                transform = CATransform3DTranslate(transform, bounds.midX, bounds.midY, 0)
                transform = CATransform3DRotate(transform, angle, 0, 0, 1)
                transform = CATransform3DTranslate(transform, -bounds.midX, -bounds.midY, 0)
                layer?.transform = transform
            } else {
                layer?.transform = CATransform3DIdentity
            }
            image = newImage
        }
    }
    
    private func nextImage(for hash: Int) -> NSImage? {
        if let cached = imageCache[hash] { return cached }
        guard let image = interpolatedImageForCurrentSprite() else { return nil }
        imageCache[hash] = image
        return image
    }
    
    private func interpolatedImageForCurrentSprite() -> NSImage? {
        assetsProvider
            .image(sprite: entity.sprite)?
            .scaledDown(to: entity.frame.size)
            .flipped(
                horizontally: entity.rotation?.isFlippedHorizontally ?? false,
                vertically: entity.rotation?.isFlippedVertically ?? false
            )
    }
    
    private func needsSpriteUpdate(for newHash: Int) -> Bool {
        if newHash != lastSpriteHash {
            lastSpriteHash = newHash
            return true
        }
        return false
    }
    
    override func draw(_ rect: NSRect) {
        NSGraphicsContext.current?.cgContext.interpolationQuality = .none
        super.draw(rect)
    }
    
    // MARK: - Mouse Drag
    
    override func mouseDown(with event: NSEvent) {
        guard let window else { return }
        windowLocationOnLastDrag = window.frame.origin
        windowLocationOnMouseDown = window.frame.origin
    }

    override func mouseDragged(with event: NSEvent) {
        entity.mouseDrag?.mouseDragged()
        let newOrigin = windowLocationOnLastDrag.offset(x: event.deltaX, y: -event.deltaY)
        window?.setFrameOrigin(newOrigin)
        windowLocationOnLastDrag = newOrigin
    }

    override func mouseUp(with event: NSEvent) {
        let delta = CGPoint(
            x: windowLocationOnLastDrag.x - windowLocationOnMouseDown.x,
            y: -(windowLocationOnLastDrag.y - windowLocationOnMouseDown.y)
        )
        
        Logger.log(
            entity.id,
            "Moved from", windowLocationOnMouseDown.description,
            "to", windowLocationOnLastDrag.description,
            "delta is", delta.description
        )
        entity.mouseDrag?.mouseUp(translation: delta)
    }

    // MARK: - Right Click

    override func rightMouseUp(with event: NSEvent) {
        entity.rightClick?.onRightClick(with: event)
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

// MARK: - Image Flip

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
    
    func scaledDown(to newSize: CGSize) -> NSImage {
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

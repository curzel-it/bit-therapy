import PetsAssets
import Schwifty
import SwiftUI
import Yage
import YageLive

class EntityView: NSImageView {
    let entity: Entity

    private var lastWindowLocation: CGPoint = .zero
    private var lastSpriteHash: Int = 0
    private var lastScreen: NSScreen?

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

    func onEntityUpdated() {
        if needsSpriteUpdate() {
            let newImage = PetsAssetsProvider.shared
                .image(sprite: entity.sprite)?
                .flipped(
                    horizontally: entity.rotation?.isFlippedHorizontally ?? false,
                    vertically: entity.rotation?.isFlippedVertically ?? false
                )
            
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
    
    private func needsSpriteUpdate() -> Bool {
        let newHash = entity.spriteHash()
        guard newHash != lastSpriteHash else { return false }
        lastSpriteHash = newHash
        return true
    }
    
    override func draw(_ rect: NSRect) {
        NSGraphicsContext.current?.cgContext.interpolationQuality = .none
        super.draw(rect)
    }
    
    // MARK: - Mouse Drag
    
    override func mouseDown(with event: NSEvent) {
        guard let window else { return }
        lastWindowLocation = window.frame.origin
        lastScreen = window.screen
    }

    override func mouseDragged(with event: NSEvent) {
        entity.mouseDrag?.mouseDragged()
        let newOrigin = lastWindowLocation.offset(x: event.deltaX, y: -event.deltaY)
        window?.setFrameOrigin(newOrigin)
        lastWindowLocation = newOrigin
    }

    override func mouseUp(with event: NSEvent) {
        guard let window else { return }
        let adjustedPosition = window.frame.origin
            .offset(x: -(window.screen?.frame.origin.x ?? 0))
            .offset(y: -(window.screen?.frame.origin.y ?? 0))
        entity.mouseDrag?.mouseUp(at: adjustedPosition)
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
}

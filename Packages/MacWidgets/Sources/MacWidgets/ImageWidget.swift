import AppKit
import Combine
import SwiftUI

public extension ImageWidget {
    func content() -> NSView {
        ImageWidgetView(representing: self)
    }
}

// MARK: - Image View

public class ImageWidgetView<T: ImageWidget>: NSImageView {
    private let widget: T
    private var lastMouseUp: TimeInterval = .zero
    private var windowLocationOnLastDrag: CGPoint = .zero
    private var windowLocationOnMouseDown: CGPoint = .zero
    private var interpolationMode: NSImageInterpolation = .default
    private var interpolationQuality: CGInterpolationQuality = .default
    private let isMouseDragEnabled: Bool
    private var cachedImages: [Int: NSImage] = [:]
    private var disposables = Set<AnyCancellable>()
    
    private var doubleClickDelegate: DoubleClickable? { widget as? DoubleClickable }
    private var mouseDragDelegate: MouseDraggable? { widget as? MouseDraggable }
    private var rightClickDelegate: RightClickable? { widget as? RightClickable }
    
    public init(representing widget: T) {
        self.widget = widget
        self.isMouseDragEnabled = widget is MouseDraggable
        super.init(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        translatesAutoresizingMaskIntoConstraints = false
        imageScaling = .scaleProportionallyUpOrDown
        enablePixelArtIfNeeded()
        bindFrame()
        bindImage()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func enablePixelArtIfNeeded() {
        if widget is PixelArtWidget {
            interpolationMode = .none
            interpolationQuality = .none
        }
    }
    
    private func bindFrame() {
        widget.windowFrame()
            .removeDuplicates()
            .filter { $0 != .zero }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newFrame in self?.frame = newFrame }
            .store(in: &disposables)
    }
    
    public override func draw(_ rect: NSRect) {
        NSGraphicsContext.current?.cgContext.interpolationQuality = interpolationQuality
        super.draw(rect)
    }
    
    // MARK: - Mouse Drag
    
    public override func mouseDown(with event: NSEvent) {
        guard isMouseDragEnabled, let window else { return }
        windowLocationOnLastDrag = window.frame.origin
        windowLocationOnMouseDown = window.frame.origin
    }
    
    public override func mouseDragged(with event: NSEvent) {
        guard isMouseDragEnabled else { return }
        let newOrigin = windowLocationOnLastDrag.offset(x: event.deltaX, y: -event.deltaY)
        window?.setFrameOrigin(newOrigin)
        windowLocationOnLastDrag = newOrigin
        mouseDragDelegate?.mouseDragged(to: newOrigin, delta: currentMouseDragDelta())
    }
    
    public override func mouseUp(with event: NSEvent) {
        handleDoubleClickIfPossible()
        guard isMouseDragEnabled else { return }
        guard let newOrigin = window?.frame.origin else { return }
        mouseDragDelegate?.mouseDragEnded(at: newOrigin, delta: currentMouseDragDelta())
    }
    
    private func currentMouseDragDelta() -> CGSize {
        CGSize(
            width: windowLocationOnLastDrag.x - windowLocationOnMouseDown.x,
            height: windowLocationOnMouseDown.y - windowLocationOnLastDrag.y
        )
    }
    
    // MARK: - Right Click
    
    public override func rightMouseUp(with event: NSEvent) {
        rightClickDelegate?.rightClicked(with: event)
    }
    
    // MARK: - Double Click
    
    func handleDoubleClickIfPossible() {
        let now = Date().timeIntervalSince1970
        if now - lastMouseUp < 250 {
            doubleClickDelegate?.doubleClicked()
        }
        lastMouseUp = now
    }
    
    // MARK: - Image Manipulation
    
    func bindImage() {
        Publishers.CombineLatest(widget.asset(), widget.windowFrame())
            .map { FramedAsset(asset: $0, frame: $1) }
            .filter { $0.frame != .zero }
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newAsset in
                guard let self else { return }
                self.layer?.transform = newAsset.layerTransform()
                self.image = self.cachedImage(for: newAsset)
            }
            .store(in: &disposables)
    }
    
    private func cachedImage(for newAsset: FramedAsset) -> NSImage? {
        if let cached = cachedImages[newAsset.hash] { return cached }
        let image = newAsset.manipulatedImage(interpolation: interpolationMode)
        cachedImages[newAsset.hash] = image
        return image
    }
}

private struct FramedAsset: Equatable {
    let asset: Asset
    let frame: CGRect
    let hash: Int
    
    init(asset: Asset, frame: CGRect) {
        self.asset = asset
        self.frame = frame
        
        var hasher = Hasher()
        hasher.combine(frame.size.width)
        hasher.combine(frame.size.height)
        hasher.combine(asset.id)
        hasher.combine(asset.flipVertically)
        hasher.combine(asset.flipHorizontally)
        hasher.combine(asset.zAngle ?? 0)
        self.hash = hasher.finalize()
    }
    
    func layerTransform() -> CATransform3D {
        if let angle = asset.zAngle, angle != 0 {
            var transform = CATransform3DIdentity
            transform = CATransform3DTranslate(transform, frame.bounds.midX, frame.bounds.midY, 0)
            transform = CATransform3DRotate(transform, angle, 0, 0, 1)
            transform = CATransform3DTranslate(transform, -frame.bounds.midX, -frame.bounds.midY, 0)
            return transform
        } else {
            return CATransform3DIdentity
        }
    }
    
    func manipulatedImage(interpolation: NSImageInterpolation) -> NSImage? {
        asset.image?
            .scaled(
                to: frame.bounds.size,
                interpolation: interpolation
            )
            .flipped(
                horizontally: asset.flipHorizontally,
                vertically: asset.flipVertically,
                interpolation: interpolation
            )
    }
    
    static func == (lhs: FramedAsset, rhs: FramedAsset) -> Bool {
        lhs.hash == rhs.hash
    }
}

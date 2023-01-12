import AppKit

extension NSImage {
    func flipped(
        horizontally: Bool = false,
        vertically: Bool = false,
        interpolation: NSImageInterpolation = .default
    ) -> NSImage {
        let flippedImage = NSImage(size: size)
        let rect = CGRect(size: size)
        flippedImage.lockFocus()
        NSGraphicsContext.current?.imageInterpolation = interpolation

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
    
    func scaled(
        to newSize: CGSize,
        interpolation: NSImageInterpolation = .default
    ) -> NSImage {
        guard size != newSize else { return self }
        let targetImage = NSImage.init(size: newSize)
        targetImage.lockFocus()
        NSGraphicsContext.current?.imageInterpolation = interpolation
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

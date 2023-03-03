import AppKit

extension NSImage {
    func rotated(by radians: CGFloat?) -> NSImage {
        guard let radians, radians != 0 else { return self }
        var imageBounds: CGRect = .zero
        imageBounds.size = self.size
        let pathBounds = NSBezierPath(rect: imageBounds)
        var transform = NSAffineTransform()
        transform.rotate(byRadians: radians)
        pathBounds.transform(using: transform as AffineTransform)
        let rotatedBounds = CGRect(origin: .zero, size: pathBounds.bounds.size)
        let rotatedImage = NSImage(size: rotatedBounds.size)
        
        imageBounds.origin.x = rotatedBounds.midX - imageBounds.width/2
        imageBounds.origin.y = rotatedBounds.midY - imageBounds.height/2
        
        transform = NSAffineTransform()
        transform.translateX(by: rotatedBounds.width/2, yBy: rotatedBounds.height/2)
        transform.rotate(byRadians: radians)
        transform.translateX(by: -rotatedBounds.width/2, yBy: -rotatedBounds.height/2)
        
        rotatedImage.lockFocus()
        transform.concat()
        self.draw(in: imageBounds, from: .zero, operation: .copy, fraction: 1.0)
        rotatedImage.unlockFocus()
        
        return rotatedImage
    }
    
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
    
    func scaled(to newSize: CGSize, with interpolation: ImageInterpolationMode) -> NSImage {
        guard size != newSize else { return self }
        let targetImage = NSImage.init(size: newSize)
        targetImage.lockFocus()
        NSGraphicsContext.current?.imageInterpolation = interpolation.nsImageInterpolation
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

extension ImageInterpolationMode {
    var nsImageInterpolation: NSImageInterpolation {
        switch self {
        case .default: return .default
        case .none: return .none
        }
    }
}

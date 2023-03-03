import AppKit
import Foundation

class ImageInterpolationUseCase {
    func interpolationMode(
        for image: NSImage,
        renderingSize: CGSize,
        screenScale scale: CGFloat
    ) -> NSImageInterpolation {
        let pixelCount = Int(scale * renderingSize.height)
        let imageHeight = Int(image.size.height)
        if pixelCount % imageHeight == 0 { return .none }
        if pixelCount >= 2 * imageHeight { return .none }
        return .default
    }
}

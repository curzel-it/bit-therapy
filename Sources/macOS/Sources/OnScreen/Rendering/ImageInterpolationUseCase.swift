import Foundation
import NotAGif

enum ImageInterpolationMode {
    case none
    case `default`
}

class ImageInterpolationUseCase {
    func interpolationMode(
        for image: ImageFrame,
        renderingSize: CGSize,
        screenScale scale: CGFloat
    ) -> ImageInterpolationMode {
        let pixelCount = Int(scale * renderingSize.height)
        let imageHeight = Int(image.size.height)
        if pixelCount % imageHeight == 0 { return .none }
        if pixelCount >= 2 * imageHeight { return .none }
        return .default
    }
}

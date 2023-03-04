import Foundation
import NotAGif
import SwiftUI

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
        if pixelCount >= Int(1.5 * Double(imageHeight)) { return .none }
        return .default
    }
}

extension Image {
    func interpolation(_ mode: ImageInterpolationMode) -> some View {
        switch mode {
        case .default: return interpolation(Interpolation.high)
        case .none: return interpolation(Interpolation.none)
        }
    }
}

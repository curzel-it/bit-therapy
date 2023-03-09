import SwiftUI
import UIKit

extension UIImage {
    func rotated(by radians: CGFloat?) -> UIImage {
        guard let radians, radians != 0 else { return self }
        let rotatedViewBox = UIView(frame: CGRect(origin: CGPoint.zero, size: size))
        let transform = CGAffineTransform(rotationAngle: radians)
        rotatedViewBox.transform = transform
        let rotatedSize = rotatedViewBox.frame.size
        
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap = UIGraphicsGetCurrentContext()!
        
        bitmap.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        bitmap.rotate(by: radians)
        
        let origin = CGPoint(x: -size.width / 2, y: -size.height / 2)
        bitmap.draw(cgImage!, in: CGRect(origin: origin, size: size))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func flipped(horizontally: Bool = false, vertically: Bool = false) -> UIImage {
        guard let cgImage = cgImage else { return self }
        guard horizontally || vertically else { return self }
        
        let flippedCGImage: CGImage
        let width = CGFloat(cgImage.width)
        let height = CGFloat(cgImage.height)
        let transform: CGAffineTransform
        
        if horizontally && vertically {
            transform = CGAffineTransform(translationX: width, y: height).rotated(by: CGFloat.pi)
        } else if horizontally {
            transform = CGAffineTransform(translationX: width, y: 0).scaledBy(x: -1, y: 1)
        } else {
            transform = CGAffineTransform(translationX: 0, y: height).scaledBy(x: 1, y: -1)
        }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = cgImage.bitmapInfo.rawValue
        let cgContext = CGContext(
            data: nil, width: Int(width), height: Int(height),
            bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0,
            space: colorSpace, bitmapInfo: bitmapInfo
        )
        guard let context = cgContext else { return self }
        context.concatenate(transform)
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        flippedCGImage = context.makeImage()!
        
        return UIImage(
            cgImage: flippedCGImage,
            scale: scale,
            orientation: imageOrientation
        )
    }
    
    func scaled(to newSize: CGSize, with interpolation: ImageInterpolationMode) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return self }
        context.interpolationQuality = interpolation.quality
        draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext() ?? self
        UIGraphicsEndImageContext()
        return newImage
    }
}

extension ImageInterpolationMode {
    var quality: CGInterpolationQuality {
        switch self {
        case .default: return .default
        case .none: return .none
        }
    }
}

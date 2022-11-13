import Schwifty
import SwiftUI

extension Text {
    public func title() -> some View {
        self
            .font(.largeTitle.bold())
            .textAlign(.leading)
    }
}

extension Font {
    public static let pixelBodySize: CGFloat = 13
    public static let pixelBody: Font = .custom("Dogica", size: pixelBodySize)
    public static let pixelTitle: Font = .custom("Dogica", size: pixelBodySize*2)
}

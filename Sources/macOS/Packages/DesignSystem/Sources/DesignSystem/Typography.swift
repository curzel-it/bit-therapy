import Schwifty
import SwiftUI

public extension Text {
    func title() -> some View {
        font(.largeTitle.bold())
            .textAlign(.leading)
    }
}

public extension Font {
    static let pixelBodySize: CGFloat = 13
    static let pixelBody: Font = .custom("Dogica", size: pixelBodySize)
    static let pixelTitle: Font = .custom("Dogica", size: pixelBodySize * 2)
}

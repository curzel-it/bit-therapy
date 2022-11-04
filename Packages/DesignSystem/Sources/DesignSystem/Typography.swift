import Schwifty
import SwiftUI

extension Text {
    public func title() -> some View {
        self
            .font(.largeTitle.bold())
            .textAlign(.leading)
    }
}

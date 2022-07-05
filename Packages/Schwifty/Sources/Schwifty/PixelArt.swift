//
// Pet Therapy.
//

import SwiftUI

extension Image {
    
    public func pixelArt() -> some View {
        self
            .interpolation(.none)
            .resizable()
            .aspectRatio(contentMode: .fill)
    }
}

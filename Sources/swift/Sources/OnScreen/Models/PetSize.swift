import Schwifty
import SwiftUI

struct PetSize {
    static let defaultSize: CGFloat = DeviceRequirement.iPhone.isSatisfied ? 50 : 75
    static let minSize: CGFloat = 25
    static let maxSize: CGFloat = 350
}

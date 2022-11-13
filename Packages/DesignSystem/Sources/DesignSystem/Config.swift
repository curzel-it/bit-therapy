import Schwifty
import SwiftUI

// MARK: - Constants

public struct DesignSystem {
    public static let defaultCornerRadius: CGFloat = DeviceRequirement.iOS.isSatisfied ? 8 : 4
    public static let buttonsHeight: CGFloat = DeviceRequirement.iOS.isSatisfied ? 40 : 32
    public static let textFieldsHeight: CGFloat = 32
    public static let buttonsMaxWidth: CGFloat? = DeviceRequirement.iPhone.isSatisfied ? nil : 200
    public static let lineWidth: CGFloat = 2
}

// MARK: - Pet Size

public struct PetSize {
    public static let defaultSize: CGFloat = 75
    public static let minSize: CGFloat = 50
    public static let maxSize: CGFloat = 100
}

import Schwifty
import SwiftUI

struct DesignSystem {
    static let largeCornerRadius: CGFloat = 16
    static let lineWidth: CGFloat = 2
    
    static var buttonsCornerRadius: CGFloat = {
        DeviceRequirement.macOS.isSatisfied ? 4 : 8
    }()
    
    static var tagsHeight: CGFloat = {
        DeviceRequirement.iOS.isSatisfied ? 32 : 28
    }()
    
    static var buttonsHeight: CGFloat = {
        DeviceRequirement.iOS.isSatisfied ? 48 : 32
    }()
    
    static let textFieldsHeight: CGFloat = {
        DeviceRequirement.iOS.isSatisfied ? 40 : 32
    }()
}

import Schwifty
import SwiftUI

struct DesignSystem {
    static let defaultCornerRadius: CGFloat = 4
    static let largeCornerRadius: CGFloat = 16
    static let lineWidth: CGFloat = 2
    
    static var tagsHeight: CGFloat = {
        DeviceRequirement.iOS.isSatisfied ? 32 : 28
    }()
    
    static var buttonsHeight: CGFloat = {
        DeviceRequirement.iOS.isSatisfied ? 40 : 32
    }()
    
    static let textFieldsHeight: CGFloat = {
        DeviceRequirement.iOS.isSatisfied ? 40 : 32
    }()
    
    static let buttonsMaxWidth: CGFloat? = {
        #if os(macOS)
        let isLandscape = false
        #else
        let isLandscape = UIDevice.current.orientation.isLandscape
        #endif
        
        let isPhone = DeviceRequirement.iPhone.isSatisfied
        return isLandscape || !isPhone ? 200 : nil
    }()
}

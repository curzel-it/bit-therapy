import SwiftUI

extension Color {
    static var accent: Color { Color("AccentColor") }
    
#if os(macOS)
    static var background: Color { Color(NSColor.windowBackgroundColor) }
    static var secondaryBackground: Color { Color(NSColor.controlBackgroundColor) }
    static var success: Color { Color(NSColor.systemGreen) }
    static var error: Color { Color(NSColor.systemRed) }
    static var warning: Color { Color(NSColor.systemOrange) }
    static var label: Color { Color(NSColor.labelColor) }
    static var secondaryLabel: Color { Color(NSColor.secondaryLabelColor) }
    static var tertiaryLabel: Color { Color(NSColor.tertiaryLabelColor) }
#else
    static var background: Color { Color(uiColor: UIColor.systemBackground) }
    static var secondaryBackground: Color { Color(uiColor: UIColor.secondarySystemBackground) }
    static var success: Color { Color(uiColor: UIColor.systemGreen) }
    static var error: Color { Color(uiColor: UIColor.systemRed) }
    static var warning: Color { Color(uiColor: UIColor.systemOrange) }
    static var label: Color { Color(uiColor: UIColor.label) }
    static var secondaryLabel: Color { Color(uiColor: UIColor.secondaryLabel) }
    static var tertiaryLabel: Color { Color(uiColor: UIColor.tertiaryLabel) }
#endif
}

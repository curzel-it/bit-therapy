import SwiftUI

extension Color {
    static var accent: Color { Color("AccentColor") }
    static var background: Color { Color(NSColor.windowBackgroundColor) }
    static var secondaryBackground: Color { Color(NSColor.controlBackgroundColor) }
    static var success: Color { Color(NSColor.systemGreen) }
    static var error: Color { Color(NSColor.systemRed) }
    static var warning: Color { Color(NSColor.systemOrange) }
    static var label: Color { Color(NSColor.labelColor) }
    static var secondaryLabel: Color { Color(NSColor.secondaryLabelColor) }
    static var tertiaryLabel: Color { Color(NSColor.tertiaryLabelColor) }
}

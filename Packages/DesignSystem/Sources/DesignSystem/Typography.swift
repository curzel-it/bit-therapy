//
// Pet Therapy.
//

import Foundation
import SwiftUI

public struct Typography {
    
    public static let baseFontName = "Dogica"
    public static let lineSpacingToFontSizeRatio = 0.8
    
    public enum Size: CGFloat, CaseIterable {
        case icon = 21
        case title = 23
        case xl = 18
        case lg = 13
        case md = 12
        case sm = 10
        case xs = 9
    }
    
    public enum Weight: String, CaseIterable {
        case bold = "_Pixel_Bold"
        case regular = "_Pixel"
        case monospaced = ""
    }
}

// MARK: - View Extension

extension View {
    
    public func font(
        _ weight: Typography.Weight = .regular,
        _ size: Typography.Size = .md
    ) -> some View {
        modifier(
            TypographyMod(
                config: TypographyConfig(
                    size: size,
                    weight: weight
                )
            )
        )
        .lineSpacing(size.rawValue * Typography.lineSpacingToFontSizeRatio)
    }
}

// MARK: - View Modifier

struct TypographyMod: ViewModifier {
    
    let config: TypographyConfig
    
    func body(content: Content) -> some View {
        content.font(config.font())
    }
}

// MARK: - Typography Config

struct TypographyConfig {
    
    let size: Typography.Size
    let weight: Typography.Weight
    
    var fontName: String {
        "\(Typography.baseFontName)\(weight.rawValue)"
    }
    
    func font() -> Font {
        .custom(fontName, size: size.rawValue, relativeTo: .headline)
    }
}

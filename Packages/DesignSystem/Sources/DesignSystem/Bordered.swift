import Foundation
import SwiftUI

public extension View {
    func bordered(
        color: Color = .label,
        cornerRadius: CGFloat = DesignSystem.defaultCornerRadius
    ) -> some View {
        modifier(
            BorderedMod(color: color, cornerRadius: cornerRadius)
        )
    }
}

private struct BorderedMod: ViewModifier {
    let color: Color
    let cornerRadius: CGFloat
    let lineWidth: CGFloat = 4

    func body(content: Content) -> some View {
        content
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(color, lineWidth: lineWidth)
            )
            .padding(lineWidth / 2)
    }
}

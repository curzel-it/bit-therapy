import Schwifty
import SwiftUI

enum CustomButtonStyle {
    case regular
    case text
}

extension View {
    func buttonStyle(_ style: CustomButtonStyle) -> some View {
        modifier(ButtonStyleMod(style: style))
    }
}

private struct ButtonStyleMod: ViewModifier {
    let style: CustomButtonStyle
    
    func body(content: Content) -> some View {
        switch style {
        case .regular: content.buttonStyle(RegularButton())
        case .text: content.buttonStyle(TextButton())
        }
    }
}

// MARK: - Regular

private struct RegularButton: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .modifier(BaseButton())
            .background(Color.accent)
            .foregroundColor(.white)
            .cornerRadius(DesignSystem.buttonsCornerRadius)
            .opacity(configuration.isPressed ? 0.5 : 1)
    }
}

// MARK: - Text

private struct TextButton: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .modifier(BaseButton())
            .foregroundColor(.accent)
            .opacity(configuration.isPressed ? 0.5 : 1)
    }
}

// MARK: - Base Style

private struct BaseButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .textCase(.uppercase)
            .font(.headline)
            .frame(height: DesignSystem.buttonsHeight)
            .padding(.horizontal, .md)
            .positioned(when: .is(.iPhone), align: .horizontalCenter)
    }
}

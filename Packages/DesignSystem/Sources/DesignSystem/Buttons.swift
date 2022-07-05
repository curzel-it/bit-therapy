//
// Pet Therapy.
//

import SwiftUI

public enum CustomButtonStyle {
    case regular
    case outlined
    case text
}

extension View {
    
    public func buttonStyle(_ style: CustomButtonStyle) -> some View {
        modifier(ButtonStyleMod(style: style))
    }
}

private struct ButtonStyleMod: ViewModifier {
    
    let style: CustomButtonStyle
    
    func body(content: Content) -> some View {
        switch style {
        case .regular: content.buttonStyle(RegularButton())
        case .text: content.buttonStyle(TextButton())
        case .outlined: content.buttonStyle(OutlinedButton())
        }
    }
}

// MARK: - Regular

private struct RegularButton: ButtonStyle {
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .modifier(BaseButton())
            .background(Color.label)
            .foregroundColor(.background)
            .cornerRadius(DesignSystem.defaultCornerRadius)
            .opacity(configuration.isPressed ? 0.5 : 1)
    }
}

// MARK: - Outlined

private struct OutlinedButton: ButtonStyle {
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .modifier(BaseButton())
            .foregroundColor(.label)
            .background(Color.clear)
            .cornerRadius(DesignSystem.defaultCornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.defaultCornerRadius)
                    .stroke(Color.label, lineWidth: DesignSystem.lineWidth)
            )
            .padding(DesignSystem.lineWidth/2)
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
            .font(.bold, .md)
            .frame(height: DesignSystem.buttonsHeight)
            .padding(.horizontal, .md)
    }
}

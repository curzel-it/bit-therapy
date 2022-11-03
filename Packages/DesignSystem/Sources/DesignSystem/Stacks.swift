import SwiftUI

extension VStack {
    @inlinable public init(
        alignment: HorizontalAlignment,
        spacing: Spacing,
        @ViewBuilder content: () -> Content
    ) {
        self.init(
            alignment: alignment,
            spacing: spacing.rawValue,
            content: content
        )
    }
    
    @inlinable public init(
        spacing: Spacing,
        @ViewBuilder content: () -> Content
    ) {
        self.init(
            spacing: spacing.rawValue,
            content: content
        )
    }
}

extension HStack {    
    @inlinable public init(
        alignment: VerticalAlignment,
        spacing: Spacing,
        @ViewBuilder content: () -> Content
    ) {
        self.init(
            alignment: alignment,
            spacing: spacing.rawValue,
            content: content
        )
    }
    
    @inlinable public init(
        spacing: Spacing,
        @ViewBuilder content: () -> Content
    ) {
        self.init(
            spacing: spacing.rawValue,
            content: content
        )
    }
}

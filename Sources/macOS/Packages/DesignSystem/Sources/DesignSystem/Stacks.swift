import SwiftUI

public extension VStack {
    @inlinable init(
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

    @inlinable init(
        spacing: Spacing,
        @ViewBuilder content: () -> Content
    ) {
        self.init(
            spacing: spacing.rawValue,
            content: content
        )
    }
}

public extension HStack {
    @inlinable init(
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

    @inlinable init(
        spacing: Spacing,
        @ViewBuilder content: () -> Content
    ) {
        self.init(
            spacing: spacing.rawValue,
            content: content
        )
    }
}

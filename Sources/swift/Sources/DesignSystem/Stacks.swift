import SwiftUI

extension VStack {
    init(alignment: HorizontalAlignment, spacing: Spacing, @ViewBuilder content: () -> Content) {
        self.init(
            alignment: alignment,
            spacing: spacing.rawValue,
            content: content
        )
    }

    init(spacing: Spacing, @ViewBuilder content: () -> Content) {
        self.init(
            spacing: spacing.rawValue,
            content: content
        )
    }
}

extension HStack {
    init(alignment: VerticalAlignment, spacing: Spacing, @ViewBuilder content: () -> Content) {
        self.init(
            alignment: alignment,
            spacing: spacing.rawValue,
            content: content
        )
    }

    init(spacing: Spacing, @ViewBuilder content: () -> Content) {
        self.init(
            spacing: spacing.rawValue,
            content: content
        )
    }
}

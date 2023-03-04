import Schwifty
import SwiftUI

protocol TabSelectable: Hashable, CustomStringConvertible {
    // ...
}

struct TabSelector<T: TabSelectable>: View {
    @Binding private var selection: T

    private let spacing: Spacing
    private let options: [T]

    init(selection: Binding<T>, options: [T], spacing: Spacing = .md) {
        _selection = selection
        self.spacing = spacing
        self.options = options
    }

    var body: some View {
        HStack(spacing: spacing) {
            ForEach(options, id: \.self) { option in
                TabSelectorItem(selection: $selection, value: option)
            }
            Spacer()
        }
    }
}

private struct TabSelectorItem<T: TabSelectable>: View {
    @Binding var selection: T

    let value: T
    var isSelected: Bool { value == selection }
    var fgColor: Color { isSelected ? .label : .labelTertiary }
    let font: Font = .title.bold()

    var body: some View {
        Text(value.description)
            .font(font)
            .foregroundColor(fgColor)
            .padding(.vertical, .md)
            .padding(.horizontal, .md)
            .onTapGesture {
                withAnimation {
                    selection = value
                }
            }
    }
}

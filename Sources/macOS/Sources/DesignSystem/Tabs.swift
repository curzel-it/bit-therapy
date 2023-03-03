import Schwifty
import SwiftUI

protocol Tabbable: Hashable, CustomStringConvertible {
    // ...
}

struct TabSelector<T: Tabbable>: View {
    @Binding var selection: T

    let spacing: Spacing
    let options: [T]

    init(selection: Binding<T>, options: [T], spacing: Spacing = .md) {
        _selection = selection
        self.spacing = spacing
        self.options = options
    }

    var body: some View {
        HStack(spacing: spacing) {
            ForEach(options, id: \.self) { option in
                TabItem(selection: $selection, value: option)
            }
            Spacer()
        }
    }
}

struct TabItem<T: Tabbable>: View {
    @Binding var selection: T

    let value: T
    var isSelected: Bool { value == selection }
    var fgColor: Color { isSelected ? .label : .tertiaryLabel }
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

import SwiftUI
import Schwifty

public protocol Tabbable: Hashable, CustomStringConvertible {
    // ...
}

public struct TabSelector<T: Tabbable>: View {
    
    @Binding var selection: T
    
    let spacing: Spacing
    let options: [T]
    
    public init(selection: Binding<T>, options: [T], spacing: Spacing = .md) {
        self._selection = selection
        self.spacing = spacing
        self.options = options
    }
    
    public var body: some View {
        HStack(spacing: spacing) {
            ForEach(options, id: \.self) { option in
                TabItem(selection: $selection, value: option)
            }
        }
    }
}

struct TabItem<T: Tabbable>: View {
    
    @Binding var selection: T
    
    let value: T
    
    var isSelected: Bool { value == selection }
    var fgColor: Color { isSelected ? .accent : .secondaryLabel }
    var fontSize: Typography.Size { isSelected ? .xl : .md }
    var fontWeight: Typography.Weight { isSelected ? .bold : .regular }
    
    var body: some View {
        Text(value.description)
            .font(fontWeight, fontSize)
            .foregroundColor(fgColor)
            .padding(.vertical, .md)
            .padding(.horizontal, .md)
            .tappableOnInvisibleAreas()
            .onTapGesture {
                withAnimation {
                    selection = value
                }
            }
    }
}

import Schwifty
import SwiftUI

protocol TabBarItem: Hashable {
    var icon: String { get }
    var iconSelected: String { get }
    var title: String { get }
}

struct TabBar<T: TabBarItem>: View {
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
                TabBarItemView(selection: $selection, item: option)
            }
        }
        .padding(.horizontal, .sm)
        .backgroundBlur()
        .cornerRadius(DesignSystem.largeCornerRadius)
        .positioned(.bottom)
    }
}

private struct TabBarItemView<T: TabBarItem>: View {
    @Binding var selection: T

    let item: T
    var icon: String { isSelected ? item.iconSelected : item.icon }
    var isSelected: Bool { item == selection }
    var fgColor: Color { isSelected ? .accent : .labelSecondary }
    
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: icon).font(.title2)
            Text(item.title)
                .font(.tabBarItem)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.8)
            Spacer()
        }
        .foregroundColor(fgColor)
        .frame(width: 64)
        .frame(height: 56)
        .onTapGesture {
            withAnimation {
                selection = item
            }
        }
    }
}

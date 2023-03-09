import Schwifty
import SwiftUI

protocol TabBarItem: Hashable {
    var icon: String { get }
    var iconSelected: String { get }
    var title: String { get }
}

struct TabBar<T: TabBarItem>: View {
    @Binding private var selection: T

    private let options: [T]

    init(selection: Binding<T>, options: [T]) {
        _selection = selection
        self.options = options
    }

    var body: some View {
        HStack(spacing: .zero) {
            ForEach(options, id: \.self) { option in
                TabBarItemView(selection: $selection, item: option)
            }
        }
        .tabBarBlurBackground()
        .cornerRadius(DesignSystem.largeCornerRadius)
        .positioned(.bottom)
        .padding(when: .is(.macOS), .bottom, .lg)
    }
}

private struct TabBarItemView<T: TabBarItem>: View {
    @Binding var selection: T

    let item: T
    var icon: String { isSelected ? item.iconSelected : item.icon }
    var isSelected: Bool { item == selection }
    var fgColor: Color { isSelected ? .accent : .labelSecondary }
    
    var bgColor: Color {
        let opacity = DeviceRequirement.macOS.isSatisfied ? 0.8 : 0.05
        return .background.opacity(opacity)
    }
    
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
        .frame(width: 60)
        .frame(height: 60)
        .padding(.horizontal, .sm)
        .background(bgColor)
        .onTapGesture {
            withAnimation {
                selection = item
            }
        }
    }
}

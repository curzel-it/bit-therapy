import Schwifty
import SwiftUI

protocol TabBarItem: Hashable {
    var accessibilityIdentifier: String { get }
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
    
    private var icon: String { isSelected ? item.iconSelected : item.icon }
    private var isSelected: Bool { item == selection }
    private var fgColor: Color { isSelected ? .accent : .labelSecondary }
    
    private var bgColor: Color {
        let opacity = DeviceRequirement.macOS.isSatisfied ? 0.8 : 0.05
        return .background.opacity(opacity)
    }
    
    private var width: CGFloat {
        DeviceRequirement.macOS.isSatisfied ? 72 : 60
    }
    
    private var height: CGFloat {
        DeviceRequirement.macOS.isSatisfied ? 62 : 60
    }
    
    private var font: Font {
        let size: CGFloat = DeviceRequirement.macOS.isSatisfied ? 12 : 10
        return .system(size: size, weight: .light)
    }
    
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: icon).font(.title2)
            Text(item.title)
                .font(font)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.8)
                .accessibilityIdentifier(item.accessibilityIdentifier)
            Spacer()
        }
        .foregroundColor(fgColor)
        .frame(width: width)
        .frame(height: height)
        .padding(.horizontal, .sm)
        .background(bgColor)
        .onTapGesture {
            withAnimation {
                selection = item
            }
        }
    }
}

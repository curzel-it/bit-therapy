import DesignSystem
import Schwifty
import SwiftUI

public struct Dialog: View {
    @StateObject var viewModel: DialogViewModel
    
    public init(contents: [MessageContent]) {
        let vm = DialogViewModel(contents: contents)
        self._viewModel = StateObject(wrappedValue: vm)
    }
    
    public var body: some View {
        VStack {
            Spacer()
            ContentView()
            Spacer()
            ControlsView()
        }
        .frame(maxWidth: viewModel.maxWidth)
        .environmentObject(viewModel)
    }
}

private struct ContentView: View {
    @EnvironmentObject var viewModel: DialogViewModel
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack(spacing: viewModel.styler.contentSpacing) {
                    ForEach(viewModel.contents) {
                        ContentPiece(content: $0.content)
                    }
                }
                .offset(y: viewModel.textOffsetY)
            }
            .scrollDisabled(true)
            .onAppear { viewModel.setup(width: geo.size.width) }
        }
        .frame(height: viewModel.textHeight)
        .padding(.horizontal, .md)
        .background(viewModel.styler.backgroundColor)
        .bordered(color: viewModel.styler.foregrondColor)
        .onTapGesture {
            if viewModel.canShowNext {
                viewModel.next()
            }
        }
    }
}

private struct ContentPiece: View {
    let content: MessageContent
    
    var body: some View {
        switch content {
        case .textInput(let placeholder, let value):
            TextInput(placeholder: placeholder, value: value)
        case .text(let text):
            MessageText(text: text)
        case .action(let title, let action):
            DialogAction(title: title, action: action)
        case .singleChoice(let options, let onSelection):
            SingleChoice(options: options, onSelection: onSelection)
        }
    }
}

private struct ControlsView: View {
    @EnvironmentObject var viewModel: DialogViewModel
    
    var body: some View {
        ZStack {
            GameBoyButton(icon: ">", condition: viewModel.canShowNext, action: viewModel.next)
                .positioned(.trailingTop)
            GameBoyButton(icon: "<", condition: viewModel.canShowPrevious, action: viewModel.previous)
                .positioned(.leadingBottom)
        }
        .frame(width: GameBoyButton.size * 1.8)
        .frame(height: GameBoyButton.size * 2.4)
        .positioned(.trailing)
    }
}

private struct GameBoyButton: View {
    static let size: CGFloat = DesignSystem.buttonsHeight * 1.2
    @EnvironmentObject var viewModel: DialogViewModel
    
    let icon: String
    let condition: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(icon)
                .font(viewModel.styler.titleFont)
                .foregroundColor(viewModel.styler.backgroundColor)
                .padding(.top, 4)
        }
        .frame(width: GameBoyButton.size)
        .frame(height: GameBoyButton.size)
        .background(viewModel.styler.foregrondColor)
        .cornerRadius(GameBoyButton.size / 2)
        .opacity(condition ? 0.9 : 0.5)
        .disabled(!condition)
    }
}

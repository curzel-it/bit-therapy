import Combine
import DesignSystem
import SwiftUI

struct TextInput: View {
    @EnvironmentObject var messageViewModel: DialogViewModel
    @StateObject private var viewModel: TextViewModel

    init(placeholder: String, value: Binding<String>) {
        let vm = TextViewModel(placeholder: placeholder, value: value)
        _viewModel = StateObject(wrappedValue: vm)
    }

    var body: some View {
        TextField("", text: $viewModel.value, prompt: Text(viewModel.placeholder))
            .textFieldStyle(.plain)
            .foregroundColor(viewModel.styler.foregrondColor)
            .font(viewModel.styler.font)
            .padding(.sm)
            .frame(height: DesignSystem.buttonsHeight)
            .bordered(color: viewModel.styler.foregrondColor)
            .environmentObject(viewModel)
    }
}

class TextViewModel: ObservableObject {
    @Binding private var actualValue: String
    @Published var editState: EditState = .empty
    @Published var value: String
    @Published var showPlaceholder: Bool = true

    let placeholder: String
    let styler: Styler = .init()
    private var valueCanc: AnyCancellable!

    init(placeholder: String, value: Binding<String>) {
        _actualValue = value
        self.value = value.wrappedValue
        self.placeholder = placeholder
        editState = .given(self.value, false)

        valueCanc = $value.sink { value in
            self.updatePlaceholderState(actualValue: value)
            Task { @MainActor in
                self.actualValue = value
            }
        }
    }

    func onEditingChanged(didBegin: Bool) {
        updatePlaceholderState()
    }

    func updatePlaceholderState(actualValue: String? = nil) {
        Task { @MainActor in
            withAnimation {
                self.showPlaceholder = (actualValue ?? value).isEmpty
            }
        }
    }
}

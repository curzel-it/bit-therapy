import Combine
import DesignSystem
import Schwifty
import SwiftUI

struct CheatsView: View {
    
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        VStack(spacing: .sm) {
            Text(Lang.Cheats.title).font(.headline).textAlign(.leading)
            HStack(spacing: .md) {
                TextField(Lang.Cheats.placeholder, text: $viewModel.text)
                    .frame(width: 350)
                    .frame(height: 40)
                    .textFieldStyle(.roundedBorder)
                
                if !viewModel.text.isEmpty {
                    Button("Enable", action: viewModel.enableCurrent)
                        .buttonStyle(.regular)
                }
                if let error = viewModel.error {
                    Text(error).foregroundColor(.error)
                }
                if let info = viewModel.info {
                    Text(info).foregroundColor(.success)
                }
                Spacer()
            }
        }
    }
}

private class ViewModel: ObservableObject {
    @Published var text: String = ""
    @Published var info: String?
    @Published var error: String?
    
    var cleanedCode: String {
        text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func enableCurrent() {
        if Cheats.enableCheat(code: cleanedCode) {
            showValidCode()
        } else {
            showInvalidCode()
        }
    }
    
    private func showValidCode() {
        withAnimation {
            info = Lang.Cheats.validCode
            text = ""
            error = nil
        }
    }
    
    private func showInvalidCode() {
        withAnimation {
            info = nil
            error = Lang.Cheats.invalidCode
        }
    }
    
    func clear() {
        Cheats.clear()
    }
}

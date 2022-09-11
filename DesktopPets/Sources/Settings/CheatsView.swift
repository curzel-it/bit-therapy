import AppState
import Combine
import DesignSystem
import Lang
import Squanch
import SwiftUI

struct CheatsView: View {
    
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        VStack(spacing: .sm) {
            Text(Lang.Cheats.title).font(.headline).textAlign(.leading)
            HStack(spacing: .md) {
                TextField(Lang.Cheats.placeholder, text: $viewModel.text)
                    .frame(width: 250)
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
    
    func enableCurrent() {
        if let cheat = Cheats.enableCheat(code: text) {
            cheat.enable()
            withAnimation {
                info = Lang.Cheats.validCode
                text = ""
                error = nil
            }
        } else {
            withAnimation {
                info = nil
                error = Lang.Cheats.invalidCode
            }
        }
    }
    
    func clear() {
        Cheats.clear()
    }
}

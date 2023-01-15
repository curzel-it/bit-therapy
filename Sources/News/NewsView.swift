import DesignSystem
import LaunchAtLogin
import Schwifty
import SwiftUI

struct NewsView: View {
    @EnvironmentObject var appState: AppState
    @AppStorage("didShowStartAtLoginAlert1") var didShowStartAtLoginAlert1 = false
    @AppStorage("didShowStartAtLoginAlert2") var didShowStartAtLoginAlert2 = false
    @AppStorage("didShowStartAtLoginAlert3") var didShowStartAtLoginAlert3 = false
    @AppStorage("didShowStartAtLoginAlert4") var didShowStartAtLoginAlert4 = false
    
    var body: some View {
        VStack(spacing: .md) {
            NewsBanner(
                title: Lang.Settings.launchAtLogin,
                message: Lang.Settings.launchAtLoginPromo,
                shown: $didShowStartAtLoginAlert4,
                actions: [
                    .init(title: Lang.no, style: .text),
                    .init(title: Lang.yes, style: .regular) {
                        LaunchAtLogin.isEnabled = true
                    }
                ]
            )
        }
    }
}

private struct NewsBannerAction: Identifiable {
    let id = UUID().uuidString
    let title: String
    let style: CustomButtonStyle
    var action: () -> Void = {}
}

private struct NewsBanner: View {
    let title: String
    let message: String
    @Binding var shown: Bool
    let actions: [NewsBannerAction]
    
    var body: some View {
        HStack {
            VStack(spacing: .md) {
                Text(title).font(.headline).textAlign(.leading)
                Text(message).textAlign(.leading)
            }
            Spacer()
            Actions(actions: actions, onSelection: close)
        }
        .padding()
        .background(Color.secondaryBackground)
        .cornerRadius(DesignSystem.largeCornerRadius)
    }
    
    func close() {
        withAnimation {
            shown = false
        }
    }
}

private struct Actions: View {
    let actions: [NewsBannerAction]
    let onSelection: () -> Void
    
    var body: some View {
        ForEach(actions) { action in
            Button(action.title) {
                action.action()
                onSelection()
            }
            .buttonStyle(action.style)
        }
    }
}

import LaunchAtLogin
import Schwifty
import SwiftUI

struct ScreensOnOffSettings: View {
    @State var isOn = true
    
    var body: some View {
        VStack {
            Text(Lang.Settings.enabledDisplays).font(.title3.bold()).textAlign(.leading)
            ForEach(Screen.screens) {
                ScreenSwitch(screen: $0).positioned(.leading)
            }
        }
        .positioned(.leading)
    }
}

private struct ScreenSwitch: View {
    @StateObject var viewModel: ViewModel
    
    init(screen: Screen) {
        _viewModel = StateObject(wrappedValue: ViewModel(screen: screen))
    }
    
    var body: some View {
        Toggle(viewModel.screen.localizedName, isOn: $viewModel.isEnabled)
    }
}

private class ViewModel: ObservableObject {
    @Inject private var appConfig: AppConfig
    @Inject private var onScreen: OnScreenCoordinator
    
    let screen: Screen
    
    @Published var isEnabled: Bool {
        didSet {
            appConfig.set(screen: screen, enabled: isEnabled)
            onScreen.show()
        }
    }
    
    init(screen: Screen) {
        @Inject var appConfig: AppConfig
        self.screen = screen
        self.isEnabled = appConfig.isEnabled(screen: screen)
    }
}

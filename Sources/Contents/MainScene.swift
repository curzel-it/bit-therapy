import DesignSystem
import LaunchAtLogin
import Schwifty
import SwiftUI

struct MainScene: Scene {
    fileprivate static weak var currentWindow: NSWindow?
    fileprivate static let minSize = CGSize(square: 700)
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onWindow {
                    MainScene.currentWindow = $0
                }
        }
    }
}

extension MainScene {
    static func show() {
        if let window = MainScene.currentWindow {
            window.makeKey()
            window.makeMain()
        } else {
            showMainWindow()
        }
        trackAppLaunched()
    }

    private static func showMainWindow() {
        let view = NSHostingView(rootView: ContentView())
        let window = NSWindow(
            contentRect: CGRect(origin: CGPoint(x: 400, y: 200), size: MainScene.minSize),
            styleMask: [.resizable, .closable, .titled, .miniaturizable],
            backing: .buffered,
            defer: false
        )
        window.minSize = MainScene.minSize
        window.title = "Desktop Pets"
        window.contentView?.addSubview(view)
        view.constrainToFillParent()
        MainScene.currentWindow = window
        window.show()
    }

    private static func trackAppLaunched() {
        let appState = AppState.global
        Tracking.didLaunchApp(
            gravityEnabled: appState.gravityEnabled,
            petSize: appState.petSize,
            launchAtLogin: LaunchAtLogin.isEnabled,
            selectedSpecies: appState.selectedSpecies
        )
    }
}

private struct ContentView: View {
    @StateObject var appState = AppState.global
    @StateObject var viewModel = MainViewModel()

    var body: some View {
        VStack(spacing: .zero) {
            Header()
            PageContents()
            Spacer(minLength: 0)
        }
        .frame(minWidth: MainScene.minSize.width)
        .frame(minHeight: MainScene.minSize.height)
        .foregroundColor(.label)
        .environmentObject(viewModel)
        .environmentObject(appState)
    }
}

class MainViewModel: ObservableObject {
    @Published public var selectedPage: AppPage = .home
}

extension AppPage: Tabbable {}

private struct Header: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var viewModel: MainViewModel

    let options: [AppPage] = [.home, .settings, .about]

    var body: some View {
        HStack {
            TabSelector(selection: $viewModel.selectedPage, options: options)
            JoinOurDiscord()
        }
    }
}

private struct PageContents: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var viewModel: MainViewModel

    var body: some View {
        switch viewModel.selectedPage {
        case .about: AboutView()
        case .home: PetsSelectionView()
        case .settings: SettingsView()
        case .none: EmptyView()
        }
    }
}

private struct PageTitle: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var viewModel: MainViewModel

    var body: some View {
        Text(viewModel.selectedPage.description)
            .textAlign(.center)
            .font(.largeTitle)
            .padding()
    }
}

private struct JoinOurDiscord: View {
    var body: some View {
        Image("discordLarge")
            .resizable()
            .antialiased(true)
            .frame(width: 115, height: 28)
            .cornerRadius(DesignSystem.defaultCornerRadius)
            .padding(.trailing, .md)
            .onTapGesture { URL.visit(urlString: Lang.Urls.discord) }
    }
}

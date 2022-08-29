import AppState
import DesignSystem
import Lang
import OnWindow
import Schwifty
import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(spacing: .zero) {
            Header()
            PageContents()
            Spacer(minLength: 0)
        }
        .frame(minWidth: 600)
        .frame(minHeight: 600)
        .foregroundColor(.label)
        .environmentObject(AppState.global)
    }
}

extension AppPage: CustomStringConvertible, Tabbable {
    
    public var description: String {
        switch self {
        case .home: return Lang.Page.home
        case .settings: return Lang.Page.settings
        case .about: return Lang.Page.about
        }
    }
}

private struct Header: View {
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        TabSelector(
            selection: $appState.selectedPage,
            options: AppPage.allCases
        )
    }
}

private struct PageContents: View {
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        switch appState.selectedPage {
        case .home: Homepage()
        case .settings: SettingsView()
        case .about: AboutView()
        }
    }
}

private struct PageTitle: View {
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Text(appState.selectedPage.description)
            .textAlign(.center)
            .font(.largeTitle)
            .padding()
    }
}

// 
// Pet Therapy.
//

import DesignSystem
import SwiftUI
import Schwifty

struct MainView: View {
    
    var body: some View {
        VStack(spacing: .lg) {
            Header()
            PageContents()
                .positioned(.middle)
        }
        .padding(.md)
        .frame(minWidth: 600)
        .frame(minHeight: 600)
        .foregroundColor(.label)
        .font(.regular, .md)
        .environmentObject(AppState.global)
        .onAppear { Tracking.didLaunchApp() }
    }
}

extension AppPage: Tabbable {
    
    var description: String { title }
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
        case .home: PetSelection()
        case .settings: SettingsView()
        case .about: AboutView()
        }
    }
}

private struct PageTitle: View {
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Text(appState.selectedPage.title)
            .textAlign(.center)
            .font(.bold, .title)
            .padding()
    }
}

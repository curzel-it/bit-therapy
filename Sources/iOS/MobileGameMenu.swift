import DesignSystem
import Schwifty
import SwiftUI

struct GameMenu: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel = MenuViewModel()
    
    var body: some View {
        ZStack {
            if viewModel.showingOptions {
                VStack {
                    MenuItemView(page: .home)
                    MenuItemView(page: .settings)
                    MenuItemView(page: .about)
                }
                .frame(width: 160)
                .padding(.lg)
                .background(Color.secondaryBackground)
                .cornerRadius(20)
                .shadow(radius: 8)
                .padding(.lg)
            } else {
                MenuButton()
            }
        }
        .padding(.md)
        .positioned(.trailingTop)
        .sheet(
            isPresented: binding { viewModel.selectedPage != .none },
            onDismiss: viewModel.close
        ) {
            switch viewModel.selectedPage {
            case .about: AboutView()
            case .home: PetsSelectionCoordinator.view()
            case .settings: SettingsView()
            case .game, .none: EmptyView()
            }
        }
        .environmentObject(viewModel)
    }
}

private class MenuViewModel: ObservableObject {
    @Published var showingOptions = false
    @Published var selectedPage: AppPage = .none
    
    func open() {
        withAnimation {
            showingOptions = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation {
                self.showingOptions = false
            }
        }
    }
    
    func close() {
        withAnimation {
            if selectedPage != .none {
                selectedPage = .none
            } else {
                showingOptions = false
            }
        }
    }
}

private struct MenuButton: View {
    @EnvironmentObject var viewModel: MenuViewModel
    
    var body: some View {
        Button { viewModel.open() } label: {
            Image(systemName: "circle.grid.2x1.fill")
                .padding()
        }
    }
}

private struct MenuItemView: View {
    @EnvironmentObject var viewModel: MenuViewModel
    
    let page: AppPage
    
    var body: some View {
        Button {
            viewModel.selectedPage = page
        } label: {
            HStack {
                Image(systemName: page.icon)
                Text(page.description)
                Spacer()
            }
            .frame(height: DesignSystem.buttonsHeight)
        }
    }
}

private func binding<T>(_ getter: @escaping () -> T) -> Binding <T> {
    Binding(get: getter, set: { _, _ in })
}

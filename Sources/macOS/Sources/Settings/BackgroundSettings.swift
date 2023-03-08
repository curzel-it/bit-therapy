import Schwifty
import SwiftUI

struct BackgroundSettings: View {
    @StateObject private var viewModel = BackgroundsViewModel()
    
    var body: some View {
        VStack {
            Text(Lang.Backgrounds.title).font(.headline).textAlign(.leading)
            ForEach(viewModel.backgrounds, id: \.self) {
                BackgroundSettingsItem(item: $0)
            }
        }
        .environmentObject(viewModel)
    }
}

private class BackgroundsViewModel: ObservableObject {
    @Published private(set) var selectedItem = AppState.global.background
    
    let backgrounds: [String] = [
        "BackgroundMountainDynamic",
        "BackgroundMountainDay",
        "BackgroundMountainNight"
    ]
    
    func title(for item: String) -> String {
        "backgrounds.\(item)".localized()
    }
    
    func select(_ item: String) {
        withAnimation {
            AppState.global.background = item
            selectedItem = item
        }
    }
}

private struct BackgroundSettingsItem: View {
    @EnvironmentObject var viewModel: BackgroundsViewModel
    
    let item: String
    
    var body: some View {
        HStack {
            Text(viewModel.title(for: item))
            Spacer()
            if viewModel.selectedItem == item {
                Image(systemName: "circle.fill")
                    .foregroundColor(.accent)
                    .font(.title2)
            } else {
                Image(systemName: "circle")
                    .foregroundColor(.label)
                    .font(.title2)
            }
        }
        .padding(.vertical, .sm)
        .onTapGesture {
            viewModel.select(item)
        }
    }
}


import DesignSystem
import Lang
import Squanch
import SwiftUI

struct SurveyLink: View {
    
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        if let url = viewModel.url {
            VStack(spacing: .md) {
                Text(Lang.Survey.surveyExplained)
                Button(Lang.Survey.takeSurvey) { NSWorkspace.shared.open(url) }
                    .buttonStyle(.regular)
            }
        }
    }
}

private class ViewModel: ObservableObject {
    
    @Published var url: URL?
    
    init() {
        Task {
            if let settings = await SettingsApi.get() {
                Task { @MainActor in
                    url = settings.survey
                }
            }
        }
    }
}

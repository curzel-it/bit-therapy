import DesignSystem
import Lang
import Squanch
import SwiftUI

struct RequestPetsViaSurvey: View {
    
    var body: some View {
        SurveyLink(
            title: Lang.Survey.takeSurvey,
            message: Lang.Survey.requestPetViaSurvey
        )
    }
}

struct GiveFeedbackViaSurvey: View {
    
    var body: some View {
        SurveyLink(
            title: Lang.Survey.takeSurvey,
            message: Lang.Survey.feedbackViaSurvey
        )
    }
}

private struct SurveyLink: View {
    
    @StateObject private var viewModel = ViewModel()
    
    let title: String
    let message: String
    
    var body: some View {
        if let url = viewModel.url {
            VStack(spacing: .md) {
                Text(message)
                Button(title) { NSWorkspace.shared.open(url) }
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

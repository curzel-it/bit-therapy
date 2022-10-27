import DesignSystem
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
    let title: String
    let message: String
    
    var body: some View {
        if let url = Lang.Survey.url {
            VStack(spacing: .md) {
                Text(message)
                Button(title) { NSWorkspace.shared.open(url) }
                    .buttonStyle(.regular)
            }
        }
    }
}

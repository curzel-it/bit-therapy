import DesignSystem
import Schwifty
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
        VStack(spacing: .md) {
            Text(message)
            Button(title) { URL.visit(urlString: Lang.Survey.url) }
                .buttonStyle(.regular)
        }
    }
}

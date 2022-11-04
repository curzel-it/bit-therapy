import DesignSystem
import Schwifty
import SwiftUI

struct AboutView: View {        
    var body: some View {
        ScrollView {
            VStack(spacing: .xl) {
                if DeviceRequirement.iOS.isSatisfied {
                    Text(Lang.Page.about).title()
                }                
                LeaveReview()
                GiveFeedbackViaSurvey()
                PrivacyPolicy().padding(.top, .xl)
                
                VStack(spacing: .xl) {
                    Socials().padding(.top, .lg)
                    Text(appVersion)
                }
                .positioned(.bottom)
            }
            .multilineTextAlignment(.center)
            .padding(.md)
        }
    }
    
    var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        return "v. \(version ?? "n/a")"
    }
}

struct PrivacyPolicy: View {
    var body: some View {
        Button(Lang.About.privacyPolicy) {
            URL.visit(urlString: Lang.Urls.privacy)
        }
        .buttonStyle(.regular)
    }
}

private struct Socials: View {
    var body: some View {
        HStack(spacing: .xl) {
            SocialIcon(name: "github", link: Lang.Urls.github)
            SocialIcon(name: "twitter", link: Lang.Urls.twitter)
            SocialIcon(name: "reddit", link: Lang.Urls.reddit)
            SocialIcon(name: "discord", link: Lang.Urls.discord)
        }
    }
}

private struct SocialIcon: View {
    let name: String
    let link: String
    
    var body: some View {
        Image(name)
            .resizable()
            .antialiased(true)
            .frame(width: 32, height: 32)
            .onTapGesture { URL.visit(urlString: link) }
    }
}

private struct LeaveReview: View {
    var body: some View {
        VStack(spacing: .md) {
            Text(Lang.About.leaveReviewMessage)
            Button(Lang.About.leaveReview) {
                URL.visit(urlString: Lang.Urls.appStore)
            }
            .buttonStyle(.regular)
        }
    }
}


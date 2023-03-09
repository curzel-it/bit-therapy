import Schwifty
import SwiftUI

struct AboutView: View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: .xl) {
                PageTitle(text: Lang.Page.about)
                LeaveReview().padding(.top, .xl)
                if DeviceRequirement.iOS.isSatisfied {
                    DiscordView()
                }
                DonationsView().padding(.bottom, .xl)
                Socials()
                PrivacyPolicy()
                AppVersion()
            }
            .multilineTextAlignment(.center)
            .padding(.md)
            .padding(.bottom, .xxxxl)
        }
    }
}

private struct AppVersion: View {
    @EnvironmentObject var appConfig: AppConfig
        
    var text: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let dev = isDevApp ? "Dev" : ""
        return ["v.", version ?? "n/a", dev]
            .filter { !$0.isEmpty }.joined(separator: " ")
    }
    
    var isDevApp: Bool {
        let bundle = Bundle.main.bundleIdentifier ?? ""
        return bundle.contains(".dev")
    }
    
    var body: some View {
        Text(text)
    }
}

private struct PrivacyPolicy: View {
    var body: some View {
        Button(Lang.About.privacyPolicy) {
            URL.visit(urlString: Lang.Urls.privacy)
        }
        .buttonStyle(.text)
    }
}

private struct Socials: View {
    var body: some View {
        HStack(spacing: .xl) {
            SocialIcon(name: "github", link: Lang.Urls.github)
            SocialIcon(name: "twitter", link: Lang.Urls.twitter)
            SocialIcon(name: "reddit", link: Lang.Urls.reddit)
            SocialIcon(name: "discord", link: Lang.Urls.discord)
            // SocialIcon(name: "patreon", link: Lang.Urls.donations)
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
                .multilineTextAlignment(.center)
            Button(Lang.About.leaveReview) {
                URL.visit(urlString: Lang.Urls.appStore)
            }
            .buttonStyle(.regular)
        }
    }
}

private struct DonationsView: View {
    var body: some View {
        VStack(spacing: .md) {
            Text(Lang.Donations.title).font(.title3.bold())
            Text(Lang.Donations.message)
        }
    }
}

private struct DiscordView: View {
    var body: some View {
        VStack(spacing: .md) {
            Text(Lang.PetSelection.joinDiscord)
            JoinOurDiscord()
        }
    }
}

struct JoinOurDiscord: View {
    var body: some View {
        Image("discordLarge")
            .resizable()
            .antialiased(true)
            .scaledToFit()
            .frame(when: .is(.macOS), width: 115, height: 28)
            .frame(when: .is(.iOS), height: DesignSystem.buttonsHeight)
            .positioned(when: .is(.iOS), align: .horizontalCenter)
            .background(Color("DiscordBrandColor"))
            .cornerRadius(DesignSystem.buttonsCornerRadius)
            .onTapGesture { URL.visit(urlString: Lang.Urls.discord) }
    }
}

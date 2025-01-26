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
                SneakBitView(centered: true)
                RestorePurchasesButton().padding(.vertical)
                Socials()
                PrivacyPolicy()
                TermsAndConditions()
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

private struct TermsAndConditions: View {
    var body: some View {
        Button(Lang.About.termsAndConditions) {
            URL.visit(urlString: Lang.Urls.termsAndConditions)
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
            SocialIcon(name: "youtube", link: Lang.Urls.youtube)
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
        Image("discordSquare")
            .resizable()
            .frame(height: 32)
            .frame(width: 32)
            .onTapGesture { URL.visit(urlString: Lang.Urls.discord) }
    }
}

struct SneakBitView: View {
    let centered: Bool
    
    let text = """
I made a videogame!
It's available for Windows, macOS, iOS, and Android.
Also, some of the characters of the game are now available in the app!

Check it out:
"""
    
    var body: some View {
        VStack {
            if centered {
                Text(text).multilineTextAlignment(.center)
                Image("sneakbit_logo_text")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 168)
                    .frame(height: 25)
            } else {
                Text(text).textAlign(.leading)
                HStack {
                    Image("sneakbit_logo_text")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 168)
                        .frame(height: 25)
                    Spacer()
                }
            }
        }
        .padding(.bottom, .xl)
        .onTapGesture {
            if DeviceRequirement.allSatisfied(.macOS) {
                URL.visit(urlString: "https://curzel.it/sneakbit")
            } else {
                URL.visit(urlString: "https://apps.apple.com/app/sneakbit/id6737452377")
            }
        }
    }
}

struct YouTubeQuick: View {
    var body: some View {
        Image("youtubeSquared")
            .resizable()
            .frame(height: 32)
            .frame(width: 32)
            .onTapGesture { URL.visit(urlString: Lang.Urls.youtube) }
    }
}

struct SneakBitQuick: View {
    var body: some View {
        Image("sneakbit")
            .resizable()
            .frame(height: 32)
            .frame(width: 32)
            .onTapGesture {
                if DeviceRequirement.allSatisfied(.macOS) {
                    URL.visit(urlString: "https://curzel.it/sneakbit")
                } else {
                    URL.visit(urlString: "https://apps.apple.com/app/sneakbit/id6737452377")
                }
            }
    }
}

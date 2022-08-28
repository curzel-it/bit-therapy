import DesignSystem
import Lang
import Squanch
import SwiftUI

private let github = "https://github.com/curzel-it/pet-therapy"
private let appStore = "https://apps.apple.com/app/desktop-pets/id1575542220"
private let twitter = "https://twitter.com/DesktopPets"
private let subReddit = "https://www.reddit.com/r/DesktopPets/"
private let mailto = "mailto:pets@curzel.it?subject=Desktop%20Pets&body=Hi%20Federico%2C%20"
private let privacy = "https://curzel.it/privacy.html"

struct AboutView: View {
        
    var body: some View {
        VStack(alignment: .center, spacing: .xl) {
            Section(
                message: Lang.About.leaveReviewMessage,
                linkTitle: Lang.About.leaveReview,
                link: appStore
            )
            Section(
                message: Lang.About.mailMessage,
                linkTitle: Lang.About.mail,
                link: mailto
            )            
            PrivacyPolicy().padding(.top, .xl)
            Socials().padding(.top, .lg)
            
            Text(appVersion)
        }
        .multilineTextAlignment(.center)
        .padding(.md)
    }
    
    var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        return "v. \(version ?? "n/a")"
    }
}

struct PrivacyPolicy: View {
    
    var body: some View {
        Button(Lang.About.privacyPolicy) {
            NSWorkspace.shared.open(urlString: privacy)
        }.buttonStyle(.regular)
    }
}

private struct Socials: View {
    
    var body: some View {
        HStack(spacing: .xl) {
            SocialIcon(name: "github", link: github).foregroundColor(.label)
            SocialIcon(name: "twitter", link: twitter)
            SocialIcon(name: "reddit", link: subReddit)
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
            .onTapGesture {
                NSWorkspace.shared.open(urlString: link)
            }
    }
}

private struct Section: View {
    
    let message: String
    let linkTitle: String
    let link: String
    
    var body: some View {
        VStack(spacing: .md) {
            Text(message)
            Button(linkTitle, action: openLink)
                .buttonStyle(.regular)
        }
    }
    
    func openLink() {
        NSWorkspace.shared.open(urlString: link)
    }
}


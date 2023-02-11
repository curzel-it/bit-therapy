import DependencyInjectionUtils
import Kingfisher
import SwiftUI

struct ContributorsView: View {
    @StateObject private var vm = ContributorsViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: .xl) {
                ForEach(vm.contributors) {
                    ItemView(contributor: $0)
                }
            }
            .padding(.top, .xl)
            .padding(.horizontal, .lg)
            .padding(.bottom, .xxl)
        }
        .environmentObject(vm)
    }
}

private struct ItemView: View {
    let contributor: Contributor
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                ProfilePic(url: contributor.pictureUrl).padding(.trailing, .lg)
                Text(contributor.name).font(.title2.bold()).padding(.trailing, .lg)
                ForEach(contributor.roles, id: \.self) {
                    RoleView(role: $0).padding(.trailing, .sm)
                }
                Spacer()
            }
            LazyVGrid(columns: [.init(.adaptive(minimum: 32, maximum: 200))]) {
                ForEach(contributor.pets, id: \.self) {
                    PetThumbnail(species: $0)
                }
                Spacer()
            }
        }
        .onTapGesture {
            if let url = URL(string: contributor.link ?? "") {
                NSWorkspace.shared.open(url)
            }
        }
    }
}

private struct PetThumbnail: View {
    @EnvironmentObject var vm: ContributorsViewModel
    
    let species: String
    
    var body: some View {
        if let asset = vm.thumbnail(for: species) {
            Image(nsImage: asset)
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
                .cornerRadius(16)
        }
    }
}

private struct ProfilePic: View {
    let url: URL?
    
    var body: some View {
        KFImage
            .url(url)
            .placeholder { _ in
                Image(systemName: "questionmark")
                    .font(.title)
                    .foregroundColor(.black.opacity(0.8))
            }
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 56, height: 56)
            .background(Color.white.opacity(0.4))
            .cornerRadius(28)
    }
}

private struct RoleView: View {
    let role: Role
    
    private var background: Color {
        role.isHightlighted ? .accent : .white.opacity(0.8)
    }
    
    private var foreground: Color {
        role.isHightlighted ? .white : .black.opacity(0.8)
    }
    
    var body: some View {
        Text(role.description)
            .font(.headline)
            .frame(height: 24)
            .padding(.horizontal, .md)
            .foregroundColor(foreground)
            .background(background)
            .cornerRadius(14)
    }
}

private class ContributorsViewModel: ObservableObject {
    @Inject private var assets: PetsAssetsProvider
    
    let contributors: [Contributor] = [
        Contributor(
            name: "Urinamara",
            roles: [.owner, .artist, .developer],
            link: "https://curzel.it/",
            thumbnail: "https://curzel.it/me64x64.png",
            pets: [
                "ape", "cat_grumpy", "cat_white", "frog", "frog_venom", "german", "mushroom_amanita",
                "mushroomwizard", "nyan", "poop", "sheep", "snail", "ufo"
            ]
        ),
        Contributor(
            name: "Jayped",
            roles: [.artist],
            link: "https://linktr.ee/Jayped",
            thumbnail: "https://github.com/curzel-it/pet-therapy/blob/main/docs/contributors/jayped.png?raw=true",
            pets: ["sloth", "crow", "crow_white", "koala", "panda", "betta"]
        ),
        Contributor(
            name: "Chaz",
            roles: [.artist],
            link: "https://twitter.com/chamorr__",
            thumbnail: "https://pbs.twimg.com/profile_images/1623168039733559297/xKz5s9b9_200x200.jpg",
            pets: ["jeansbear"]
        ),
        Contributor(
            name: "Curren",
            roles: [.artist],
            link: "https://curren.carrd.co/",
            thumbnail: "https://github.com/curzel-it/pet-therapy/blob/main/docs/contributors/curren.png?raw=true",
            pets: ["milo"]
        ),
        Contributor(
            name: "Anonymous D.",
            roles: [.artist],
            pets: ["trex", "trex_violet", "trex_blue", "trex_yellow", "cat", "cromulon", "cromulon_pink"]
        )
    ]
    
    func thumbnail(for species: String) -> NSImage? {
        assets.image(sprite: "\(species)_front-1")
    }
}

private struct Contributor: Identifiable {
    let name: String
    let roles: [Role]
    var link: String?
    var thumbnail: String?
    var pets: [String] = []
    
    var id: String { name }
    var pictureUrl: URL? { URL(string: thumbnail ?? "") }
}

private enum Role: String, CustomStringConvertible {
    case artist
    case developer
    case moderator
    case owner
    case patreon
    case translator
    
    var description: String {
        "contributors.\(rawValue)".localized().uppercased()
    }
    
    var isHightlighted: Bool {
        self == .owner || self == .patreon
    }
}

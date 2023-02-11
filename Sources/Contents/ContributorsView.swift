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
                ProfilePic(url: contributor.avatarUrl).padding(.trailing, .lg)
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
            .placeholder(placeholder)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 56, height: 56)
            .background(Color.white.opacity(0.4))
            .cornerRadius(28)
    }
    
    @ViewBuilder func placeholder(_: Progress) -> some View {
        Image(systemName: "questionmark")
            .font(.title)
            .foregroundColor(.black.opacity(0.8))
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
    
    var contributors: [Contributor] { Contributors.all }
    
    func thumbnail(for species: String) -> NSImage? {
        assets.image(sprite: "\(species)_front-1")
    }
}

private extension Contributor {
    var profileUrl: URL? { URL(string: link ?? "") }
    var avatarUrl: URL? { URL(string: thumbnail ?? "") }
}

extension Contributor: Identifiable {
    var id: String { name }
}

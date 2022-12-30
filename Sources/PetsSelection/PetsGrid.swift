import Combine
import DesignSystem
import Pets
import Schwifty
import SwiftUI
import Yage

// MARK: - Grid

struct PetsGrid: View {
    let title: String
    let columns: [GridItem]
    let species: [Species]

    var body: some View {
        VStack(spacing: .md) {
            Title(title: title)
            LazyVGrid(columns: columns, spacing: Spacing.xl.rawValue) {
                ForEach(species) {
                    ItemPreview(species: $0)
                }
            }
        }
    }
}

// MARK: - Item Preview

private struct ItemPreview: View {
    @EnvironmentObject var viewModel: PetsSelectionViewModel

    let species: Species

    var body: some View {
        if let frame = viewModel.image(for: species) {
            Image(frame: frame)
                .pixelArt()
                .frame(width: 80, height: 80)
                .onTapGesture { viewModel.showDetails(of: species) }
        }
    }
}

// MARK: - Grid Title

private struct Title: View {
    let title: String

    var body: some View {
        Text(title)
            .textAlign(.leading)
            .font(.title2, when: .macOS)
            .font(.title2.bold(), when: .iOS)
    }
}

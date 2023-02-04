import Combine
import DesignSystem
import Schwifty
import SwiftUI
import Yage

// MARK: - Grid

struct PetsGrid: View {
    let columns: [GridItem]
    let species: [Species]

    var body: some View {
        VStack(spacing: .md) {
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
    
    let size: CGFloat = 80
    let species: Species

    var body: some View {
        VStack {
            if let frame = viewModel.image(for: species) {
                Image(frame: frame)
                    .pixelArt()
                    .frame(width: size, height: size)
            }
            Text(species.name).multilineTextAlignment(.center)
        }
        .frame(width: size)
        .frame(minHeight: size)
        .onTapGesture { viewModel.showDetails(of: species) }
    }
}

// MARK: - Grid Title

private struct Title: View {
    let title: String

    var body: some View {
        Text(title)
            .textAlign(.leading)
            .font(.title2)
    }
}

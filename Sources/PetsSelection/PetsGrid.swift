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
                    PetPreview(species: $0)
                }
            }
        }
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

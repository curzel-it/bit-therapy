import Combine
import DesignSystem
import Pets
import SwiftUI

struct PetsGrid: View {
    
    let title: String
    let columns: [GridItem]
    let pets: [Pet]
    
    var body: some View {
        VStack(spacing: 0) {
            PetsGridTitle(title: title)
            LazyVGrid(columns: columns, spacing: Spacing.xl.rawValue) {
                ForEach(pets) {
                    PetsGridItem(pet: $0)
                }
            }
        }
    }
}

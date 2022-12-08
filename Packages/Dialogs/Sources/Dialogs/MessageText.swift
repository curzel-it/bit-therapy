import DesignSystem
import Schwifty
import SwiftUI

struct MessageText: View {
    @EnvironmentObject var viewModel: DialogViewModel

    let text: String

    var body: some View {
        Text(text).textAlign(.leading)
            .font(viewModel.styler.font)
            .lineSpacing(viewModel.styler.lineSpacing)
            .foregroundColor(viewModel.styler.foregrondColor)
    }
}

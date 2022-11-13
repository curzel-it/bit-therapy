import DesignSystem
import SwiftUI

struct DialogAction: View {
    @EnvironmentObject var viewModel: DialogViewModel
    
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(title, action: action)
            .font(viewModel.styler.font)
            .foregroundColor(viewModel.styler.backgroundColor)
            .padding(.horizontal, .md)
            .frame(height: DesignSystem.buttonsHeight)
            .background(viewModel.styler.foregrondColor)
            .cornerRadius(DesignSystem.defaultCornerRadius)
            .positioned(.trailing)
    }
}

struct SingleChoice: View {
    @EnvironmentObject var viewModel: DialogViewModel
    
    let options: [String]
    let onSelection: (Int, String) -> Void
    
    var body: some View {
        ForEach(Array(options.enumerated()), id: \.0.self) { (index, title) in
            DialogAction(title: title) {
                onSelection(index, title)
            }
        }
    }
}

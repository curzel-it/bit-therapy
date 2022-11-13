import Pets
import SwiftUI

public class Coordinator {
    public static func view(
        with settings: PetsSettings,
        initialSize size: CGSize,
        localizedContent lang: LocalizedContentProvider
    ) -> some View {
        let vm = ViewModel(
            with: settings,
            initialSize: size,
            localizedContent: lang
        )
        return GameView(viewModel: vm)
    }
}

// 
// Pet Therapy.
// 

import AppState
import Biosphere
import Combine
import Pets
import Schwifty
import SwiftUI

public struct OnScreen {
    
    private static var viewModel: ViewModel?
    
    public static func show() {
        hide()
        viewModel = ViewModel()
        spawnWindows()
    }
    
    public static func hide(animated: Bool = true) {
        viewModel?.kill(animated: animated)
        viewModel = nil
    }
    
    static func spawnWindows() {
        guard let viewModel = viewModel else { return }
        let windowsManager = WindowsManager(for: viewModel)
        viewModel.windowsManager = windowsManager
        viewModel.state.children
            .filter { $0.isDrawable }
            .forEach {
                windowsManager.showWindow(
                    representing: $0,
                    in: viewModel
                )
            }
    }
}

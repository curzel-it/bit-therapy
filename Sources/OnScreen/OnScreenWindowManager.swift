// 
// Pet Therapy.
// 

import AppState
import Biosphere
import Combine
import EntityWindow
import Pets
import Schwifty
import SwiftUI

struct OnScreen {
    
    private static var viewModel: OnScreenViewModel?
    
    static func show() {
        hide()
        viewModel = OnScreenViewModel()
        viewModel?.spawnWindows()
    }
    
    static func hide(animated: Bool = true) {
        viewModel?.kill(animated: animated)
        viewModel = nil
    }
}

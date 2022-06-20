// 
// Pet Therapy.
// 

import AppState
import Combine
import EntityWindow
import Pets
import Biosphere
import Schwifty
import SwiftUI
import PetEntity

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

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

struct FullScreen {
    
    private static var viewModel: FullScreenViewModel?
    
    static func show() {
        hide()
        viewModel = FullScreenViewModel()
        viewModel?.spawnWindow()
    }
    
    static func hide(animated: Bool = true) {
        viewModel?.kill(animated: animated)
        viewModel = nil
    }
}

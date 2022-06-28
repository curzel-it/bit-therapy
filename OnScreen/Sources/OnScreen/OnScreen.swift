// 
// Pet Therapy.
// 

import AppState
import Biosphere
import Combine
import EntityWindow
import HabitatWindows
import Pets
import Schwifty
import SwiftUI

public struct OnScreen {
    
    private static var viewModel: ViewModel?
    private static var habitatWindows: OnScreenWindows?
    
    public static func show() {
        hide()
        let viewModel = ViewModel()
        self.viewModel = viewModel
        self.habitatWindows = OnScreenWindows(
            for: viewModel,
            whenAllWindowsHaveBeenClosed: {
                OnScreen.hide(animated: false)
            }
        )
    }
    
    public static func hide(animated: Bool = true) {
        viewModel?.kill(animated: animated)
        viewModel = nil
        habitatWindows = nil
    }
}

class OnScreenWindows: HabitatWindows<HabitatViewModel> {
        
    override func newWindow(
        representing entity: Entity,
        in habitat: HabitatViewModel
    ) -> EntityWindow {
        if let pet = entity as? PetEntity {
            return PetWindow(representing: pet, in: habitat)
        } else {
            return super.newWindow(representing: entity, in: habitat)
        }
    }
}

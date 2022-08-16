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
import Squanch
import SwiftUI

public struct OnScreen {
    
    private static var viewModel: ViewModel?
    private static var habitatWindows: OnScreenWindows?
    private static var counter = 0
    
    public static func show() {
        hide()
        counter += 1
        printDebug("OnScreen", "Starting...")
        
        let viewModel = ViewModel()
        self.viewModel = viewModel
        self.habitatWindows = OnScreenWindows(
            id: "\(OnScreen.counter)",
            for: viewModel,
            whenAllWindowsHaveBeenClosed: {
                printDebug("OnScreen", "No more windows, terminating")
                OnScreen.hide(animated: false)
            }
        )
    }
    
    public static func hide(animated: Bool = true) {
        printDebug("OnScreen", "Hiding everything...")
        viewModel?.kill(animated: animated)
        viewModel = nil
        habitatWindows?.kill()
        habitatWindows = nil
    }
}

private class OnScreenWindows: HabitatWindows<LiveEnvironment> {
    
    override func newWindow(
        representing entity: Entity,
        in habitat: LiveEnvironment
    ) -> EntityWindow {
        if let pet = entity as? PetEntity {
            return PetWindow(representing: pet, in: habitat)
        } else {
            return super.newWindow(representing: entity, in: habitat)
        }
    }
}

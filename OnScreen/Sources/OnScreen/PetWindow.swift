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

class PetWindow: EntityWindow {
    
    private var sizeCanc: AnyCancellable!
    
    public override init(representing entity: Entity, in habitat: HabitatViewModel) {
        super.init(representing: entity, in: habitat)
        bindToSizeSettings()
    }
    
    func bindToSizeSettings() {
        sizeCanc = AppState.global.$petSize.sink { size in
            self.entity.set(size: CGSize(square: size))
        }
    }
    
    override func close() {
        sizeCanc?.cancel()
        sizeCanc = nil
        super.close()
    }
}

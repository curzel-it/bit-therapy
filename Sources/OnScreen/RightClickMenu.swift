// 
// Pet Therapy.
// 

import DesignSystem
import Schwifty
import SwiftUI

struct RightClickMenu: View {
    
    let afterClick: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: "gearshape.fill")
                .font(.regular, .xl)
                .onTapGesture {
                    MainWindow.show()
                    afterClick()
                }
            
            Image(systemName: "xmark")
                .font(.bold, .xl)
                .onTapGesture {
                    OnScreenWindow.hide()
                    afterClick()
                }
        }
    }
}

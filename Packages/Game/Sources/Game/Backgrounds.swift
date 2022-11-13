import Schwifty
import SwiftUI

struct Background: View {
    @State var orientation: String = "Landscape"
    
    var body: some View {
        Image("backgroundMountains\(orientation)")
            .pixelArt()
            .ignoresSafeArea()
    }
}

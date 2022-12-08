import Schwifty
import SwiftUI
import Yage

extension View {
    func draggable(_ entity: Entity) -> some View {
        func onDrag(_ newLocation: CGPoint) {
            let newPosition = newLocation.offset(
                x: -entity.frame.width,
                y: -entity.frame.height
            )
            entity.frame.origin = newPosition
        }
        return gesture(
            DragGesture()
                .onChanged { onDrag($0.location) }
                .onEnded { onDrag($0.location) }
        )
    }
}

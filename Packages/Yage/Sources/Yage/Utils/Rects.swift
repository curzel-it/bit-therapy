import SwiftUI

extension CGRect {
    var center: CGPoint { CGPoint(x: midX, y: midY) }
    var topLeft: CGPoint { origin }
    var centerTop: CGPoint { CGPoint(x: midX, y: minY) }
    var topRight: CGPoint { CGPoint(x: maxX, y: minY) }
    var bottomRight: CGPoint { CGPoint(x: maxX, y: maxY) }
    var centerBottom: CGPoint { CGPoint(x: midX, y: maxY) }
    var bottomLeft: CGPoint { CGPoint(x: minX, y: maxY) }
    var corners: [CGPoint] { [topLeft, topRight, bottomLeft, bottomRight] }
}

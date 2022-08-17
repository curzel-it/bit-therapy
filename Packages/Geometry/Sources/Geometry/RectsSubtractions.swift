//
// Pet Therapy.
//

import SwiftUI

extension CGRect {
    
    public func parts(bySubtracting other: CGRect) -> [CGRect] {
        [self]
            .flatMap { $0.split(x: other.minX) }
            .flatMap { $0.split(x: other.maxX) }
            .flatMap { $0.split(y: other.minY) }
            .flatMap { $0.split(y: other.maxY) }
            .filter { !other.contains($0) }
    }
    
    public func split(x: CGFloat) -> [CGRect] {
        guard x > minX else { return [self] }
        guard x < maxX else { return [self] }
        let left = CGRect(x: minX, y: minY, width: x-minX, height: height)
        let right = CGRect(x: x, y: minY, width: maxX-x, height: height)
        return [left, right]
    }
    
    public func split(y: CGFloat) -> [CGRect] {
        guard y > minY else { return [self] }
        guard y < maxY else { return [self] }
        let top = CGRect(x: minX, y: minY, width: width, height: y-minY)
        let bottom = CGRect(x: minX, y: y, width: width, height: maxY-y)
        return [top, bottom]
    }
}

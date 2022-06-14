//
// Pet Therapy.
//

import Foundation

extension Array {
    
    /// Returns a random element from the array according to the probabilities.
    public func randomElement(distribution: [Double]) -> Element? {
        guard self.count > 0 else { return nil }
        guard self.count == distribution.count else { return nil }
        let total = distribution.reduce(0, +)
        guard total > 0 else { return nil }        
        
        let rand = Double.random(in: 0..<total)

        var sum: Double = 0
        for index in 0..<self.count {
            sum += distribution[index]
            if rand < sum {
                return self[index]
            }
        }
        return nil
    }
}

//
// Pet Therapy.
//

import Foundation

extension Array where Element: Equatable {
    
    public func contains(anyOf values: [Element]) -> Bool {
        values.first { contains($0) } != nil
    }
    
    public func contains(allOf values: [Element]) -> Bool {
        values.first { !contains($0) } == nil
    }
}

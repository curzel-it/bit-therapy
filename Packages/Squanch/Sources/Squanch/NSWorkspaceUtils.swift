//
// Pet Therapy.
//

import AppKit

extension NSWorkspace {
    
    @discardableResult
    public func open(urlString someString: String?) -> Bool {
        guard let urlString = someString else { return false }
        guard let url = URL(string: urlString) else { return false }
        return open(url)
    }
}

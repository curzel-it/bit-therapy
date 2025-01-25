import Foundation
import Schwifty
import SwiftUI

class ImportDragAndDropPetUseCaseImpl: ImportDragAndDropPetUseCase {
    var supportedTypeId: String { "" }

    func isAvailable() -> Bool { false }
    func handleDrop(of items: [NSItemProvider], completion: @escaping (Species?, String?) -> Void) -> Bool {
        completion(nil, nil)
        return false
    }
}

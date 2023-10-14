import Foundation
import SwiftUI

class ExportPetUseCaseImpl: ExportPetUseCase {
    func export(item: Species, completion: @escaping (URL?) -> Void) {
        completion(nil)
    }
}

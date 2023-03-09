import Foundation
import Schwifty
import SwiftUI
import Swinject
import Yage

class DeletePetUseCaseImpl: DeletePetUseCase {
    @Inject private var resources: CustomPetsResourcesProvider
    
    private let tag = "DeletePetUseCase"
    
    func safelyDelete(item: Species) -> Bool {
        do {
            try delete(item)
            return true
        } catch let error {
            Logger.log(tag, "Could not delete: \(error)")
            return false
        }
    }
    
    private func delete(_ item: Species) throws {
        Logger.log(tag, "Deleting \(item.id)")
        try resources
            .allResources(for: item.id)
            .forEach {
                Logger.log(tag, "Deleting '\($0)'...")
                try FileManager.default.removeItem(at: $0)
            }
        Logger.log(tag, "Done!")
    }
}

import DependencyInjectionUtils
import Foundation
import Schwifty
import SwiftUI

public protocol DeletePetUseCase {
    func safelyDelete(item: Item) -> Bool
}

public class DeletePetUseCaseImpl: DeletePetUseCase {
    @Inject var resources: ResourcesProvider
    
    let tag = "DeletePetUseCase"
    
    public init() {}
    
    public func safelyDelete(item: Item) -> Bool {
        do {
            try delete(item)
            return true
        } catch let error {
            Logger.log(tag, "Could not delete: \(error)")
            return false
        }
    }
    
    private func delete(_ item: Item) throws {
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

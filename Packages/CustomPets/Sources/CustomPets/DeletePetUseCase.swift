import DependencyInjectionUtils
import Foundation
import Schwifty
import SwiftUI
import Yage

public protocol DeletePetUseCase {
    func safelyDelete(species: Species) -> Bool
}

public class DeletePetUseCaseImpl: DeletePetUseCase {
    @Inject var resources: ResourcesProvider
    
    let tag = "DeletePetUseCase"
    
    public init() {}
    
    public func safelyDelete(species: Species) -> Bool {
        do {
            try delete(species)
            return true
        } catch let error {
            Logger.log(tag, "Could not delete: \(error)")
            return false
        }
    }
    
    private func delete(_ species: Species) throws {
        Logger.log(tag, "Deleting \(species.id)")
        try resources
            .allResources(for: species.id)
            .forEach {
                Logger.log(tag, "Deleting '\($0)'...")
                try FileManager.default.removeItem(at: $0)
            }
        Logger.log(tag, "Done!")
    }
}

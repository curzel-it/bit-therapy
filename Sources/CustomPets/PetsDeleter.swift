import Foundation
import Schwifty
import SwiftUI
import Yage

struct DeletePetButton: View {
    @EnvironmentObject var appState: AppState
    
    let species: Species
    let completion: (Bool) -> Void
    
    var body: some View {
        if PetsDeleter.shared.canDelete(species) {
            Button(Lang.delete) {
                let deleted = PetsDeleter.shared.safeDelete(species)
                completion(deleted)
            }
            .buttonStyle(.text)
            .scaleEffect(0.8)
        }
    }
}

private class PetsDeleter {
    static let shared = PetsDeleter()
    
    func canDelete(_ species: Species) -> Bool {
        !species.isOriginal()
    }
    
    func safeDelete(_ species: Species) -> Bool {
        do {
            try PetsDeleter.shared.delete(species)
            PetsAssetsProvider.shared.reloadAssets()
            Species.unregister(species)
            return true
        } catch let error {
            Logger.log("Deleter", "Could not delete: \(error)")
            return false
        }
    }
    
    private func delete(_ species: Species) throws {
        Logger.log("Deleter", "Deleting \(species.id)")
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            Logger.log("Deleter", "Could not find documents folder")
            return
        }
        try FileManager.default
            .contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
            .filter { $0.lastPathComponent.hasPrefix(species.id) }
            .filter {
                let tokens = $0.lastPathComponent
                    .replacingOccurrences(of: "\(species.id)_", with: "")
                    .replacingOccurrences(of: ".json", with: "")
                    .replacingOccurrences(of: ".png", with: "")
                    .components(separatedBy: "_")
                return tokens.count <= 1
            }
            .forEach {
                try FileManager.default.removeItem(at: $0)
            }
        Logger.log("Deleter", "Done!")
    }
}

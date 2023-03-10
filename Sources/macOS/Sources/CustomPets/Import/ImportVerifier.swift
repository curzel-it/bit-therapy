import Combine
import Foundation
import Schwifty
import Swinject
import Yage

protocol ImportVerifier {
    func verify(json: URL, assets: [URL]) throws -> Species
}

class ImportVerifierImpl: ImportVerifier {
    @Inject private var speciesProvider: SpeciesProvider
    
    private var disposables = Set<AnyCancellable>()
    private let tag = "ImportVerifier"
    
    func verify(json: URL, assets: [URL]) throws -> Species {
        let species = try parseSpecies(from: json)
        try verify(species: species, with: assets)
        return species
    }
    
    func parseSpecies(from url: URL) throws -> Species {
        guard let jsonContents = try? Data(contentsOf: url) else {
            Logger.log(tag, "Could not read json file")
            throw ImporterError.invalidJsonFile
        }
        guard let species = try? JSONDecoder().decode(Species.self, from: jsonContents) else {
            Logger.log(tag, "Could not decode species")
            throw ImporterError.invalidJsonFile
        }
        Logger.log(tag, "Importing \(species.id)...")
        return species
    }
    
    private func verify(species: Species, with assetUrls: [URL]) throws {
        let assets = assetUrls.map { $0.lastPathComponent }
        if doesAlreadyExists(species: species) {
            throw ImporterError.itemAlreadyExists(item: species)
        }
        
        let movementPrefix = "\(species.id)_\(species.movementPath)"
        if !assets.contains(where: { $0.hasPrefix(movementPrefix) }) {
            throw ImporterError.missingAsset(name: movementPrefix)
        }
        
        let dragPrefix = "\(species.id)_\(species.dragPath)"
        if !assets.contains(where: { $0.hasPrefix(dragPrefix) }) {
            throw ImporterError.missingAsset(name: dragPrefix)
        }
    }
    
    private func doesAlreadyExists(species: Species) -> Bool {
        speciesProvider.doesExist(species.id)
    }
}

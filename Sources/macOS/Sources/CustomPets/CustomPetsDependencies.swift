import Foundation
import Swinject
import Yage

protocol CustomPetsResourcesProvider {
    func allResources(for itemId: String) -> [URL]
}

protocol ImportVerifier {
    func verify(json: URL, assets: [URL]) throws -> Species
}

class CustomPetsResourcesProviderImpl: CustomPetsResourcesProvider {
    @Inject private var assets: PetsAssetsProvider
    @Inject private var speciesProvider: SpeciesProvider
    
    func allResources(for speciesId: String) -> [URL] {
        guard let json = speciesProvider.jsonDefinition(for: speciesId) else { return [] }
        return [json] + assets.allAssets(for: speciesId)
    }
}

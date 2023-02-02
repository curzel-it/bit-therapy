import CustomPets
import DependencyInjectionUtils
import Foundation
import Yage

class CustomPetsResourcesProviderImpl: CustomPets.ResourcesProvider {
    @Inject var assets: PetsAssetsProvider
    
    func allResources(for speciesId: String) -> [URL] {
        guard let json = Species.jsonDefinition(for: speciesId) else { return [] }
        return [json] + assets.allAssets(for: speciesId)
    }
}

class CustomPetsLocalizedResourcesImpl: CustomPets.LocalizedResources {
    func string(for error: CustomPets.ImporterError) -> String {
        switch error {
        case .dropFailed:
            return Lang.CustomPets.genericImportError
        case .noJsonFile:
            return String(format: Lang.CustomPets.missingFiles, "<species>.json")
        case .missingAsset(let name):
            return String(format: Lang.CustomPets.missingFiles, name)
        case .invalidJsonFile:
            return Lang.CustomPets.invalidJson
        case .itemAlreadyExists(let species):
            return String(format: Lang.CustomPets.speciesAlreadyExists, species.id)
        case .genericError:
            return Lang.CustomPets.genericImportError
        }
    }
}

extension Species: CustomPets.Item {}

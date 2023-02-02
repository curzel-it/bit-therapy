import Foundation

public protocol ResourcesProvider {
    func allResources(for speciesId: String) -> [URL]
}

public protocol SpeciesProvider {
    func allExistingSpecies() -> [String]
}

public protocol LocalizedResources {
    func string(for: ImporterError) -> String
}

/*
 
 
 var localizedMessage: String {
     switch self {
     case ImporterError.dropFailed:
         return Lang.CustomPets.genericImportError
     case ImporterError.noJsonFile:
         return String(format: Lang.CustomPets.missingFiles, "<species>.json")
     case ImporterError.missingAsset(let name):
         return String(format: Lang.CustomPets.missingFiles, name)
     case ImporterError.invalidJsonFile:
         return Lang.CustomPets.invalidJson
     case ImporterError.speciesAlreadyExists(let species):
         return String(format: Lang.CustomPets.speciesAlreadyExists, species.id)
     }
 }
 */

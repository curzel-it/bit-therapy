import Foundation
import Schwifty
import SwiftUI
import Swinject

protocol DeletePetUseCase {
    func safelyDelete(item: Species) -> Bool
}

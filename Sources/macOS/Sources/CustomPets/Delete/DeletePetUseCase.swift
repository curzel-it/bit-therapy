import Foundation
import Schwifty
import SwiftUI
import Swinject
import Yage

protocol DeletePetUseCase {
    func safelyDelete(item: Species) -> Bool
}

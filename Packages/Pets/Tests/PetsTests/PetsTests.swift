import XCTest
import Yage

@testable import Pets

class PetsTests: XCTestCase {
    func testAnimationProbabilitiesAreProperlySet() {
        Species.allSpecies.forEach { species in
            species.behaviors.forEach { behavior in
                behavior.possibleAnimations.forEach { animation in
                    XCTAssertGreaterThan(animation.chance, 0)
                    XCTAssertLessThanOrEqual(animation.chance, 1)
                }
            }
        }
    }
}

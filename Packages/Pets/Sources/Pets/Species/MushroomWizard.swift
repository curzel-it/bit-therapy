import Foundation

extension Pet {
    static let mushroomWizard = Pet(
        id: "mushroomwizard",
        behaviors: [
            .init(
                trigger: .random,
                possibleAnimations: [
                    .idle.with(loops: 50),
                    .sleep.with(loops: 20)
                ]
            )
        ],
        movementPath: .walk,
        speed: 0.7
    )
}

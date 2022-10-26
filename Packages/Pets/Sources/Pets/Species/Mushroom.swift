import Foundation

extension Pet {
    
    static let mushroom = Pet(
        id: "mushroom",
        behaviors: [
            .init(
                trigger: .random,
                possibleAnimations: [
                    .idle.with(loops: 50)
                ]
            )
        ],
        movementPath: .walk,
        speed: 0.3
    )
    
    static let mushroomAmanita = Pet.mushroom.shiny(id: "mushroom_amanita", isPaid: true)
}

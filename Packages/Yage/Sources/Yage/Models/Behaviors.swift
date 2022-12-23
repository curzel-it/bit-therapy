import Schwifty

public struct EntityBehavior {
    public let trigger: Trigger
    public let possibleAnimations: [EntityAnimation]

    public enum Trigger: Equatable {
        case random
    }
}

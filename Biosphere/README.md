# Biosphere

Allows to define a headless description of world that can be rendered by the app.

* `Environment` defines the "world" in which entities can live, along with methods to update them.
* `Entity` object representing a single "thing" in the world.
* `EntityView` SwiftUI View capable of rendering an entity.
* `Capability` are objects that can be attached to an entity in order to have it do anything (such as `LinearMovement` or `BounceOffLateralBounds`).
* `Sprite` are objects that can be attached to an entity in order to have it do anything (such as `LinearMovement` or `BounceOffLateralBounds`).
* `Hotspots` a enum describing special zones of the world that can be used to trigger behaviors. 


# Physics

Allows to define a headless description of world that can be rendered by the app.

* `World` defines the "box" in which entities can live, along with methods to update them.
* `PhysicsEntity` object representing a single "thing" in the world.
* `Behavior` are objects that can be attached to an entity in order to have it do anything (such as `LinearMovement` or `BounceOffLateralBounds`).
* `Sprite` are objects that can be attached to an entity in order to have it do anything (such as `LinearMovement` or `BounceOffLateralBounds`).
* `Hotspots` a enum describing special zones of the world that can be used to trigger behaviors. 


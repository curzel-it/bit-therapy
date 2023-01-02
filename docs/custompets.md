# Custom Pets

**Work in progress, I might finish next weekend!**

You can now create your own custom pets!

Design work is not exactly easy, but the process should hopefully be straightforward:
1. Modify or sprite files
1. Create a Json file describing your pet behaviors
1. Zip everything
1. Enable creator mode, use cheat code `Set!creatorMode=true`
1. Drag and drop into the app

## Key Concepts
A `Species` is defined by the following: 
* A unique id
* A list of Capabilities
* A list of Animations
* Other attributes, such as speed

## Sprites Json

``` json
{
  "animations": [
    {
      "id": "front",
      "position": {
        "fromEntityBottomLeft": {}
      },
      "requiredLoops": 5
    },
    ...
  ],
  "capabilities": [
    "AnimatedSprite",
    "AnimationsProvider",
    "AutoRespawn",
    "BounceOnLateralCollisions",
    "FlipHorizontallyWhenGoingLeft",
    "LinearMovement",
    "PetsSpritesProvider",
    "RandomAnimations",
    "Rotating"
  ],
  "dragPath": "drag",
  "fps": 10,
  "id": "ape",
  "movementPath": "walk",
  "speed": 0.7
}

```

## Export
Click on any pet to show its details, then click the button in the top right.
![Pet details showing export button](custompets-export.png)

## Import
Scroll down the list of pets and drop in the designated area.
![Bottom of the homepage showing the drop area](custompets-droparea.png)
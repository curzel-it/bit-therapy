# Desktop Pets

This is the source code of my macOS app [Desktop Pets](https://apps.apple.com/app/desktop-pets/id1575542220)!.

As you can guess, it brings Desktop Pets to macOS 🚀

Like the app? Join our [Discord](https://discord.gg/MCdEgXKSH5)!

## What's a Desktop Pet?

It's just a cute little pet or animal that lives in your computer.

The most popular one was probably the [eSheep](https://github.com/Adrianotiger/desktopPet) for Windows 95.

Hope you like them too!

## Get the app
For daily use I recommend getting the App from the App Store.

Alternatively, you can download the latest release from [GitHub]( https://github.com/curzel-it/pet-therapy/releases/latest) or build from source (see below).

[![Get it on the App Store](Docs/appstore_badge.png)](https://apps.apple.com/app/desktop-pets/id1575542220)

## Screenshots

![App running on my mac](Docs/demo.gif)
![PetsSelectionView, light mode](Docs/1.png)
![Settings, light mode](Docs/3.png)

## How does it work?

* A window with transparent background moves around according to pet position
* [Windows are detected as obstacles](https://github.com/curzel-it/windows-detector)
* A lot of hard work with [Aseprite](https://github.com/aseprite/aseprite)

## Create custom pets

Starting from version 2.20 you can now create custom pets, please check [the documentation](https://curzel.it/pet-therapy/custompets).

## Contribute

Contributors get a shout out in the app, just saying... 😏
![Contributors, dark mode](Docs/contributors.png)

## Build from Source

1. Download and setup Xcode
1. Open the `DesktopPets` workspace
1. Give Xcode some time to figure out dependencies...
1. Run

### Do I need Xcode to create custom pets?
No, no need! Just design your characters and follow [the instructions](https://curzel.it/pet-therapy/custompets), good luck!

### Swift Packages not loading
Unfortunately, Xcode does not like local swift packages very much. In case you get any error about missing packages, try the following:
1. Clean build folder (Product > Clean)
1. Reset Packages Cache (Package Dependencies > Right Click)
1. Wait for process completion
1. Close and re-open Xcode
1. Build


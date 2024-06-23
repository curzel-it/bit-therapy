# C++ Porting

> **Warning!**<br>
> I'm using this project to **learn** C++, it's gonna take a while.

## ⏳ Status

### ✅ What's working:
* Basic game engine primitives
* Basic game rendering primitives
* Basic geometry primitives
* Tests are passing

### ❌ What's not working:
* n/a

### ⏳ Other stuff in the todo list:
* n/a

## 🛠️ Building 
```bash
cd Sources/cpp
brew install googletests
brew install cmake
cd scripts
sh build.sh
./Main --species ape --species betta --screen ben
```

## 🚀 Running
Well, first follow the building steps, then tou can run the app from the command line, on any number of monitors with any number of pets.

### `--help`
```
Allowed options:
  -h [ --help ]   Shows this help message
  --species arg   Species of pets to spawn (required)
  --screen arg    Monitors the app will display on
```

### `--species`
The ids of the species you want to display...<br>
The list of bundled-in species is available [here](https://github.com/curzel-it/bit-therapy/tree/main/Species).<br>
For example:
* `--species betta` Shows a betta fish
* `--species ape --species betta` Shows an ape and betta fish
* At least one is required

### `--screen`
Monitors/screens are identified simply by part of the name.<br>
Here's some examples with the following setup:
![Screenshot of Settings > Displays](docs/displays.png)<br>
* `--screen u34` only runs the app on the "U34G2G4R3"
* `--screen ben` only runs the app on "BenQ LCD"
* `--screen u34 --screen ben` runs on both displays
* Omitting the `--screen` param runs on all available displays


## ⚙️ Testing
```bash
cd Sources/cpp
brew install googletests
brew install cmake
cd scripts
sh test.sh
```
# Python + Qt porting

## ⏳ Status

### ✅ What's working:
* Tests are passing
* Can select and deselect pets
* Pets are shown on the screen
* Can use mouse to drag pets around

### ❌ What's not working:
* Pet selection image look smoothed even if interpolation is disabled (retina displays)

### ⏳ Other stuff in the todo list:
* All other UI features
* Support for multiple screens
* Detection of windows as obstacles
* Random events

## 🛠️ Running the app
Works on macOS and Windows, did not test on any Linux distro yet.
```bash
cd Sources/windows
python3 -m pip install -r requirements.txt
python3 main.py
```

## ⚙️ Running tests
```bash
cd Sources/windows
python3 -m unittest discover -p "*_tests.py"
```

## 🧱 Build from source
I'm using PyInstaller to package the app into a Windows executable:
```bash
python3 build.py debug
```
This will create a `DesktopPets.exe` file in the `dist` folder.

See `build.py`, `release.spec` and `debug.spec` for more information.
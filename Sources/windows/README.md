# Python + Qt porting

## ⏳ Status

### ✅ What's working:
* Tests are passing
* Can select and deselect pets
* Pets are shown on the screen
* Can use mouse to drag pets around

### ❌ What's not working:
* Animations are resetting the position of the pets to (0, 0)

### ⏳ Other stuff in the todo list:
* All other UI features
* Support for multiple screens
* Detection of windows as obstacles
* Random events
* Executable build

## 🛠️ Running the app
```bash
cd Sources/windows
python3 -m pip install -r requirements.txt
python3 main.py 
```

## ⚙️ Running tests
```bash
python3 -m unittest discover -p "*_tests.py"
```
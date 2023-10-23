import os

def rename_files(root_path):
    # Walk through root_path
    for dirpath, dirnames, filenames in os.walk(root_path):
        for filename in filenames:
            # If "-" exists in the filename
            if "-" in filename:
                # Construct full path
                old_path = os.path.join(dirpath, filename)
                # Rename by removing "-"
                new_filename = filename.replace("-", "")
                new_path = os.path.join(dirpath, new_filename)
                # Rename file
                os.rename(old_path, new_path)
                print(f"Renamed {old_path} to {new_path}")

# Test
# Provide the desired root path as an argument
# path = "/path/to/directory"
rename_files('../Aseprite')

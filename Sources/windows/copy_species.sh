#!/bin/bash

SOURCE_DIR="../bit-therapy/Species"
DEST_DIR="App"

if [ ! -d "$SOURCE_DIR" ]; then
    echo "Source directory $SOURCE_DIR does not exist."
    exit 1
fi

mkdir -p "$DEST_DIR"
rsync -av --include='*' "$SOURCE_DIR" "$DEST_DIR"
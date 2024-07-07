#!/bin/bash

SOURCE_DIR="../bit-therapy-cpp"
DEST_DIR="BitTherapyCLR"

if [ ! -d "$SOURCE_DIR" ]; then
    echo "Source directory $SOURCE_DIR does not exist."
    exit 1
fi

mkdir -p "$DEST_DIR"
mkdir -p "$DEST_DIR/src"

rsync -av --exclude='*_tests.cpp' --exclude='*_tests.h' --exclude='main.*' --include='*/' --include='*' --exclude='*' "$SOURCE_DIR/src" "$DEST_DIR"

rm -rf "$DEST_DIR/src/args"
rm -rf "$DEST_DIR/src/rendering"

mkdir -p "$DEST_DIR/dependencies"

rsync -av --include='*' "$SOURCE_DIR/dependencies/" "$DEST_DIR/dependencies/"
#!/bin/bash

MBTJAR="env/jar/MaterialBinTool-0.9.0-all.jar"
BUILD_DIR="./build"

# Function to merge files
merge_files() {
    local material="$1"
    shift
    local platforms=("$@")

    # Construct the merge command
    local merge_command="java -jar $MBTJAR --merge-bin"
    for platform in "${platforms[@]}"; do
        merge_command+=" $BUILD_DIR/$platform/$material.material.bin"
    done
    merge_command+=" -o $BUILD_DIR/All"

    # Execute the merge command
    echo "Executing command: $merge_command"
    eval "$merge_command"
}

# Check for correct number of arguments
if [ "$#" -lt 3 ]; then
    echo "Usage: $0 <material> <platform1> <platform2> [<platform3>]"
    exit 1
fi

# Get the material and platforms from the arguments
material="$1"
shift
platforms=("$@")

# Check for at least two platforms
if [ "${#platforms[@]}" -lt 2 ]; then
    echo "You must specify at least two platforms."
    exit 1
fi

# Call the merge_files function
merge_files "$material" "${platforms[@]}"

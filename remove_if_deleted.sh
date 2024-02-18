#!/usr/bin/bash
# requires env vars: INPUT_RAW_PATH, OUTPUT_COMPRESSED_PATH

if [ -z "$1" ]
then
    echo Relative filename not provided.
    exit 1
fi

FILE_PATH="$(dirname "$1")"
FILE_NAME="$(basename "$1")"

# match any input extension if output extension is ogg
if [[ "$FILE_NAME" == *.ogg ]]
then
    FILE_NAME="$(echo "$FILE_NAME" | rev | cut -f 2- -d '.' | rev).*"
fi

# remove from output if not found in input
if ! find "$INPUT_RAW_PATH/$FILE_PATH" -maxdepth 1 -type f -name "$FILE_NAME" | grep . > /dev/null 2>&1
then
    rm "$OUTPUT_COMPRESSED_PATH/$1"
    echo Removed deleted file: $1
fi
#!/usr/bin/bash
# requires env vars: INPUT_RAW_PATH, OUTPUT_COMPRESSED_PATH

if [ -z "$1" ]
then
    echo Relative filename not provided.
    exit 1
fi

# ignore input extension if output extension is ogg
if [[ "$1" == *.ogg ]]
then
    FILE="$(echo "$1" | rev | cut -f 2- -d '.' | rev).*"
else
    FILE="$1"
fi

# remove from output if not found in input
if ! ls "$INPUT_RAW_PATH/$FILE"
then
    rm "$OUTPUT_COMPRESSED_PATH/$1"
    echo Removed deleted file: $1
fi
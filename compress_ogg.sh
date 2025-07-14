#!/usr/bin/bash
# requires env vars: INPUT_RAW_PATH, OUTPUT_COMPRESSED_PATH, OGG_FFMPEG_ARGS

set -eu

if [ -z "$1" ]
then
    echo Relative filename not provided.
    exit 1
fi

# change extension to ogg
FILE_NO_EXT=${1%.*}

# compress if not found
if ! [ -f "$OUTPUT_COMPRESSED_PATH/$FILE_NO_EXT.ogg" ]
then
    echo Compressing OGG: $1
    ffmpeg -hide_banner -loglevel error -i "$INPUT_RAW_PATH/$1" -y $OGG_FFMPEG_ARGS "$OUTPUT_COMPRESSED_PATH/$FILE_NO_EXT.tmp.ogg" # must end in .ogg for ffmpeg to know what to do
    mv "$OUTPUT_COMPRESSED_PATH/$FILE_NO_EXT.tmp.ogg" "$OUTPUT_COMPRESSED_PATH/$FILE_NO_EXT.ogg"
    FROM_SIZE=$(ls -lh "$INPUT_RAW_PATH/$1" | cut -d' ' -f5)
    TO_SIZE=$(ls -lh "$OUTPUT_COMPRESSED_PATH/$FILE_NO_EXT.ogg" | cut -d' ' -f5)
    echo Compressed OGG: $1 \($FROM_SIZE -\> $TO_SIZE\)
fi
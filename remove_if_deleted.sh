#!/usr/bin/bash
# requires env vars: INPUT_RAW_PATH, OUTPUT_COMPRESSED_PATH

if [ -z "$1" ]
then
    echo Relative filename not provided.
    exit 1
fi

FILE_NO_EXT=${1%.*}
FILE_EXT=${1##*.}

CANDIDATES=("$INPUT_RAW_PATH/$1") # the exact file
if [ "$FILE_EXT" == "ogg" ]; then
  CANDIDATES+=("$INPUT_RAW_PATH/$FILE_NO_EXT".*) # or anything which only differs by the extension
fi

for candidate in "${CANDIDATES[@]}"; do
  if [ -f "$candidate" ]; then
    exit # input file still exists, do nothing
  fi
done

# input file has been deleted, delete the output
rm "$OUTPUT_COMPRESSED_PATH/$1"
echo Removed deleted file: "$1"
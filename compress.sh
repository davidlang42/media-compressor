#!/usr/bin/bash
# requires env vars: INPUT_RAW_PATH, OUTPUT_COMPRESSED_PATH
# optional env vars: MAX_PARALLEL

if [ -z "${MAX_PARALLEL}" ]; then
    # if not set, use default
    MAX_PARALLEL=8
fi

set -eu

# remove existing files in output if they don't exist in input anymore
echo Removing deleted files...
find $OUTPUT_COMPRESSED_PATH -mindepth 1 -type f -printf '%P\n' | parallel -j $MAX_PARALLEL -- /remove_if_deleted.sh {}

#FUTURE check for duplicate input files

# make all required dirs if they don't already exist
echo Making directory structure...
(cd $INPUT_RAW_PATH && find . -mindepth 1 -type d -exec mkdir -p "$OUTPUT_COMPRESSED_PATH/{}" ';')

# trigger compress of each pdf file
echo Compressing PDFs...
find $INPUT_RAW_PATH -mindepth 1 -type f -iname "*.pdf" -printf '%P\n' | parallel -j $MAX_PARALLEL -- /compress_pdf.sh {}

# trigger re-encode of each audio file
echo Compressing audio...
find $INPUT_RAW_PATH -mindepth 1 -type f -iname "*.mp3" -printf '%P\n' | parallel -j $MAX_PARALLEL -- /compress_ogg.sh {}
find $INPUT_RAW_PATH -mindepth 1 -type f -iname "*.m4a" -printf '%P\n' | parallel -j $MAX_PARALLEL -- /compress_ogg.sh {}
find $INPUT_RAW_PATH -mindepth 1 -type f -iname "*.mpga" -printf '%P\n' | parallel -j $MAX_PARALLEL -- /compress_ogg.sh {}
find $INPUT_RAW_PATH -mindepth 1 -type f -iname "*.wma" -printf '%P\n' | parallel -j $MAX_PARALLEL -- /compress_ogg.sh {}
find $INPUT_RAW_PATH -mindepth 1 -type f -iname "*.aiff" -printf '%P\n' | parallel -j $MAX_PARALLEL -- /compress_ogg.sh {}

#FUTURE trigger video re-encoding: mp4, mkv, m4v
#FUTURE trigger image re-encoding: jpg, jpeg, tif, png
#FUTURE convert word documents to PDF: doc, docx, odt
#FUTURE zip FOLDERS which are named "*.zip" into zip files

# remove empty files & dirs in OUTPUT_COMPRESSED_PATH
echo Removing empty folders...
find $OUTPUT_COMPRESSED_PATH -mindepth 1 -type f -empty -not -name ".*" -delete
find $OUTPUT_COMPRESSED_PATH -mindepth 1 -type d -empty -not -name ".*" -delete

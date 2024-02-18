#!/usr/bin/bash
# requires env vars: INPUT_RAW_PATH, OUTPUT_COMPRESSED_PATH

#TODO remove existing files in output if they don't exist in input anymore

#FUTURE check for duplicate input files

# make all required dirs if they don't already exist
(cd $INPUT_RAW_PATH && find . -mindepth 1 -type d -exec mkdir -p "$OUTPUT_COMPRESSED_PATH/{}" ';')

# trigger compress of each pdf file
find $INPUT_RAW_PATH -mindepth 1 -type f -iname "*.pdf" -printf '%P\n' | parallel -- /compress_pdf.sh {}

#TODO trigger audio re-encoding: m4a, mp3, mpga, wma, aiff
#FUTURE trigger video re-encoding: mp4, mkv, m4v
#FUTURE trigger image re-encoding: jpg, jpeg, tif, png
#FUTURE convert word documents to PDF: doc, docx, odt
#FUTURE zip FOLDERS which are named "*.zip" into zip files

#TODO remove empty dirs in OUTPUT_COMPRESSED_PATH
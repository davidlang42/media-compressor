#!/usr/bin/bash
# requires env vars: INPUT_RAW_PATH, OUTPUT_COMPRESSED_PATH, PDF_GS_ARGS

set -eu

if [ -z "$1" ]
then
    echo Relative filename not provided.
    exit 1
fi

# compress if not found
if ! [ -f "$OUTPUT_COMPRESSED_PATH/$1" ]
then
    echo Compressing PDF: $1
    gs -sDEVICE=pdfwrite $PDF_GS_ARGS -dNOPAUSE -dQUIET -dBATCH -sOutputFile="$OUTPUT_COMPRESSED_PATH/$1.tmp" "$INPUT_RAW_PATH/$1" # -dPDFSETTINGS=/screen ~72dpi, -dPDFSETTINGS=/ebook ~150dpi, -dPDFSETTINGS=/printer ~300dpi
    mv "$OUTPUT_COMPRESSED_PATH/$1.tmp" "$OUTPUT_COMPRESSED_PATH/$1"
    FROM_SIZE=$(ls -lh "$INPUT_RAW_PATH/$1" | cut -d' ' -f5)
    TO_SIZE=$(ls -lh "$OUTPUT_COMPRESSED_PATH/$1" | cut -d' ' -f5)
    echo Compressed PDF: $1 \($FROM_SIZE -\> $TO_SIZE\)
fi
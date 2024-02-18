#!/usr/bin/bash
set -eux

if [ -z "${INPUT_RAW_PATH}" ] || [ ! -d "$INPUT_RAW_PATH" ]; then
    echo "Must set environment variable INPUT_RAW_PATH and mount the input folder to it"
    exit 1 # failed
fi

if [ -z "${OUTPUT_COMPRESSED_PATH}" ] || [ ! -d "$OUTPUT_COMPRESSED_PATH" ]; then
    echo "Must set environment variable OUTPUT_COMPRESSED_PATH and mount the output folder to it"
    exit 1 # failed
fi

if [ -z "${PDF_GS_ARGS}" ]; then
    echo "Must set environment variable PDF_GS_ARGS"
    exit 1 # failed
fi

if [ -z "${OGG_FFMPEG_ARGS}" ]; then
    echo "Must set environment variable OGG_FFMPEG_ARGS"
    exit 1 # failed
fi

if [ -z "${RUN_AT_UTC_TIME}" ]; then
    echo "Must set environment variable RUN_AT_UTC_TIME"
    exit 1 # failed
fi

if [ "$RUN_ON_START" == "1" ]; then
    echo Running compress on start...
    /compress.sh
    echo Compress finished.
fi

while true
do
    current_epoch=$(date +%s)
    next_run_epoch=$(date -d "+1 day $RUN_AT_UTC_TIME" +%s)
    sleep_seconds=$(( $next_run_epoch - $current_epoch ))
    echo Next run in $sleep_seconds seconds...
    sleep $sleep_seconds
    echo Running compress at $RUN_AT_UTC_TIME...
    /compress.sh
    echo Compress finished.
done
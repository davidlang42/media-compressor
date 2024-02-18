FROM ubuntu:latest

# install tools
RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		bash ghostscript parallel ffmpeg

# copy files
COPY --chmod=500 docker_entrypoint.sh /
COPY --chmod=500 compress.sh /
COPY --chmod=500 compress_pdf.sh /
COPY --chmod=500 compress_ogg.sh /
COPY --chmod=500 remove_if_deleted.sh /

# paths which should be host mounted to
ENV INPUT_RAW_PATH="/input_raw"
ENV OUTPUT_COMPRESSED_PATH="/output_compressed"

# default compression args
ENV PDF_GS_ARGS="-dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook"
ENV OGG_FFMPEG_ARGS="-c:a libopus -b:a 64k"

# run
ENV RUN_ON_START=1
ENV RUN_AT_UTC_TIME="00:00"
ENTRYPOINT ["/docker_entrypoint.sh"]
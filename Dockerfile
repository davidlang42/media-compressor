FROM ubuntu:latest

# install tools
RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		bash ghostscript parallel

# copy files
COPY --chmod=500 docker_entrypoint.sh /
COPY --chmod=500 compress.sh /
COPY --chmod=500 compress_pdf.sh /

# paths which should be host mounted to
ENV INPUT_RAW_PATH="/input_raw"
ENV OUTPUT_COMPRESSED_PATH="/output_compressed"

# default compression args
ENV PDF_GS_ARGS="-dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook"

# run
ENV RUN_ON_START=1
ENV RUN_AT_UTC_TIME="12:00"
ENTRYPOINT ["/docker_entrypoint.sh"]
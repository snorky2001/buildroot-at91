#! /bin/sh
ATMEL_DIR="board/atmel/sama5d3ek"

# alsa stuff
${ATMEL_DIR}/alsa/post-build_alsa.sh $1 ${ATMEL_DIR}

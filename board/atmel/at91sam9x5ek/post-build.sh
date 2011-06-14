#!/bin/bash

ATMEL_DIR="board/atmel/at91sam9x5ek"

# alsa stuff
${ATMEL_DIR}/alsa/post-build_alsa.sh $1 ${ATMEL_DIR}

#!/bin/bash

ATMEL_DIR="board/atmel/at91sam9n12ek"

# alsa stuff
${ATMEL_DIR}/alsa/post-build_alsa.sh $1 ${ATMEL_DIR}

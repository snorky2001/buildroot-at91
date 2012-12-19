#!/bin/bash

echo "/root/go.sh &" > ${1}/etc/init.d/S99demo
chmod +x ${1}/etc/init.d/S99demo

echo "#!/bin/sh" > ${1}/root/go.sh
echo "while \`ls /dev/fb0 > /dev/null 2>&1\`" >> ${1}/root/go.sh
echo "do" >> ${1}/root/go.sh
echo "gst-launch-0.10 filesrc location=/root/MPEG2_480_272.avi ! avidemux ! mpeg2dec ! ffmpegcolorspace ! fbdevsink 2>&1 > /dev/null" >> ${1}/root/go.sh
echo "sleep 5" >> ${1}/root/go.sh
echo "done" >> ${1}/root/go.sh
chmod +x ${1}/root/go.sh

cp board/atmel/sama5d3ek_demo/MPEG2_480_272.avi ${1}/root/MPEG2_480_272.avi

# alsa stuff
board/atmel/sama5d3ek_demo/alsa/post-build_alsa.sh $1 board/atmel/sama5d3ek_demo

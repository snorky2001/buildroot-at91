#!/bin/bash

cp board/atmel/sama5d3_xplained/g_serial.conf ${1}/etc/modules-load.d/
ln -fs ../../../../usr/lib/systemd/system/serial-getty@.service ${1}/etc/systemd/system/getty.target.wants/serial-getty@ttyGS0.service

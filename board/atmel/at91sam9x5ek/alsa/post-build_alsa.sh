#!/bin/bash

echo "Copying alsa configuration files..."
cp $2/alsa/asound* $1/etc/
if [ $? = 0 ]; then
	echo "Done."
else
        echo "Failed."
fi

echo "Copying alsa initialisation script..."
cp $2/alsa/S39alsa-state $1/etc/init.d/
chmod 755 $1/etc/init.d/S39alsa-state
if [ $? = 0 ]; then
	echo "Done."
else
        echo "Failed."
fi


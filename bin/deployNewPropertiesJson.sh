#!/bin/bash
. ../conf/binaries.conf

# notification
echo " "
echo "Copying properties.json in this directory to /home/dirpic/. Errors:"

# copy motion config
$SUDO $CP $PROPERTIES $APP_JSON_PROPERTIES_PATH
#/usr/bin/sudo /bin/cp $PROPERTIES $APP_JSON_PROPERTIES_PATH
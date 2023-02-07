#!/bin/bash

SUDO="/usr/bin/sudo"
ECHO="/bin/echo"

# set magicz
PROPERTIES="deployable/properties.json"
APP_JSON_PROPERTIES_PATH="/home/dirpic/properties.json"

# notification
echo " "
echo "Copying properties.json in this directory to /home/dirpic/. Errors:"

# copy motion config
/usr/bin/sudo /bin/cp $PROPERTIES $APP_JSON_PROPERTIES_PATH
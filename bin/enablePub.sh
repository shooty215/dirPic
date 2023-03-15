#!/bin/bash
. ../conf/binaries.conf

# enable service
$SUDO $SYSTEMCTL $ENABLE $PUBLISHER_SERVICE_FILES_DIRECTORY
#/usr/bin/sudo /bin/systemctl enable $PUBLISHER_SERVICE_FILES_DIRECTORY
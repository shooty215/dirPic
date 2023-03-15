#!/bin/bash
. ../conf/binaries.conf

# enable service
$SUDO $SYSTEMCTL $ENABLE $SUBSCRIBER_SERVICE_FILES_DIRECTORY
#/usr/bin/sudo /bin/systemctl enable $SUBSCRIBER_SERVICE_FILES_DIRECTORY
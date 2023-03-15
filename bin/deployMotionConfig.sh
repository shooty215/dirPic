#!/bin/bash
. ../conf/binaries.conf

# notification
echo " "
echo "Copying motion.conf in this directory to /home/dirpic/. Errors:"

# copy motion config
$SUDO $CP $MOTION_TMP_CONFIG $MOTION_CONFIG
#/usr/bin/sudo /bin/cp $MOTION_CONFIG /home/dirpic/motion.conf
#!/bin/bash

# set magicz
MOTION_CONFIG="motion.conf"

# notification
echo " "
echo "Copying motion.conf in this directory to /home/dirpic/. Errors:"

# copy motion config
/usr/bin/sudo /bin/cp $MOTION_CONFIG /home/dirpic/motion.conf
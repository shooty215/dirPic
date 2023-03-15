#!/bin/bash
. ../conf/binaries.conf

# notification
echo " "
echo "Copying als.json in this directory to /home/dirpic/keystores. Errors:"

# copy pem file to its' destination
$SUDO $CP $APP_JSON_ALS_PATH $APP_CERT_DIRECTORY"als.json"
#/usr/bin/sudo /bin/cp deployables/als.json /home/dirpic/keystores/als.json
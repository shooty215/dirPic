#!/bin/bash
SUDO="/usr/bin/sudo"
ECHO="/bin/echo"

APP_JSON_PROPERTIES_PATH="deployables/properties.json"

### take inputs
# broker information
BROKER_IP=$1
BROKER_PORT=$2
BROKER_CHANNEL=$3
BROKER_USER=$4
BROKER_USER_PASSWORD=$5

APP_JSON_PROPERTIES_SCRIPT='{
  "brokerIp": "'$BROKER_IP'",
  "brokerPort": "'$BROKER_PORT'",
  "channelName": "'$BROKER_CHANNEL'",
  "cameraPath": "'$APP_CAMERA_DIRECTORY'",
  "storagePath": "'$APP_STORAGE_DIRECTORY'",
  "keyStorePath": "'$APP_KEYSTORE_DIRECTORY'",
  "brokerAuthUser": "'$BROKER_USER'",
  "brokerAuthUserPasswd": "'$BROKER_USER_PASSWORD'"
}
'

$SUDO $ECHO -e $APP_JSON_PROPERTIES_SCRIPT > $APP_JSON_PROPERTIES_PATH
#!/bin/bash
. ../conf/binaries.conf

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
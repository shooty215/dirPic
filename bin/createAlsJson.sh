#!/bin/bash
SUDO="/usr/bin/sudo"
ECHO="/bin/echo"

APP_JSON_ALS_PATH="deployables/als.json"

# notification
echo " "
echo "Creating als.json in deployables. Errors:"

alsKeys=($(sudo java -jar generateAlsKeys.jar))

APP_JSON_ALS_SCRIPT='{
  "rsaPublicKey": "'${alsKeys[0]}'",
  "rsaPrivateKey": "'${alsKeys[1]}'",
  "aesKey": "'${alsKeys[2]}'"
}
'
#echo $APP_JSON_ALS_SCRIPT
$SUDO $ECHO -e $APP_JSON_ALS_SCRIPT > $APP_JSON_ALS_PATH
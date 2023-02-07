#!/bin/bash

#       inputs: [$1:BROKER_IP] [$2:BROKER_PORT] [$3:BROKER_CHANNEL]   #
#               [$4:BROKER_USER] [$5:BROKER_USER_PASSWORD]            #
#               [$6:KEY_PASSWORD]                                     #
# 1# recieve script's parameters and initialize magic variables
# 2# create file strings
# 3# create user
# 4# make app user sudoer only for /bin/java
# 5# create app structure
# 6# create and copy binary files 
# 7# move service files to system.d
# 8# copy ca, client crt and key
# 9# echo user credentials into file
#10# enable services

# define version
VERSION="0.0.2"

# cmds
OPENSSL="/usr/bin/openssl"
SUDO="/usr/bin/sudo"
REMOVE="/bin/rm"
ECHO="/bin/echo"
COPY="/bin/cp"
MKDIR="/bin/mkdir"
TOUCH="/bin/touch"
#SHC="/usr/bin/shc"
MOVE="/bin/mv"
CHMOD="/bin/chmod"
CHOWN="/bin/chown"
CHGRP="/bin/chgrp"
GIT="/usr/bin/git"
JAVA="/usr/bin/java"
MOTION="/usr/bin/motion"
USERMOD="/usr/sbin/usermod"
USERADD="/usr/sbin/useradd"

### recieve script's parameters and initialize magic variables
# progress notifications
PROGRESS_START="Installing dirPic!"
PROGRESS_END="dirPic installed - check output above for errors!"
PROGRESS_LIMITER=" "
PROGRESS_NOTIFICATION_CREATE_FILE_STRINGS="Binding services' starting file contents! Errors:"
PROGRESS_NOTIFICATION_CREATE_USER="Creating user! Errors:"
PROGRESS_NOTIFICATION_CREATE_SUDOERS_ENTRY="Creating entry in sudoers file! Errors:"
PROGRESS_NOTIFICATION_CREATE_DIRECTORIES="Creating structural directories! Errors:"
PROGRESS_NOTIFICATION_CLONE_GIT_REPOSITORIES="Cloning subscriber's and publisher's git repositories:"
PROGRESS_NOTIFICATION_CREATE_BINARIES="Creating services' binary files! Errors:"
PROGRESS_NOTIFICATION_MOVE_FILES="Moving all relevant key, certificate, config and binary files! Errors:"
PROGRESS_NOTIFICATION_GIVE_PRIVS_TO_APP_USER="Giving application's folder to application's user! Errors:"
PROGRESS_NOTIFICATION_ECHO_USER_CREDENTIALS="Creating file with application's user credentials (in /home/dirpic/encrypt)! Errors:"

# app user information
APP_USER="dirpic"
APP_USER_PASSWORD_PLAIN_TEXT=$($OPENSSL rand 1000 | strings | grep -io [[:alnum:]] | head -n 16 | tr -d '\n')
APP_USER_PASSWORD_SHA256_HASH=$($OPENSSL passwd -5 "$APP_USER_PASSWORD_PLAIN_TEXT")
#APP_USER_PRIV_SUDOERS_STRING="dirpic ALL=(ALL) NOPASSWD:/usr/bin/java, $MOTION"

# create new als keys

alsKeys=($(sudo java -jar bin/generateAlsKeys.jar))

# directories
APP_USER_HOME_DIRECTORY="/home/$APP_USER/"
APP_ENV_ROOT_DIRECTORY=$APP_USER_HOME_DIRECTORY"root/"
APP_ENV_DIRECTORY=$APP_USER_HOME_DIRECTORY"env/"
APP_TMP_DIRECTORY=$APP_USER_HOME_DIRECTORY"tmp/"
APP_RUNTIME_DIRECTORY=$APP_USER_HOME_DIRECTORY"runtime/"
APP_RUNTIME_DIRECTORY_PUBLISHER=$APP_RUNTIME_DIRECTORY"publisher/"
APP_RUNTIME_DIRECTORY_SUBSCRIBER=$APP_RUNTIME_DIRECTORY"subscriber/"
APP_RUNTIME_DIRECTORY_MOTION=$APP_RUNTIME_DIRECTORY"motion/"
APP_KEYSTORE_DIRECTORY=$APP_USER_HOME_DIRECTORY"keystores/"
APP_BINARY_DIRECTORY=$APP_USER_HOME_DIRECTORY"binaries/"
APP_CAMERA_DIRECTORY=$APP_USER_HOME_DIRECTORY"camera/"
APP_STORAGE_DIRECTORY=$APP_USER_HOME_DIRECTORY"storage/"

# files and hyper links
MOTION_CONFIG="bin/config/motion.conf"

GIT_BINARY_SUBSCRIBER_LINK="https://github.com/shooty215/dirPicSubscriber.git"
GIT_BINARY_PUBLISHER_LINK="https://github.com/shooty215/dirPicPublisher.git"

GIT_BINARY_SUBSCRIBER=$APP_USER_HOME_DIRECTORY"dirPicSubscriber/jars/dirPicSubscriber.jar"
GIT_BINARY_PUBLISHER=$APP_USER_HOME_DIRECTORY"dirPicPublisher/jars/dirPicPublisher.jar"

GIT_BINARY_SUBSCRIBER_SERVICE=$APP_USER_HOME_DIRECTORY"dirPicSubscriber/service/dirpicsubscriber.service"
GIT_BINARY_PUBLISHER_SERVICE=$APP_USER_HOME_DIRECTORY"dirPicPublisher/service/dirpicpublisher.service"

APP_BINARY_SUBSCRIBER=$APP_BINARY_DIRECTORY"dirPicSubscriber.jar"
APP_BINARY_PUBLISHER=$APP_BINARY_DIRECTORY"dirPicPublisher.jar"

APP_BINARY_SUBSCRIBER_START=$APP_BINARY_DIRECTORY"dirPicSubscriber.sh"
APP_BINARY_PUBLISHER_START=$APP_BINARY_DIRECTORY"dirPicPublisher.sh"

APP_BINARY_SUBSCRIBER_START_ACTUAL=$APP_USER_HOME_DIRECTORY"dirPicSubscriber.sh"
APP_BINARY_PUBLISHER_START_ACTUAL=$APP_USER_HOME_DIRECTORY"dirPicPublisher.sh"

APP_BINARY_SUBSCRIBER_START_FILENAME="dirpicsubscriber"
APP_BINARY_PUBLISHER_START_FILENAME="dirpicpublisher"

APP_BINARY_SUBSCRIBER_SERVICE=$APP_USER_HOME_DIRECTORY"dirPicSubscriber/service/dirpicsubscriber.service"
APP_BINARY_PUBLISHER_SERVICE=$APP_USER_HOME_DIRECTORY"dirPicPublisher/service/dirpicpublisher.service"

APP_JSON_PROPERTIES_NAME="properties.json"
APP_JSON_PROPERTIES_PATH=$APP_USER_HOME_DIRECTORY$APP_JSON_PROPERTIES_NAME

SERVICE_FILES_DIRECTORY="/etc/systemd/system/"

# broker information
BROKER_IP=$1
BROKER_PORT=$2
BROKER_CHANNEL=$3
BROKER_USER=$4
BROKER_USER_PASSWORD=$5

# ca password
#CA_PASSWORD=$6

# aes key password
#AES_KEY_PWD=$7

# rsa keys password
#RSA_KEY_PWD=$8

# progress notification
$ECHO $PROGRESS_LIMITER
$ECHO $PROGRESS_START

# progress notification
$ECHO $PROGRESS_LIMITER
$ECHO $PROGRESS_NOTIFICATION_CREATE_FILE_STRINGS

### create file strings
APP_BINARY_SUBSCRIBER_START_SCRIPT="
#!/bin/bash\n
$CD $APP_RUNTIME_DIRECTORY_SUBSCRIBER\n
$JAVA -jar $APP_BINARY_SUBSCRIBER $APP_JSON_PROPERTIES_PATH\n
"

APP_BINARY_PUBLISHER_START_SCRIPT="
#!/bin/bash\n
$CD $APP_RUNTIME_DIRECTORY_MOTION\n
$MOTION -c /home/dirpic/motion.conf\n
$CD $APP_RUNTIME_DIRECTORY_PUBLISHER\n
$JAVA -jar $APP_BINARY_PUBLISHER $APP_JSON_PROPERTIES_PATH\n
"

APP_JSON_PROPERTIES_SCRIPT='{
  "brokerIp": "'$BROKER_IP'",
  "brokerPort": "'$BROKER_PORT'",
  "channelName": "'$BROKER_CHANNEL'",
  "cameraPath": "'$APP_CAMERA_DIRECTORY'",
  "storagePath": "'$BROKER_IP'",
  "keyStorePath": "'$APP_KEYSTORE_DIRECTORY'",
  "brokerAuthUser": "'$BROKER_USER'",
  "rsaPublicKey": "'${alsKeys[0]}'",
  "rsaPrivateKey": "'${alsKeys[1]}'",
  "aesKey": "'${alsKeys[2]}'",
}
'

# progress notification
$ECHO $PROGRESS_LIMITER
$ECHO $PROGRESS_NOTIFICATION_CREATE_USER

### create user
$SUDO $USERADD -p $APP_USER_PASSWORD_SHA256_HASH $APP_USER -r -d $APP_USER_HOME_DIRECTORY
#$SUDO /usr/sbin/useradd -r -m

### make app user sudoer only for /bin/java
# add app user to sudo group in /etc/group
$SUDO $USERMOD -a -G sudo $APP_USER

# progress notification
$ECHO $PROGRESS_LIMITER
$ECHO $PROGRESS_NOTIFICATION_CREATE_SUDOERS_ENTRY

# modify app user's sudo privs, restricting it to only use /bin/java in sudo context
#$SUDO $ECHO $APP_USER_PRIV_SUDOERS_STRING >> /etc/sudoers

### create app structure

# progress notification
$ECHO $PROGRESS_LIMITER
$ECHO $PROGRESS_NOTIFICATION_CREATE_DIRECTORIES

# create directories
$SUDO $MKDIR $APP_USER_HOME_DIRECTORY
$SUDO $MKDIR $APP_RUNTIME_DIRECTORY
$SUDO $MKDIR $APP_BINARY_DIRECTORY
$SUDO $MKDIR $APP_RUNTIME_DIRECTORY_PUBLISHER
$SUDO $MKDIR $APP_RUNTIME_DIRECTORY_SUBSCRIBER
$SUDO $MKDIR $APP_RUNTIME_DIRECTORY_MOTION
$SUDO $MKDIR $APP_KEYSTORE_DIRECTORY
$SUDO $MKDIR $APP_CAMERA_DIRECTORY
$SUDO $MKDIR $APP_STORAGE_DIRECTORY

# progress notification
$ECHO $PROGRESS_LIMITER
$ECHO $PROGRESS_NOTIFICATION_CLONE_GIT_REPOSITORIES
$ECHO $PROGRESS_LIMITER

## clone git repositories
#$SUDO $GIT -C $APP_USER_HOME_DIRECTORY clone $GIT_BINARY_PUBLISHER_LINK
#$SUDO $GIT -C $APP_USER_HOME_DIRECTORY clone $GIT_BINARY_SUBSCRIBER_LINK 
$GIT -C $APP_USER_HOME_DIRECTORY clone $GIT_BINARY_PUBLISHER_LINK
$GIT -C $APP_USER_HOME_DIRECTORY clone $GIT_BINARY_SUBSCRIBER_LINK 

## copy binary files from git repository to app directory
$SUDO $COPY $GIT_BINARY_SUBSCRIBER $APP_BINARY_DIRECTORY
$SUDO $COPY $GIT_BINARY_PUBLISHER $APP_BINARY_DIRECTORY
$SUDO $COPY $GIT_BINARY_SUBSCRIBER_SERVICE $APP_BINARY_DIRECTORY
$SUDO $COPY $GIT_BINARY_PUBLISHER_SERVICE $APP_BINARY_DIRECTORY

### create and copy binary files

# progress notification
$ECHO $PROGRESS_LIMITER
$ECHO $PROGRESS_NOTIFICATION_CREATE_BINARIES
$ECHO $PROGRESS_LIMITER

# create file not needed due to > operators functionality (creates the file)
$SUDO $TOUCH $APP_BINARY_SUBSCRIBER_START
$SUDO $TOUCH $APP_BINARY_PUBLISHER_START

$SUDO $TOUCH $APP_JSON_PROPERTIES_PATH

# load file
$SUDO $ECHO -e $APP_BINARY_PUBLISHER_START_SCRIPT > $APP_BINARY_PUBLISHER_START
$SUDO $ECHO -e $APP_BINARY_SUBSCRIBER_START_SCRIPT > $APP_BINARY_SUBSCRIBER_START

$SUDO $ECHO -e $APP_JSON_PROPERTIES_SCRIPT > $APP_JSON_PROPERTIES_PATH

# turn shell files into binaries
#$SUDO $SHC -f $APP_BINARY_PUBLISHER_START -o $APP_BINARY_PUBLISHER_START_ACTUAL
#$SUDO $SHC -f $APP_BINARY_SUBSCRIBER_START -o $APP_BINARY_SUBSCRIBER_START_ACTUAL

# progress notification
$ECHO $PROGRESS_NOTIFICATION_MOVE_FILES
$ECHO $PROGRESS_LIMITER

# move binary shell files to /usr/bin/
#$SUDO $MOVE $APP_BINARY_PUBLISHER_START_ACTUAL /usr/bin/${APP_BINARY_PUBLISHER_START_FILENAME}
#$SUDO $MOVE $APP_BINARY_SUBSCRIBER_START_ACTUAL /usr/bin/${APP_BINARY_SUBSCRIBER_START_FILENAME}
$SUDO $MOVE $APP_BINARY_PUBLISHER_START /usr/bin/${APP_BINARY_PUBLISHER_START_FILENAME}
$SUDO $MOVE $APP_BINARY_SUBSCRIBER_START /usr/bin/${APP_BINARY_SUBSCRIBER_START_FILENAME}

### move service files to system.d
$SUDO $COPY $APP_BINARY_SUBSCRIBER_SERVICE $SERVICE_FILES_DIRECTORY
$SUDO $COPY $APP_BINARY_PUBLISHER_SERVICE $SERVICE_FILES_DIRECTORY

# copy pem files to their destination
$SUDO $COPY bin/deployables/serverCrt.pem $APP_KEYSTORE_DIRECTORY"tls_server_crt.pem"
$SUDO $COPY bin/deployables/clientCrt.pem $APP_KEYSTORE_DIRECTORY"tls_client_crt.pem"
$SUDO $COPY bin/deployables/clientKey.pem $APP_KEYSTORE_DIRECTORY"tls_client_private_key.pem"

# copy motion config
$SUDO $COPY $MOTION_CONFIG /home/dirpic/motion.conf

### set privs, ownership and group of app user's home directory, the service and the binary files
# maybe not the service and the binary files
# home directory

# progress notification
$ECHO $PROGRESS_NOTIFICATION_GIVE_PRIVS_TO_APP_USER
$ECHO $PROGRESS_LIMITER

$SUDO $CHMOD -R 750 $APP_USER_HOME_DIRECTORY
$SUDO $CHOWN-R dirpic $APP_USER_HOME_DIRECTORY
$SUDO $CHGRP -R dirpic $APP_USER_HOME_DIRECTORY

### echo user password into file

# progress notification
$ECHO $PROGRESS_NOTIFICATION_ECHO_USER_CREDENTIALS
$ECHO $PROGRESS_LIMITER

$SUDO $ECHO $APP_USER_PASSWORD_PLAIN_TEXT'|:::::|'$APP_USER_PASSWORD_SHA256_HASH > $APP_USER_HOME_DIRECTORY'encrypt'

# progress notification
$ECHO $PROGRESS_END
$ECHO $PROGRESS_LIMITER

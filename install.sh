#!/bin/bash

###                                                                 ###
#                                                                     #
##                                                                   ##
#                                                                     #
#       inputs: [$1:BROKER_IP] [$2:BROKER_PORT] [$3:BROKER_CHANNEL]   #
#               [$4:BROKER_USER] [$5:BROKER_USER_PASSWORD]            #
#                                                                     #
##                                                                   ##
#                                                                     #
##                                                                   ##
#                       procedural code summary                       #
##                                                                   ##
# 1# recieve script's parameters and initialize magic variables       #
# 2# create file strings                                              #
# 3# create user                                                      #
# 4# make app user sudoer only for /bin/java                          #
# 5# create app structure                                             #
# 6# create and copy binary files                                     #
# 7# move service files to system.d                                   #
#                                                                     #
###                                                                 ###

###                                                                 ###
#                                                                     #
##                             :::CODE:::                            ##
#                                                                     #
###                                                                 ###

### recieve script's parameters and initialize magic variables
# directories
APP_USER_HOME_DIRECTORY="/home/dirpic/"
APP_KEYSTORE_DIRECTORY="/home/dirpic/keystores"
APP_RUNTIME_DIRECTORY="/home/dirpic/runtime"
APP_BINARY_DIRECTORY="/home/dirpic/binaries"
APP_CAMERA_DIRECTORY="/home/dirpic/camera"
APP_STORAGE_DIRECTORY="/home/dirpic/storage"

# app user information
APP_USER="dirpic"
APP_USER_PASSWORD_PLAIN_TEXT=$(/bin/openssl rand 1000 | strings | grep -io [[:alnum:]] | head -n 16 | tr -d '\n')
APP_USER_PASSWORD_SHA256_HASH=$(/bin/openssl passwd -5 "$APP_USER_PASSWORD_PLAIN_TEXT")
APP_USER_PRIV_SUDOERS_STRING="dirpic     JAVA=(JAVA:JAVA) JAVA"

# files and hyper links
GIT_BINARY_SUBSCRIBER_LINK="https://github.com/shooty215/dirPicSubscriber.git"
GIT_BINARY_PUBLISHER_LINK="https://github.com/shooty215/dirPicPublisher.git"

GIT_BINARY_SUBSCRIBER="/home/dirpic/dirPicPublisher/jar/dirPicSubscriber.jar"
GIT_BINARY_PUBLISHER="/home/dirpic/dirPicPublisher/jar/dirPicPublisher.jar"

GIT_BINARY_SUBSCRIBER_SERVICE="/home/dirpic/dirPicSubscriber/service/subscriber.service"
GIT_BINARY_PUBLISHER_SERVICE="/home/dirpic/dirPicPublisher/service/publisher.service"

APP_BINARY_SUBSCRIBER="/home/dirpic/binaries/startDirPicSubscriber.jar"
APP_BINARY_PUBLISHER="/home/dirpic/binaries/startDirPicPublisher.jar"

APP_BINARY_SUBSCRIBER_START="/home/dirpic/binaries/dirpicsubscriber.sh"
APP_BINARY_PUBLISHER_START="/home/dirpic/binaries/dirpicpublisher.sh"

APP_BINARY_SUBSCRIBER_SERVICE="/home/dirpic/dirPicSubscriber/service/subscriber.service"
APP_BINARY_PUBLISHER_SERVICE="/home/dirpic/dirPicPublisher/service/publisher.service"

SERVICE_FILES_DIRECTORY="/etc/systemd/system/"

# broker information
BROKER_IP=$1
BROKER_PORT=$2
BROKER_CHANNEL=$3
BROKER_USER=$4
BROKER_USER_PASSWORD=$5

### create file strings
APP_BINARY_SUBSCRIBER_START_SCRIPT="
#!/bin/bash
/bin/java -jar "$APP_BINARY_PUBLISHER" "$BROKER_PORT" "$BROKER_CHANNEL" "$APP_CAMERA_DIRECTORY" "$APP_KEYSTORE_DIRECTORY" "$BROKER_USER" "$BROKER_USER_PASSWORD"
"
APP_BINARY_PUBLISHER_START_SCRIPT="
#!/bin/bash
/bin/java -jar "$APP_BINARY_SUBSCRIBER" "$BROKER_PORT" "$BROKER_CHANNEL" "$APP_STORAGE_DIRECTORY" "$APP_KEYSTORE_DIRECTORY" "$BROKER_USER" "$BROKER_USER_PASSWORD"
"

### create user
/bin/sudo /bin/useradd -p $APP_USER_PASSWORD_SHA256_HASH $APP_USER -r -d $APP_USER_HOME_DIRECTORY

### make app user sudoer only for /bin/java
# add app user to sudo group in /etc/group
/bin/sudo usermod -a -G /bin/sudo $APP_USER

# modify app user's sudo privs, restricting it to only use /bin/java in sudo context
/bin/sudo /bin/echo APP_USER_PRIV_SUDOERS_STRING > /etc/sudoers # maybe wrong operator

### create app structure
# create directories
/bin/mkdir $APP_USER_HOME_DIRECTORY
/bin/mkdir $APP_RUNTIME_DIRECTORY
/bin/mkdir $APP_BINARY_DIRECTORY
/bin/mkdir $APP_KEYSTORE_DIRECTORY
/bin/mkdir $APP_CAMERA_DIRECTORY
/bin/mkdir $APP_STORAGE_DIRECTORY

# clone git repositories
/usr/bin/git clone $GIT_BINARY_PUBLISHER_LINK
/usr/bin/git clone $GIT_BINARY_SUBSCRIBER_LINK

# copy binary files from git repository to app directory
/bin/cp $GIT_BINARY_SUBSCRIBER $APP_BINARY_DIRECTORY
/bin/cp $GIT_BINARY_PUBLISHER $APP_BINARY_DIRECTORY
/bin/cp $GIT_BINARY_SUBSCRIBER_SERVICE $APP_BINARY_DIRECTORY
/bin/cp $GIT_BINARY_PUBLISHER_SERVICE $APP_BINARY_DIRECTORY

### create and copy binary files
# create file
/bin/touch $APP_BINARY_SUBSCRIBER_START
/bin/touch $APP_BINARY_PUBLISHER_START

# load file
/bin/echo $APP_BINARY_PUBLISHER_START_SCRIPT >> $APP_BINARY_PUBLISHER_START # maybe wrong operator
/bin/echo $APP_BINARY_SUBSCRIBER_START_SCRIPT >> $APP_BINARY_SUBSCRIBER_START

# turn shell files into binaries
/usr/bin/shc -T -f $APP_BINARY_PUBLISHER_START
/usr/bin/shc -T -f $APP_BINARY_SUBSCRIBER_START

# move binary shell files to /usr/bin/
/bin/mv "${APP_BINARY_PUBLISHER_START}.x" "/usr/bin/${APP_BINARY_PUBLISHER_START}"
/bin/mv "${APP_BINARY_SUBSCRIBER_START}.x" "/usr/bin/${APP_BINARY_SUBSCRIBER_START}"

### move service files to system.d
/bin/cp $APP_BINARY_SUBSCRIBER_SERVICE $SERVICE_FILES_DIRECTORY
/bin/cp $APP_BINARY_PUBLISHER_SERVICE $SERVICE_FILES_DIRECTORY
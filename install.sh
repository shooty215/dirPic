#!/bin/bash

#       inputs: [$1:BROKER_IP] [$2:BROKER_PORT] [$3:BROKER_CHANNEL]   #
#               [$4:BROKER_USER] [$5:BROKER_USER_PASSWORD]            #
# 1# recieve script's parameters and initialize magic variables
# 2# create file strings
# 3# create user
# 4# make app user sudoer only for /bin/java
# 5# create app structure
# 6# create and copy binary files 
# 7# move service files to system.d
# 8# echo user credentials into file
# 9# enable services


### recieve script's parameters and initialize magic variables
# app user information
APP_USER="dirpic"
APP_USER_PASSWORD_PLAIN_TEXT=$(/usr/bin/openssl rand 1000 | strings | grep -io [[:alnum:]] | head -n 16 | tr -d '\n')
APP_USER_PASSWORD_SHA256_HASH=$(/usr/bin/openssl passwd -5 "$APP_USER_PASSWORD_PLAIN_TEXT")
APP_USER_PRIV_SUDOERS_STRING="dirpic ALL=(ALL) NOPASSWD:/usr/bin/java"

# directories
APP_USER_HOME_DIRECTORY="/home/$APP_USER/"
APP_ENV_ROOT_DIRECTORY=$APP_USER_HOME_DIRECTORY"root/"
APP_ENV_DIRECTORY=$APP_USER_HOME_DIRECTORY"env/"
APP_TMP_DIRECTORY=$APP_USER_HOME_DIRECTORY"tmp/"
APP_RUNTIME_DIRECTORY=$APP_USER_HOME_DIRECTORY"runtime/"
APP_KEYSTORE_DIRECTORY=$APP_USER_HOME_DIRECTORY"keystores/"
APP_BINARY_DIRECTORY=$APP_USER_HOME_DIRECTORY"binaries/"
APP_CAMERA_DIRECTORY=$APP_USER_HOME_DIRECTORY"camera/"
APP_STORAGE_DIRECTORY=$APP_USER_HOME_DIRECTORY"storage/"

# files and hyper links
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

SERVICE_FILES_DIRECTORY="/etc/systemd/system/"

# broker information
BROKER_IP=$1
BROKER_PORT=$2
BROKER_CHANNEL=$3
BROKER_USER=$4
BROKER_USER_PASSWORD=$5

# ca password

CA_PASSWORD=$6

### create file strings
APP_BINARY_SUBSCRIBER_START_SCRIPT="
#!/bin/bash\n
/usr/bin/sudo /usr/bin/java -jar $APP_BINARY_SUBSCRIBER $BROKER_IP $BROKER_PORT $BROKER_CHANNEL $APP_STORAGE_DIRECTORY $APP_KEYSTORE_DIRECTORY $BROKER_USER $BROKER_USER_PASSWORD $CA_PASSWORD
"
APP_BINARY_PUBLISHER_START_SCRIPT="
#!/bin/bash\n
/usr/bin/sudo /usr/bin/java -jar $APP_BINARY_PUBLISHER $BROKER_IP $BROKER_PORT $BROKER_CHANNEL $APP_CAMERA_DIRECTORY $APP_KEYSTORE_DIRECTORY $BROKER_USER $BROKER_USER_PASSWORD $CA_PASSWORD
"

### create user
/usr/bin/sudo /usr/sbin/useradd -p $APP_USER_PASSWORD_SHA256_HASH $APP_USER -r -d $APP_USER_HOME_DIRECTORY
#/usr/bin/sudo /usr/sbin/useradd -r -m
### make app user sudoer only for /bin/java
# add app user to sudo group in /etc/group
/usr/bin/sudo /usr/sbin/usermod -a -G sudo $APP_USER

# modify app user's sudo privs, restricting it to only use /bin/java in sudo context
/usr/bin/sudo /bin/echo $APP_USER_PRIV_SUDOERS_STRING >> /etc/sudoers

### create app structure
# create directories
/usr/bin/sudo /bin/mkdir $APP_USER_HOME_DIRECTORY
#/usr/bin/sudo /bin/mkdir $APP_ENV_ROOT_DIRECTORY
#/usr/bin/sudo /bin/mkdir $APP_ENV_DIRECTORY
#/usr/bin/sudo /bin/mkdir $APP_TMP_DIRECTORY
#/usr/bin/sudo /bin/mkdir $APP_RUNTIME_DIRECTORY
/usr/bin/sudo /bin/mkdir $APP_BINARY_DIRECTORY
/usr/bin/sudo /bin/mkdir $APP_KEYSTORE_DIRECTORY
/usr/bin/sudo /bin/mkdir $APP_CAMERA_DIRECTORY
/usr/bin/sudo /bin/mkdir $APP_STORAGE_DIRECTORY

## clone git repositories
/usr/bin/sudo /usr/bin/git -C $APP_USER_HOME_DIRECTORY clone $GIT_BINARY_PUBLISHER_LINK 
/usr/bin/sudo /usr/bin/git -C $APP_USER_HOME_DIRECTORY clone $GIT_BINARY_SUBSCRIBER_LINK 

## copy binary files from git repository to app directory
/usr/bin/sudo /bin/cp $GIT_BINARY_SUBSCRIBER $APP_BINARY_DIRECTORY
/usr/bin/sudo /bin/cp $GIT_BINARY_PUBLISHER $APP_BINARY_DIRECTORY
/usr/bin/sudo /bin/cp $GIT_BINARY_SUBSCRIBER_SERVICE $APP_BINARY_DIRECTORY
/usr/bin/sudo /bin/cp $GIT_BINARY_PUBLISHER_SERVICE $APP_BINARY_DIRECTORY

### create and copy binary files
# create file not needed due to > operators functionality (creates the file)
/usr/bin/sudo /bin/touch $APP_BINARY_SUBSCRIBER_START
/usr/bin/sudo /bin/touch $APP_BINARY_PUBLISHER_START

# load file
/usr/bin/sudo /bin/echo -e $APP_BINARY_PUBLISHER_START_SCRIPT > $APP_BINARY_PUBLISHER_START
/usr/bin/sudo /bin/echo -e $APP_BINARY_SUBSCRIBER_START_SCRIPT > $APP_BINARY_SUBSCRIBER_START

# turn shell files into binaries
/usr/bin/sudo /usr/bin/shc -f $APP_BINARY_PUBLISHER_START -o $APP_BINARY_PUBLISHER_START_ACTUAL
/usr/bin/sudo /usr/bin/shc -f $APP_BINARY_SUBSCRIBER_START -o $APP_BINARY_SUBSCRIBER_START_ACTUAL

# move binary shell files to /usr/bin/
/usr/bin/sudo /bin/mv $APP_BINARY_PUBLISHER_START_ACTUAL /usr/bin/${APP_BINARY_PUBLISHER_START_FILENAME}
/usr/bin/sudo /bin/mv $APP_BINARY_SUBSCRIBER_START_ACTUAL /usr/bin/${APP_BINARY_SUBSCRIBER_START_FILENAME}

### move service files to system.d
/usr/bin/sudo /bin/cp $APP_BINARY_SUBSCRIBER_SERVICE $SERVICE_FILES_DIRECTORY
/usr/bin/sudo /bin/cp $APP_BINARY_PUBLISHER_SERVICE $SERVICE_FILES_DIRECTORY

### set privs, ownership and group of app user's home directory, the service and the binary files
# maybe not the service and the binary files

# home directory
/usr/bin/sudo /bin/chmod -R 750 /home/dirpic/
/usr/bin/sudo /bin/chown -R dirpic /home/dirpic/
/usr/bin/sudo /bin/chgrp -R dirpic /home/dirpic/

### echo user password into file
/usr/bin/sudo /bin/echo $APP_USER_PASSWORD_PLAIN_TEXT'|:::::|'$APP_USER_PASSWORD_SHA256_HASH > $APP_USER_HOME_DIRECTORY'encrypt'

### enable services
/usr/bin/sudo /bin/systemctl enable $SERVICE_FILES_DIRECTORY'dirpicpublisher.service'
/usr/bin/sudo /bin/systemctl enable $SERVICE_FILES_DIRECTORY'dirpicsubscriber.service'

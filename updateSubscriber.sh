#!/bin/bash

### set magicz
APP_USER="dirpic"
SERVICE_FILES_DIRECTORY="/etc/systemd/system/"
APP_USER_HOME_DIRECTORY="/home/$APP_USER/"
GIT_BINARY_SUBSCRIBER_LINK="https://github.com/shooty215/dirPicSubscriber.git"
GIT_BINARY_SUBSCRIBER=$APP_USER_HOME_DIRECTORY"dirPicSubscriber/jars/dirPicSubscriber.jar"
APP_BINARY_DIRECTORY=$APP_USER_HOME_DIRECTORY"binaries/"

# files and hyper links
MOTION_CONFIG="motion.conf"

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

# broker information
BROKER_IP=$1
BROKER_PORT=$2
BROKER_CHANNEL=$3
BROKER_USER=$4
BROKER_USER_PASSWORD=$5

# ca password
CA_PASSWORD=$6

# stop service
/usr/bin/sudo /bin/systemctl stop dirpicsubscriber.service

# disable service
/usr/bin/sudo /bin/systemctl disable $SERVICE_FILES_DIRECTORY'dirpicsubscriber.service'

### delete old service

# delete binaries from systems /usr/bin folder
/usr/bin/sudo /bin/rm -f /usr/bin/dirpicsubscriber

# delete service files
/usr/bin/sudo /bin/rm -f $SERVICE_FILES_DIRECTORY'dirpicsubscriber.service'

### delete repository's folder
/usr/bin/sudo /bin/rm -rf $APP_USER_HOME_DIRECTORY'dirPicSubscriber'

### re-clone repository
/usr/bin/sudo /usr/bin/git -C $APP_USER_HOME_DIRECTORY clone $GIT_BINARY_SUBSCRIBER_LINK

### prepare service deployment

APP_BINARY_SUBSCRIBER_START_SCRIPT="
#!/bin/bash\n
/usr/bin/sudo /usr/bin/java -jar $APP_BINARY_SUBSCRIBER $BROKER_IP $BROKER_PORT $BROKER_CHANNEL $APP_STORAGE_DIRECTORY $APP_KEYSTORE_DIRECTORY $BROKER_USER $BROKER_USER_PASSWORD $CA_PASSWORD\n
"
/usr/bin/sudo /bin/cp $GIT_BINARY_SUBSCRIBER $APP_BINARY_DIRECTORY
/usr/bin/sudo /bin/cp $GIT_BINARY_SUBSCRIBER_SERVICE $APP_BINARY_DIRECTORY

### deploy new service version

# create file not needed due to > operators functionality (creates the file)
/usr/bin/sudo /bin/touch $APP_BINARY_SUBSCRIBER_START

# load file
/usr/bin/sudo /bin/echo -e $APP_BINARY_SUBSCRIBER_START_SCRIPT > $APP_BINARY_SUBSCRIBER_START

# turn shell files into binaries
/usr/bin/sudo /usr/bin/shc -f $APP_BINARY_SUBSCRIBER_START -o $APP_BINARY_SUBSCRIBER_START_ACTUAL

# move binary shell files to /usr/bin/
/usr/bin/sudo /bin/mv $APP_BINARY_SUBSCRIBER_START_ACTUAL /usr/bin/${APP_BINARY_SUBSCRIBER_START_FILENAME}

# move service files to system.d
/usr/bin/sudo /bin/cp $APP_BINARY_SUBSCRIBER_SERVICE $SERVICE_FILES_DIRECTORY

# privs
/usr/bin/sudo /bin/chmod -R 750 /home/dirpic/dirPicSubscriber
/usr/bin/sudo /bin/chown -R dirpic /home/dirpic/dirPicSubscriber
/usr/bin/sudo /bin/chgrp -R dirpic /home/dirpic/dirPicSubscriber
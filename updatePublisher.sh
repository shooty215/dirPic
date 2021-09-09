### set magicz
APP_USER="dirpic"
SERVICE_FILES_DIRECTORY="/etc/systemd/system/"
APP_USER_HOME_DIRECTORY="/home/$APP_USER/"
GIT_BINARY_PUBLISHER_LINK="https://github.com/shooty215/dirPicPublisher.git"
GIT_BINARY_PUBLISHER=$APP_USER_HOME_DIRECTORY"dirPicPublisher/jars/dirPicPublisher.jar"
APP_BINARY_DIRECTORY=$APP_USER_HOME_DIRECTORY"binaries/"

# files and hyper links
MOTION_CONFIG="motion.conf"

GIT_BINARY_PUBLISHER_LINK="https://github.com/shooty215/dirPicPublisher.git"
GIT_BINARY_PUBLISHER_LINK="https://github.com/shooty215/dirPicPublisher.git"

GIT_BINARY_PUBLISHER=$APP_USER_HOME_DIRECTORY"dirPicPublisher/jars/dirPicPublisher.jar"
GIT_BINARY_PUBLISHER=$APP_USER_HOME_DIRECTORY"dirPicPublisher/jars/dirPicPublisher.jar"

GIT_BINARY_PUBLISHER_SERVICE=$APP_USER_HOME_DIRECTORY"dirPicPublisher/service/dirpicpublisher.service"
GIT_BINARY_PUBLISHER_SERVICE=$APP_USER_HOME_DIRECTORY"dirPicPublisher/service/dirpicpublisher.service"

APP_BINARY_PUBLISHER=$APP_BINARY_DIRECTORY"dirPicPublisher.jar"
APP_BINARY_PUBLISHER=$APP_BINARY_DIRECTORY"dirPicPublisher.jar"

APP_BINARY_PUBLISHER_START=$APP_BINARY_DIRECTORY"dirPicPublisher.sh"
APP_BINARY_PUBLISHER_START=$APP_BINARY_DIRECTORY"dirPicPublisher.sh"

APP_BINARY_PUBLISHER_START_ACTUAL=$APP_USER_HOME_DIRECTORY"dirPicPublisher.sh"
APP_BINARY_PUBLISHER_START_ACTUAL=$APP_USER_HOME_DIRECTORY"dirPicPublisher.sh"

APP_BINARY_PUBLISHER_START_FILENAME="dirpicpublisher"
APP_BINARY_PUBLISHER_START_FILENAME="dirpicpublisher"

APP_BINARY_PUBLISHER_SERVICE=$APP_USER_HOME_DIRECTORY"dirPicPublisher/service/dirpicpublisher.service"
APP_BINARY_PUBLISHER_SERVICE=$APP_USER_HOME_DIRECTORY"dirPicPublisher/service/dirpicpublisher.service"


# stop service
/usr/bin/sudo /bin/systemctl stop dirpicpublisher.service

# disable service
/usr/bin/sudo /bin/systemctl disable $SERVICE_FILES_DIRECTORY'dirpicpublisher.service'

### delete old service

# delete binaries from systems /usr/bin folder
/usr/bin/sudo /bin/rm -f /usr/bin/dirpicpublisher

# delete service files
/usr/bin/sudo /bin/rm -f $SERVICE_FILES_DIRECTORY'dirpicpublisher.service'

### delete repository's folder
/usr/bin/sudo /bin/rm -rf $APP_USER_HOME_DIRECTORY'dirPicPublisher'

### re-clone repository
/usr/bin/sudo /usr/bin/git -C $APP_USER_HOME_DIRECTORY clone $GIT_BINARY_PUBLISHER_LINK

### prepare service deployment

APP_BINARY_PUBLISHER_START_SCRIPT="
#!/bin/bash\n
/usr/bin/sudo /usr/bin/java -jar $APP_BINARY_PUBLISHER $BROKER_IP $BROKER_PORT $BROKER_CHANNEL $APP_STORAGE_DIRECTORY $APP_KEYSTORE_DIRECTORY $BROKER_USER $BROKER_USER_PASSWORD $CA_PASSWORD\n
"

## copy binary files from git repository to app directory
/usr/bin/sudo /bin/cp $GIT_BINARY_PUBLISHER $APP_BINARY_DIRECTORY
/usr/bin/sudo /bin/cp $GIT_BINARY_PUBLISHER_SERVICE $APP_BINARY_DIRECTORY
#!/bin/bash

### deploy new service version

# create file not needed due to > operators functionality (creates the file)
/usr/bin/sudo /bin/touch $APP_BINARY_PUBLISHER_START

# load file
/usr/bin/sudo /bin/echo -e $APP_BINARY_PUBLISHER_START_SCRIPT > $APP_BINARY_PUBLISHER_START

# turn shell files into binaries
/usr/bin/sudo /usr/bin/shc -f $APP_BINARY_PUBLISHER_START -o $APP_BINARY_PUBLISHER_START_ACTUAL

# move binary shell files to /usr/bin/
/usr/bin/sudo /bin/mv $APP_BINARY_PUBLISHER_START_ACTUAL /usr/bin/${APP_BINARY_PUBLISHER_START_FILENAME}

# move service files to system.d
/usr/bin/sudo /bin/cp $APP_BINARY_PUBLISHER_SERVICE $SERVICE_FILES_DIRECTORY

# privs
/usr/bin/sudo /bin/chmod -R 750 /home/dirpic/dirPicPublisher
/usr/bin/sudo /bin/chown -R dirpic /home/dirpic/dirPicPublisher
/usr/bin/sudo /bin/chgrp -R dirpic /home/dirpic/dirPicPublisher
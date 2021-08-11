#!/bin/bash
### MAGICZ
APP_USER="dirpic"

APP_USER_HOME_DIRECTORY="/home/$APP_USER/"

APP_BINARY_DIRECTORY=$APP_USER_HOME_DIRECTORY"binaries/"

APP_BINARY_SUBSCRIBER=$APP_BINARY_DIRECTORY"dirPicSubscriber.jar"
APP_BINARY_PUBLISHER=$APP_BINARY_DIRECTORY"dirPicPublisher.jar"

APP_BINARY_SUBSCRIBER_START=$APP_BINARY_DIRECTORY"dirPicSubscriber.sh"
APP_BINARY_PUBLISHER_START=$APP_BINARY_DIRECTORY"dirPicPublisher.sh"

APP_BINARY_SUBSCRIBER_START_ACTUAL=$APP_USER_HOME_DIRECTORY"dirPicSubscriber.sh"
APP_BINARY_PUBLISHER_START_ACTUAL=$APP_USER_HOME_DIRECTORY"dirPicPublisher.sh"

APP_BINARY_SUBSCRIBER_START_FILENAME="dirpicsubscriber"
APP_BINARY_PUBLISHER_START_FILENAME="dirpicpublisher"

### take inputs
# broker information
BROKER_IP=$1
BROKER_PORT=$2
BROKER_CHANNEL=$3
BROKER_USER=$4
BROKER_USER_PASSWORD=$5

# ca password

CA_PASSWORD=$6

### stop services
/usr/bin/sudo systemctl stop dirpicsubscriber.service
/usr/bin/sudo systemctl stop dirpicpublisher.service

### create file strings
APP_BINARY_SUBSCRIBER_START_SCRIPT="
#!/bin/bash\n
/usr/bin/sudo /usr/bin/java -jar $APP_BINARY_SUBSCRIBER $BROKER_IP $BROKER_PORT $BROKER_CHANNEL $APP_STORAGE_DIRECTORY $APP_KEYSTORE_DIRECTORY $BROKER_USER $BROKER_USER_PASSWORD $CA_PASSWORD
"
APP_BINARY_PUBLISHER_START_SCRIPT="
#!/bin/bash\n
/usr/bin/sudo /usr/bin/java -jar $APP_BINARY_PUBLISHER $BROKER_IP $BROKER_PORT $BROKER_CHANNEL $APP_CAMERA_DIRECTORY $APP_KEYSTORE_DIRECTORY $BROKER_USER $BROKER_USER_PASSWORD $CA_PASSWORD
"

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

### start services
/usr/bin/sudo systemctl start dirpicsubscriber.service
/usr/bin/sudo systemctl start dirpicpublisher.service
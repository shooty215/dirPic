# dirPic

Installer repository for the dirPicPublisher and dirPicSubscriber services.

## DESCRIPTION

Delivers a mqtt-publisher/-subscriber and is meant to run with a mqtt-broker, like mosquitto.
Creates application user with home directory, holding all files and locations.
The install binaries need tls-keys and motion.conf.
Added publisher- and subscriber-services start motion automatically, so the camera is essential to run (as of now).
Broker has to be set with the right authentication and authorization details (ca file and users).

Holds binaries to create tls-keys and -certificates. As well as binaries, updating the broker-information used by the application.

More information can be found in the dirPic.pdf provided by this repository.

What's next:

-Documentation pdf coming soon.

-Key binaries will get inputs to select algorithm.

-App user will be changed to system user.

## HOW-TO-INSTALL

Add motion.conf, ca_cert.pem (server certificate), client_crt.pem and client_key.pem must be added to the repository folder before running install binaries.

Run install.sh as privileged user and with according inputs:

/usr/bin/sudo /bin/bash install.sh [$1:BROKER_IP] [$2:BROKER_PORT] [$3:BROKER_CHANNEL] [$4:BROKER_USER] [$5:BROKER_USER_PASSWORD] [$6:CA_PASSWORD]

HINTS:
    -Before installing you may want to change the folders used. Just change the install.sh to your liking.
    -If you wish to run the camera with a different program than motion, delete the motion references from the
     install.sh/updateBrokerInformation.sh.

## HOW-TO-UNINSTALL

Run uninstall.sh as privileged user

/usr/bin/sudo /bin/bash uninstall.sh

## CREATE-NEW-KEYS

Enter information twice, identically!

/usr/bin/sudo /bin/bash createNewKeyPair.sh

## HANDLE-SERVICES

### ENABLE-SPECIFIC-SERVICE

/usr/bin/sudo /bin/bash enablePub.sh

/usr/bin/sudo /bin/bash enableSub.sh

### START-SERVICE

/usr/bin/sudo /usr/bin/systemctl start dirpicsubscriber.service

/usr/bin/sudo /usr/bin/systemctl start dirpicpublisher.service

### STOP-SERVICE

/usr/bin/sudo /usr/bin/systemctl stop dirpicsubscriber.service

/usr/bin/sudo /usr/bin/systemctl stop dirpicpublisher.service

### SERVICE-STATUS

/usr/bin/sudo /usr/bin/systemctl status dirpicsubscriber.service

/usr/bin/sudo /usr/bin/systemctl status dirpicpublisher.service

## UPDATE-BROKER-INFORMATION

/usr/bin/sudo /bin/bash updateBrokerInformation.sh [$1:BROKER_IP] [$2:BROKER_PORT] [$3:BROKER_CHANNEL] [$4:BROKER_USER] [$5:BROKER_USER_PASSWORD] [$6:CA_PASSWORD]

## UPDATE-SUBSCRIBER

/usr/bin/sudo /bin/bash updateSubscriber.sh [$1:BROKER_IP] [$2:BROKER_PORT] [$3:BROKER_CHANNEL] [$4:BROKER_USER] [$5:BROKER_USER_PASSWORD] [$6:CA_PASSWORD]

## UPDATE-PUBLISHER

/usr/bin/sudo /bin/bash updatePublisher.sh [$1:BROKER_IP] [$2:BROKER_PORT] [$3:BROKER_CHANNEL] [$4:BROKER_USER] [$5:BROKER_USER_PASSWORD] [$6:CA_PASSWORD]

## DEPLOY-NEW-PEMS-OR-MOTION-CONFIG

Copy or create new files to/ in repository's folder and run one of the following commands:

/usr/bin/sudo /bin/bash deployNewServerCa.sh

/usr/bin/sudo /bin/bash deployNewKeyPair.sh

/usr/bin/sudo /bin/bash deployNewMotionConfig.sh

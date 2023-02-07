# dirPic

Installer repository for the dirPicPublisher and dirPicSubscriber services.

## DESCRIPTION

Delivers a mqtt-publisher/-subscriber and is meant to run with a mqtt-broker, like mosquitto.
Creates application user with home directory, holding all files and locations.
The install binaries need tls-/als-keys and motion.conf.
Added publisher- and subscriber-services start motion automatically, so the camera is essential to run (as of now).
Broker has to be set with the right authentication and authorization details (ca/ cert files and users).

Holds binaries to create tls-/als-keys and -certificates. As well as binaries, updating the broker-information used by the application.

More information can be found in the dirPic.pdf provided by this repository.

What's next:

-Documentation pdf coming soon.

-Key binaries will get inputs to select algorithm.

-App user will be changed to system user.

## HOW-TO-INSTALL

Add motion.conf, ca_cert.pem (server certificate), client_crt.pem and client_key.pem must be added to the repository folder before running install binaries.

Run install.sh as privileged user and with according inputs:

/bin/bash install.sh [$1:BROKER_IP] [$2:BROKER_PORT] [$3:BROKER_CHANNEL] [$4:BROKER_USER] [$5:BROKER_USER_PASSWORD] [$6:CA_PASSWORD]

HINTS:
    -Before installing you may want to change the folders in use. Just change the install.sh to your liking.
    -If you wish to run the camera with a different program than motion, delete the motion references from the
     install.sh/updateBrokerInformation.sh.

## 1: create needed encryption

In bin/ there are several binaries to make things easy.

You have to create a ca, keys for the broker, as well as keys for the publisher and subsriber.

Run the following with privileges

1. create the ca certificate

/bin/bash bin/createCaCrt.sh

2. create server certificate and sign it with the ca cert

/bin/bash bin/createBrokerCrtSignedByCa.sh

3. create one client certificate for the publisher and one for the subscriber

/bin/bash bin/createClientCrtSignedByCa.sh

4. rename the files or move them and rerun binaries

5. create als keys

/bin/bash bin/createAlsJson.sh

## HOW-TO-UPDATE

To update the publisher and subscriber, execute a pull request and run update.sh in repository, or re-install, with the respective binaries. Make sure you wan't lose any keys.

git pull

/bin/bash update.sh

/bin/bash uninstall.sh

/bin/bash install.sh

## HOW-TO-UNINSTALL

Run uninstall.sh as privileged user

/bin/bash uninstall.sh

## DEPLOY-NEW-KEYS-AND-CONFIGS

Create the respective files, before

Run with privileges

/bin/bash deployAlsJson.sh

/bin/bash deployMotionConfig.sh

/bin/bash deployNewCaCrt.sh

/bin/bash deployNewKeyPair.sh

/bin/bash deployNewPropertiesJson.sh

## HANDLE-SERVICES

### ENABLE-SPECIFIC-SERVICE

Run with privileges

/bin/bash enablePub.sh

/bin/bash enableSub.sh

### START-SERVICE

Run with privileges

/usr/bin/systemctl start dirpicsubscriber.service

/usr/bin/systemctl start dirpicpublisher.service

### STOP-SERVICE

Run with privileges

/usr/bin/systemctl stop dirpicsubscriber.service

/usr/bin/systemctl stop dirpicpublisher.service

### SERVICE-STATUS

Run with privileges

/usr/bin/systemctl status dirpicsubscriber.service

/usr/bin/systemctl status dirpicpublisher.service

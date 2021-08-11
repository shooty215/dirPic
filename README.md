# dirPic

Installer repository for the dirPicPublisher and dirPicSubscriber services.

As of now, changing the broker's information takes a full re-install.

What's next:
    -A way to update broker information without re-installing everything.

## HOW-TO-INSTALL

run install.sh as privileged user and with according inputs:

/usr/bin/sudo /bin/bash install.sh [$1:BROKER_IP] [$2:BROKER_PORT] [$3:BROKER_CHANNEL] [$4:BROKER_USER] [$5:BROKER_USER_PASSWORD] [$6:CA_PASSWORD]

ca_cert.pem (server certificate), client_crt.pem and client_key.pem must be added to the repository folder manually!

## HOW-TO-UNINSTALL

run uninstall.sh as privileged user

/usr/bin/sudo /bin/bash uninstall.sh

#!/bin/bash
. ../conf/binaries.conf

# notification
echo " "
echo "Copying client_crt.pem and client_key in this directory to /home/dirpic/keystores. Errors:"

# copy pem files to their destination
$SUDO $CP $CLIENT_CRT $CLIENT_CRT_ACTL
$SUDO $CP $CLIENT_KEY_PEM $CLIENT_KEY_PEM_ACTL
#/usr/bin/sudo /bin/cp deployables/clientCrt.pem /home/dirpic/certificate/client_crt.pem
#/usr/bin/sudo /bin/cp deployables/clientKey.pem /home/dirpic/certificate/client_key.pem
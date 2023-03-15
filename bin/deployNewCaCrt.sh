#!/bin/bash

# notification
echo " "
echo "Copying cacrt.pem in this directory to /home/dirpic/keystores. Errors:"

# copy pem file to its' destination
$SUDO  $CP $CA_CRT $CA_CRT_ACTL
#/usr/bin/sudo /bin/cp deployables/caCrt.pem /home/dirpic/certificates/ca_crt.pem
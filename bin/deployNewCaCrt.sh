#!/bin/bash

# notification
echo " "
echo "Copying cacrt.pem in this directory to /home/dirpic/keystores. Errors:"

# copy pem file to its' destination
/usr/bin/sudo /bin/cp deployables/caCrt.pem /home/dirpic/keystores/ca_crt.pem
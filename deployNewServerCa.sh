#!/bin/bash

# notification
echo " "
echo "Copying ca_crt.pem in this directory to /home/dirpic/keystores. Errors:"

# copy pem file to its' destination
/usr/bin/sudo /bin/cp ca_crt.pem /home/dirpic/keystores/ca_crt.pem
#!/bin/bash

# notification
echo " "
echo "Copying client_crt.pem and client_key in this directory to /home/dirpic/keystores. Errors:"

# copy pem files to their destination
/usr/bin/sudo /bin/cp deployables/clientCrt.pem /home/dirpic/keystores/client_crt.pem
/usr/bin/sudo /bin/cp deployables/clientKey.pem /home/dirpic/keystores/client_key.pem
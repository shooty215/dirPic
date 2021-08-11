#!/bin/bash

### stop services
/usr/bin/sudo systemctl stop dirpicsubscriber.service
/usr/bin/sudo systemctl stop dirpicpublisher.service

### create client key and certificate
# create ca key
/usr/bin/openssl genrsa -des3 -out caClient.key 2048

# create ca certificate
/usr/bin/openssl req -new -x509 -days 1826 -key caClient.key -out caClient.crt

# create client key
/usr/bin/openssl genrsa -out client.key 2048

# create client csr
/usr/bin/openssl req -new -out client.csr -key client.key

# create client certificate
/usr/bin/openssl x509 -req -in client.csr -CA caClient.crt -CAkey caClient.key -CAcreateserial -out client.crt -days 360

# pem encode needed files
/usr/bin/openssl x509 -in client.crt -out client_crt.pem -outform PEM
/usr/bin/openssl x509 -in ca.crt -out ca_crt.pem -outform PEM
/usr/bin/openssl rsa -in client.key -text > client_key.pem

# copy pem files to their destination
/usr/bin/sudo /bin/cp caClient_crt.pem /home/dirpic/keystores/caClient_crt.pem
/usr/bin/sudo /bin/cp client_crt.pem /home/dirpic/keystores/client_crt.pem
/usr/bin/sudo /bin/cp client_key.pem /home/dirpic/keystores/client_key.pem

# remove all used and now unnecessary files
/usr/bin/sudo /bin/rm -rf caClient.key
/usr/bin/sudo /bin/rm -rf caClient.crt
/usr/bin/sudo /bin/rm -rf client.key
/usr/bin/sudo /bin/rm -rf client.csr
/usr/bin/sudo /bin/rm -rf client.crt
/usr/bin/sudo /bin/rm -rf caClient_crt.pem
/usr/bin/sudo /bin/rm -rf client_crt.pem
/usr/bin/sudo /bin/rm -rf client_key.pem

### start services
/usr/bin/sudo systemctl start dirpicsubscriber.service
/usr/bin/sudo systemctl start dirpicpublisher.service
#!/bin/bash

OPENSSL_CMD="/usr/bin/openssl"

CA_KEY="deployables/ca.key"
CA_CRT="deployables/caCrt.pem"
CA_EXTFILE="config/ca_cert.cnf"

## generate rootCA private key
echo " "
echo "Generating CA's private key"
echo " "
$OPENSSL_CMD genrsa -out $CA_KEY 4096
echo " "

## generate rootCA certificate
echo " "
echo "Generating CA's certificate"
echo " "
$OPENSSL_CMD req -new -x509 -days 3650 -config $CA_EXTFILE -key $CA_KEY -out $CA_CRT
echo " "

## read the certificate
echo " "
echo "Verify RootCA certificate"
echo " "
$OPENSSL_CMD  x509 -noout -text -in $CA_CRT
echo " "

echo " "
echo "Turning Keys To PEM"
$OPENSSL_CMD rsa -in $CA_KEY -text > $CA_KEY_PEM
echo " "

echo " "
echo "Deleting Unwanted Files"
rm -rf bin/deployables/caCrt.srl
echo " "
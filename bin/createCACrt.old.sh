#!/bin/bash
. ../conf/binaries.conf

## generate deffie-hellmann parameter
echo " "
echo "Generating Deffie-Hellmann Parameter"
echo " "
$OPENSSL_CMD dhparam -out $DH_PARAMETER $DH_KEY_LENGTH
echo " "

## generate rootCA private key
echo " "
echo "Generating CA's private key"
echo " "
$OPENSSL_CMD genrsa -out $CA_KEY $RSA_KEY_LENGTH
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
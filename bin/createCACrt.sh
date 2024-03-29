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
#$OPENSSL_CMD genrsa -out $CA_KEY $RSA_KEY_LENGTH
$OPENSSL_CMD genpkey -algorithm RSA -out $CA_KEY -pkeyopt rsa_keygen_bits:$RSA_KEY_LENGTH -aes256
echo " "

## generate rootCA certificate
echo " "
echo "Generating CA's certificate"
echo " "
#$OPENSSL_CMD req -new -x509 -days 3650 -config $CA_EXTFILE -key $CA_KEY -out $CA_CRT
$OPENSSL_CMD req -new -x509 -days $CA_DAYS -key $CA_KEY -out $CA_CRT \
-config <(cat $CRT_CONFIG \
<(printf "\n[ca]\nbasicConstraints = critical,CA:true\nsubjectKeyIdentifier=hash\nauthorityKeyIdentifier=keyid:always,issuer:always\n")) \
-SHA256
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
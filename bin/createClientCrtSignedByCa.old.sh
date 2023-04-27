#!/bin/bash
. ../conf/binaries.conf

echo " "
echo "Generating client private key"
echo " "
$OPENSSL_CMD genrsa -out $CLIENT_KEY 4096
echo " "

echo " "
echo "Generating certificate signing request for client"
echo " "
$OPENSSL_CMD req -new -key $CLIENT_KEY -out $CLIENT_CSR -config $CLIENT_CONF
echo " "

echo " "
echo "Generating RootCA signed client certificate"
echo " "
$OPENSSL_CMD x509 -req -in $CLIENT_CSR -CA $CA_CRT -CAkey $CA_KEY -out $CLIENT_CRT -CAcreateserial -days 365 -sha512
echo " "

echo " "
echo "Turning Keys To PEM"
$OPENSSL_CMD rsa -in $CLIENT_KEY -text > $CLIENT_KEY_PEM
echo " "

echo " "
echo "Deleting Unwanted Files"
rm -rf deployables/caCrt.srl
rm -rf $CLIENT_CSR
echo " "
#!/bin/bash

CA_KEY="deployables/ca.key"
CA_CRT="deployables/serverCrt.pem"
CA_EXTFILE="config/ca_cert.cnf"

CLIENT_KEY="deployables/client.key"
CLIENT_CSR="deployables/client.csr"
CLIENT_CRT="deployables/clientCrt.pem"

CLIENT_EXT="config/client_cert.cnf"
CLIENT_CONF="config/client_cert.cnf"

CA_KEY_PEM="deployables/serverKey.pem"
CLIENT_KEY_PEM="deployables/clientKey.pem"

OPENSSL_CMD="/usr/bin/openssl"
#COMMON_NAME="$1"

## generate rootCA private key
echo " "
echo "Generating Server CA's private key"
echo " "
$OPENSSL_CMD genrsa -out $CA_KEY 2048
echo " "

## generate rootCA certificate
echo " "
echo "Generating Server CA's certificate"
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
echo "Generating client private key"
echo " "
$OPENSSL_CMD genrsa -out $CLIENT_KEY 2048
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
echo "Verifying the client certificate against RootCA"
echo " "
$OPENSSL_CMD  x509 -noout -text -in $CLIENT_CRT
#$OPENSSL_CMD verify -CAfile $CA_CRT $SERVER_CRT # doesn't work properly
echo " "

echo " "
echo "Turning Keys To PEM"
$OPENSSL_CMD rsa -in $CA_KEY -text > $CA_KEY_PEM
$OPENSSL_CMD rsa -in $CLIENT_KEY -text > $CLIENT_KEY_PEM
echo " "

echo " "
echo "Deleting Unwanted Files"
rm -rf $CA_KEY
rm -rf $CLIENT_KEY
rm -rf $CLIENT_CSR
rm -rf deployables/cacert.srl
rm -rf deployables/serverCrt.srl
echo " "
#!/bin/bash

CA_KEY="deployables/serverKey.pem"
CA_CRT="deployables/serverCrt.pem"
CA_EXTFILE="config/ca_cert.cnf"

CLIENT_PRIVATE_KEY="deployables/client.key"
CLIENT_CSR="deployables/client.csr"
CLIENT_CRT="deployables/clientCrt.pem"

CLIENT_EXT="config/client_cert.cnf"
CLIENT_CONF="config/client_cert.cnf"

CLIENT_PRIVATE_KEY_PEM="deployables/clientKey.pem"

OPENSSL_CMD="/usr/bin/openssl"


echo " "
echo "Generating client private key"
echo " "
$OPENSSL_CMD genrsa -out $CLIENT_PRIVATE_KEY 4096
echo " "

echo " "
echo "Generating certificate signing request for client"
echo " "
$OPENSSL_CMD req -new -key $CLIENT_PRIVATE_KEY -out $CLIENT_CSR -config $CLIENT_CONF
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
$OPENSSL_CMD rsa -in $CLIENT_PRIVATE_KEY -text > $CLIENT_PRIVATE_KEY_PEM
echo " "

echo " "
echo "Deleting Unwanted Files"
rm -rf $CLIENT_PRIVATE_KEY
rm -rf $CLIENT_CSR
rm -rf deployables/serverCrt.srl
echo " "
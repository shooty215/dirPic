#!/bin/bash
CA_KEY="deployables/ca.key"
CA_CRT="deployables/caCrt.pem"

BROKER_KEY="deployables/broker.key"
BROKER_CSR="deployables/broker.csr"
BROKER_CRT="deployables/brokerCrt.pem"

BROKER_CONF="config/broker_cert.cnf"

BROKER_KEY_PEM="deployables/brokerKey.pem"

echo " "
echo "Generating broker private key"
echo " "
$OPENSSL_CMD genrsa -out $BROKER_KEY 4096
echo " "

echo " "
echo "Generating certificate signing request for broker"
echo " "
$OPENSSL_CMD req -new -key $BROKER_KEY -out $BROKER_CSR -config $BROKER_CONF
echo " "

echo " "
echo "Generating RootCA signed broker certificate"
echo " "
$OPENSSL_CMD x509 -req -in $BROKER_CSR -CA $CA_CRT -CAkey $CA_KEY -out $BROKER_CRT -CAcreateserial -days 365 -sha512
echo " "

echo " "
echo "Turning Keys To PEM"
$OPENSSL_CMD rsa -in $BROKER_KEY -text > $BROKER_KEY_PEM
echo " "

echo " "
echo "Deleting Unwanted Files"
rm -rf $BROKER_CSR
echo " "
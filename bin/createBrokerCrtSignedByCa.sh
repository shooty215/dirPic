#!/bin/bash
. ../conf/binaries.conf

echo " "
echo "Generating broker private key"
echo " "
#$OPENSSL_CMD genrsa -out $BROKER_KEY 4096
$OPENSSL_CMD genpkey -algorithm RSA -out $BROKER_KEY -pkeyopt rsa_keygen_bits:$RSA_KEY_LENGTH -aes256
echo " "

echo " "
echo "Generating certificate signing request for broker"
echo " "
#$OPENSSL_CMD req -new -key $BROKER_KEY -out $BROKER_CSR -config $BROKER_CONF
$OPENSSL_CMD req -new -key $BROKER_KEY -out $BROKER_CSR
echo " "

echo " "
echo "Generating RootCA signed broker certificate"
echo " "
#$OPENSSL_CMD x509 -req -in $BROKER_CSR -CA $CA_CRT -CAkey $CA_KEY -out $BROKER_CRT -CAcreateserial -days 365 -sha512
$OPENSSL_CMD x509 -req -days $CRT_DAYS -in $BROKER_CSR -signkey $BROKER_KEY -out $BROKER_CRT \
-extfile <(printf "subjectAltName=DNS:example.com") \
-extensions $CRT_EXTENSIONS \
-config <(cat $CRT_CONFIG \
<(printf "\n[$CRT_EXTENSIONS]\nextendedKeyUsage = $CRT_KEY_USAGE\nsubjectAltName=DNS:$CRT_URL")) \
-DIFFIE-HELLMAN-PARAMETERS -DH_PARAMETERS $DH_PARAMETER \
-CIPHERSUITES $CRT_CIPHERSUITES \
-SIGNATURE_ALGORITHMS $CRT_SIGNATURE_ALGORITHMS
echo " "

echo " "
echo "Turning Keys To PEM"
$OPENSSL_CMD rsa -in $BROKER_KEY -text > $BROKER_KEY_PEM
echo " "

echo " "
echo "Deleting Unwanted Files"
rm -rf deployables/caCrt.srl
rm -rf $BROKER_CSR
echo " "
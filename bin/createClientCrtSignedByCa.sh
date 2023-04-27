#!/bin/bash
. ../conf/binaries.conf

echo " "
echo "Generating client private key"
echo " "
#$OPENSSL_CMD genrsa -out $CLIENT_KEY 4096
$OPENSSL_CMD genpkey -algorithm RSA -out $CLIENT_KEY -pkeyopt rsa_keygen_bits:$RSA_KEY_LENGTH -aes256
echo " "

echo " "
echo "Generating certificate signing request for client"
echo " "
#$OPENSSL_CMD req -new -key $CLIENT_KEY -out $CLIENT_CSR -config $CLIENT_CONF
$OPENSSL_CMD req -new -key $CLIENT_KEY -out $CLIENT_CSR
echo " "

echo " "
echo "Generating RootCA signed client certificate"
echo " "
#$OPENSSL_CMD x509 -req -in $CLIENT_CSR -CA $CA_CRT -CAkey $CA_KEY -out $CLIENT_CRT -CAcreateserial -days 365 -sha512
$OPENSSL_CMD x509 -req -days $CRT_DAYS -in $CLIENT_CSR -signkey $CLIENT_KEY -out $CLIENT_CRT \
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
$OPENSSL_CMD rsa -in $CLIENT_KEY -text > $CLIENT_KEY_PEM
echo " "

echo " "
echo "Deleting Unwanted Files"
rm -rf deployables/caCrt.srl
rm -rf $CLIENT_CSR
echo " "

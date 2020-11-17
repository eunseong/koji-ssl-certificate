#!/bin/bash
#if you change your certificate authority name to something else you will need to change the caname value to reflect the change.
caname=koji

# user is equal to parameter one or the first argument when you actually run the script
user=$1

openssl genrsa -out certs/${user}.key 2048
cat ssl.cnf | sed 's/YOUR_KOJI_HOSTNAME/'${user}'/'> ssl2.cnf
openssl req -config ssl2.cnf -new -nodes -out certs/${user}.csr -key certs/${user}.key
openssl ca -config ssl2.cnf -keyfile private/${caname}_ca_cert.key -cert ${caname}_ca_cert.crt -out certs/${user}.crt -outdir certs -infiles certs/${user}.csr
cat certs/${user}.crt certs/${user}.key > ${user}.pem
mv ssl2.cnf config/${user}-ssl.cnf

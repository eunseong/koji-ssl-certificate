# koji-ssl-certificate
This project provides a simple guide and some script files for setting up the Koji Root CA using SSL certificates.

First, clone this project
```shell
~$ cd ~
~$ git clone https://github.com/eunseong/koji-ssl-certificate.git
```
Modify the [req_distinguished_name] section in `koji/ssl.cnf` to fit you  <br/>
![스크린샷 2020-11-17 오후 3 25 17](https://user-images.githubusercontent.com/9551173/99354099-1a613000-28e9-11eb-8ad3-499626d13b2b.png) <br/>


Next, follw the commands below to create the certificate of the root CA
```shell
~$ cd ./koji-ssl-certificate/koji/
~$ openssl genrsa -out private/koji_ca_cert.key 2048
~$ openssl req -config ssl.cnf -new -x509 -days 3650 -key private/koji_ca_cert.key -out koji_ca_cert.crt -extensions v3_ca
```
then now you can find the `koji_ca_cert.crt` file


Finally we can generate the ssl certificate which can be used by koji users (koji-hub[server], koji-daemon[client], ...) <br/>
We can use the script `gen_cert.sh` with argument(koji user name) to create ssl certificate
```shell
./gen_cert.sh ${USER}   #USER="eslee"
```
![eslee](https://user-images.githubusercontent.com/9551173/99356756-0a981a80-28ee-11eb-8a48-c88ffe268ead.png) <br/>


Copy `koji` directory in `/etc/pki/`
```shell
~$ cp -rT ./koji /etc/pki/koji
```

Setting the configs of koji client who uses CLI for koji request
```shell
useradd ${USER} && su ${USER}
mkdir /home/${USER}/.koji
cp /etc/pki/koji/{USER}.pem ~/.koji/client.crt
cp /etc/pki/koji/koji_ca_cert.crt ~/.koji/clientca.crt
cp /etc/pki/koji/koji_ca_cert.crt ~/.koji/serverca.crt
ln -s /etc/koji.conf ~/.koji/config

```

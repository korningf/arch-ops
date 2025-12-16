#!/bin/bash

# Under a corporate or institutional context behind a firewall,
# you may need to install custom certificate authority cacerts.
# Ideally install Gitbash with SChannel to use Windows SSL/TLS.


# Azure Cli Certificates
# https://learn.microsoft.com/en-us/cli/azure/use-azure-cli-successfully-troubleshooting?view=azure-cli-latest#work-behind-a-proxy
# win32 'C:/Program Files (x86)/Microsoft SDKs/Azure/CLI2/Lib/site-packages/certifi/cacert.pem'
# win64 'C:/Program Files/Microsoft SDKs/Azure/CLI2/Lib/site-packages/certifi/cacert.pem'

# windows cacerts
mkdir -p 'C:/Program Files (x86)/Microsoft SDKs/Azure/CLI2/Lib/site-packages/certifi'
cp cacert.pem 'C:/Program Files (x86)/Microsoft SDKs/Azure/CLI2/Lib/site-packages/certifi/cacert.pem' 
mkdir -p 'C:/Program Files/Microsoft SDKs/Azure/CLI2/Lib/site-packages/certifi'
cp cacert.pem 'C:/Program Files/Microsoft SDKs/Azure/CLI2/Lib/site-packages/certifi/cacert.pem'

# cygwin cacerts
#echo "" >> 'C:/cygwin/etc/ssl/certs/cacert.pem'
#cat cacert.pem >> 'C:/cygwin/etc/ssl/certs/cacert.pem'


# gitbash cacerts
echo "" >> /mingw64/ssl/certs/ca-bundle.crt
cat cacert.pem >>  /mingw64/ssl/certs/ca-bundle.crt



# windows env
export REQUESTS_CA_BUNDLE='C:/Program Files/Microsoft SDKs/Azure/CLI2/Lib/site-packages/certifi/cacert.pem'
setx REQUESTS_CA_BUNDLE 'C:\Program Files\Microsoft SDKs\Azure\CLI2\Lib\site-packages\certifi\cacert.pem'


# python pip
export PIP_CERT='C:/Program Files/Microsoft SDKs/Azure/CLI2/Lib/site-packages/certifi/cacert.pem'
setx PIP_CERT 'C:\Program Files\Microsoft SDKs\Azure\CLI2\Lib\site-packages\certifi\cacert.pem'



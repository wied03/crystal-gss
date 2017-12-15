#!/bin/bash

set -e

KDC_IP=`host -v kdc | grep -E '^kdc\..*' | awk '{print $5}'`
echo "KDC is on IP $KDC_IP, adjusting nameserver config..."

# Want to use ourselves (Samba) for DNS
NEW_RESOLVE=`cat /etc/resolv.conf | sed "s/nameserver.*/nameserver $KDC_IP/"`
printf "$NEW_RESOLVE" > /etc/resolv.conf
# Default DNS search order
echo -e "\ndomain foo.com" >> /etc/resolv.conf

echo "Dumping resolv.conf"
cat /etc/resolv.conf

while [ ! -f "/kerberos_share/samba_ready" ]
do
    echo "Waiting for Samba container to signal its ready"
    sleep 2
done;

while ! nc -z kdc 139
do
    echo "Waiting for Samba KDC to come up on port 139..."
    sleep 2
done;

echo "Samba is up! Calling crystal..."

echo "Getting Kerberos ticket via kinit"
echo -e "$BRADY_PASSWORD\n" | kinit brady@FOO.COM

cd /source
make clean
make
./kerbclient

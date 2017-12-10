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

exec bash -l

#!/bin/bash

set -e

# Want to use ourselves (Samba) for DNS and not the Docker engine provided DNS
NEW_RESOLVE=`cat /etc/resolv.conf | sed 's/nameserver.*/nameserver 127.0.0.1/'`
printf "$NEW_RESOLVE" > /etc/resolv.conf
# Default DNS search order
echo -e "\ndomain foo.com" >> /etc/resolv.conf

echo "Dumping resolv.conf"
cat /etc/resolv.conf

echo "Dumping hosts..."
cat /etc/hosts

# Domain provision tool fails if this exists already and the OS package already has this file
rm /etc/samba/smb.conf

# Doing this in here instead of the image because the container's IP may change
# OS package has a default config, tool will fail if we don't remove it first
# RFC2307 - https://wiki.samba.org/index.php/Setting_up_RFC2307_in_AD
# If we don't specify hostname, it will use a generated docker hostname obtained during the image build process
# Just use Google as the DNS forwarder
/usr/bin/samba-tool domain provision --use-rfc2307 --realm=FOO.COM --domain=FOO --server-role=dc --host-name=kdc --option="dns forwarder = 8.8.8.8" --adminpass=$DOMAIN_ADMIN_PASSWORD
cp -v /var/lib/samba/private/krb5.conf /etc

echo "Starting up Samba temporarily to create reverse DNS entry..."
# Start locally only because we're not "done" yet
/usr/sbin/samba -D
SAMBA_PID=`cat /var/run/samba/samba.pid`

while ! nc -z localhost 139
do
    echo "Waiting for Samba KDC to come up on port 139..."
    sleep 2
done;

echo "Samba is up, Adding reverse DNS entries..."
# TODO: Don't hard code this IP. Docker could change it
/usr/bin/samba-tool dns zonecreate localhost 0.18.172.in-addr.arpa -U administrator --password=$DOMAIN_ADMIN_PASSWORD
/usr/bin/samba-tool dns add localhost 0.18.172.in-addr.arpa 2 PTR kdc.foo.com -U administrator --password=$DOMAIN_ADMIN_PASSWORD

echo "Adding Mock endpoint user into Active Directory..."
/usr/bin/samba-tool user create endpoint --random-password
/usr/bin/samba-tool user setexpiry --noexpiry endpoint
echo "Adding SPN for Mock endpoint into Active Directory..."
/usr/bin/samba-tool spn add HTTP/mock-endpoint.foo.com endpoint

# NOTE: Normally this would all happen via Windows but we're running SQL Server on Linux here so we need
# a way to authenticate to the KDC and validate service tickets destined for us

# Have to do this before keytabs or we get weak keys that aren't good enough for kinit or Java
while ! echo "$DOMAIN_ADMIN_PASSWORD" | kinit --password-file=STDIN administrator
do
    echo "Failed to get admin Kerberos ticket to make enctypes changes, sleeping and retrying..."
    sleep 2
done;

echo "Exporting keytab for Mock endpoint to authenticate to Kerberos..."
net ads enctypes set endpoint

kdestroy

echo "Shutting down Samba at PID ${SAMBA_PID} so that DNS entries will take effect when we start further down..."
kill $SAMBA_PID

/usr/bin/samba-tool domain exportkeytab /kerberos_share/endpoint.keytab --principal=endpoint
/usr/bin/samba-tool domain exportkeytab /kerberos_share/endpoint.keytab --principal=HTTP/mock-endpoint.foo.com

echo "Dumping Endpoint Keytab..."
ktutil -k /kerberos_share/endpoint.keytab list

# Used as a signal
touch /kerberos_share/samba_ready

# Exec = replace the running shell process with Samba, will force signals to go there
# Samba complains if an EOF goes to STDIN, so supply /dev/null in here
exec /usr/sbin/samba -i < /dev/null

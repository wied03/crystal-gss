FROM ubuntu:18.04

# Winbind is needed for Samba to work properly as an AD domain controller
# Don't strictly need the krb5-user package on the KDC because Samba provides most of what we need
# but it's nice to have the utilities for diagnostics
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y samba curl winbind heimdal-clients netcat \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && curl -fsSL https://github.com/krallin/tini/releases/download/v0.9.0/tini-static -o /bin/tini \
    && chmod +x /bin/tini \
    && echo "fa23d1e20732501c3bb8eeeca423c89ac80ed452  /bin/tini" | sha1sum -c -

COPY resources/runsamba.sh /usr/local/bin

# We defer actually creating a domain until the container runs because you don't want to change your IP
# address after you create the domain
CMD ["/bin/tini", "-v", "--", "/usr/local/bin/runsamba.sh"]

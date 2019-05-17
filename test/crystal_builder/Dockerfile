FROM ubuntu:18.04

# Only need gpg/curl to add the Crystal key
RUN apt-get update \
  && apt-get install -y gpg curl \
  && curl -sL "https://keybase.io/crystal/pgp_keys.asc" | apt-key add - \
  && apt-get autoremove -y gpg curl \
  && echo "deb https://dist.crystal-lang.org/apt crystal main" > /etc/apt/sources.list.d/crystal.list \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Allows us to get new versions of Crystal w/o executing earlier step
RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y krb5-user libkrb5-dev libkrb5-dbg make gcc gdb pkg-config crystal netcat \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY crystal.sh /usr/local/bin/

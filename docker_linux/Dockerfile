FROM ubuntu:17.10

# Only need dirmngr to add the Crystal key (09617FD37CC06B54) and this is a slow process
RUN apt-get update \
  && apt-get install -y dirmngr ca-certificates \
  && apt-key adv --keyserver keys.gnupg.net --recv-keys 09617FD37CC06B54 \
  && apt-get autoremove -y dirmngr \
  && echo "deb https://dist.crystal-lang.org/apt crystal main" > /etc/apt/sources.list.d/crystal.list \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Allows us to get new versions of Crystal w/o executing earlier step
RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y krb5-user libkrb5-dev libkrb5-dbg make gcc gdb pkg-config crystal \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY kdc.sh /usr/local/bin/

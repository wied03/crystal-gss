# TODO: Linux version, do a real test inside Docker image
CC=gcc
PKG_CONFIG_PATH_HEIMDAL=/usr/local/opt/heimdal/lib/pkgconfig
CFLAGS=-I. `PKG_CONFIG_PATH=$(PKG_CONFIG_PATH_HEIMDAL) pkg-config --cflags heimdal-gssapi`
LIBS=`PKG_CONFIG_PATH=$(PKG_CONFIG_PATH_HEIMDAL) pkg-config --libs heimdal-gssapi`
# Pass in DEBUG=true as an environment variable to compile Crystal binary w/ debug info
ifeq ($(DEBUG), true)
	DEBUG_FLAGS=-d
endif

# Need to be able to find libbwwrapper.dylib
kerbclient: Main.cr gsslib.cr libgss_extern_variable_fetcher.dylib
	PKG_CONFIG_PATH=$(PKG_CONFIG_PATH_HEIMDAL) crystal build $(DEBUG_FLAGS) --link-flags -L$(PWD) Main.cr -o kerbclient

libgss_extern_variable_fetcher.dylib: gss_extern_variable_fetcher.o
	gcc gss_extern_variable_fetcher.o $(LIBS) -dynamiclib -o libgss_extern_variable_fetcher.dylib

gss_extern_variable_fetcher.o: gss_extern_variable_fetcher.c

clean:
	rm -rf kerbclient *.o *.dylib

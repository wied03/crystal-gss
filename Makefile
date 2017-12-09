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
kerbclient: Main.cr gssapi/*.cr libgss_extern_variable_fetcher.a
	PKG_CONFIG_PATH=$(PKG_CONFIG_PATH_HEIMDAL) crystal build $(DEBUG_FLAGS) --link-flags -L$(PWD) Main.cr -o kerbclient

libgss_extern_variable_fetcher.a: gssapi/gss_extern_variable_fetcher.o
	ar rcs libgss_extern_variable_fetcher.a gssapi/gss_extern_variable_fetcher.o

gssapi/gss_extern_variable_fetcher.o: gssapi/gss_extern_variable_fetcher.c

clean:
	rm -rf kerbclient gssapi/*.o *.a

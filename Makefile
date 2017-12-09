# TODO: Do a real test inside Docker image
CC=gcc
PKG_CONFIG_PATH_HEIMDAL=/usr/local/opt/heimdal/lib/pkgconfig
CFLAGS=-I. `PKG_CONFIG_PATH=$(PKG_CONFIG_PATH_HEIMDAL) pkg-config --cflags heimdal-gssapi`
# Pass in DEBUG=true as an environment variable to compile Crystal binary w/ debug info
ifeq ($(DEBUG), true)
	DEBUG_FLAGS=-d
endif

# On Linux, Crystal's GC lib tries to find the Heimdal ASN lib but probably due to no indirect linking, it doesn't
# find the _end@@HEIMDAL_ASN1_1.0 symbol, which is present in libasn1.so.8
# If we add libasn1 after gc, then it finds it
kerbclient: Main.cr gssapi/*.cr libgss_extern_variable_fetcher.a
	PKG_CONFIG_PATH=$(PKG_CONFIG_PATH_HEIMDAL) crystal build $(DEBUG_FLAGS) --link-flags "-L$(PWD) -lgc -lasn1" Main.cr -o kerbclient

libgss_extern_variable_fetcher.a: gssapi/gss_extern_variable_fetcher.o
	ar rcs libgss_extern_variable_fetcher.a gssapi/gss_extern_variable_fetcher.o

gssapi/gss_extern_variable_fetcher.o: gssapi/gss_extern_variable_fetcher.c

clean:
	rm -rf kerbclient gssapi/*.o *.a

CC=gcc
# Pass in DEBUG=true as an environment variable to compile Crystal binary w/ debug info
ifeq ($(DEBUG), true)
	DEBUG_FLAGS=-d
endif
UNAME_S := $(shell uname -s)
CRYSTAL_LINK_FLAGS=-L$(PWD)
ifeq ($(UNAME_S),Linux)
	# On Linux, Crystal's GC lib tries to find the Heimdal ASN lib but probably due to no indirect linking, it doesn't
	# find the _end@@HEIMDAL_ASN1_1.0 symbol, which is present in libasn1.so.8
	# If we add libasn1 (dependent) after gc (requester), then it finds it
	CRYSTAL_LINK_FLAGS=-L$(PWD) -lgc -lasn1
endif
ifeq ($(UNAME_S),Darwin)
	export PKG_CONFIG_PATH=/usr/local/opt/heimdal/lib/pkgconfig
endif
CFLAGS=-I. `pkg-config --cflags heimdal-gssapi`

ifeq ($(CRYSTAL_LINK_FLAGS),)
	$(error Unsupported OS)
endif

kerbclient: Main.cr gssapi/*.cr libgss_extern_variable_fetcher.a
	crystal build $(DEBUG_FLAGS) --link-flags "$(CRYSTAL_LINK_FLAGS)" Main.cr -o kerbclient

libgss_extern_variable_fetcher.a: gssapi/gss_extern_variable_fetcher.o
	ar rcs libgss_extern_variable_fetcher.a gssapi/gss_extern_variable_fetcher.o

gssapi/%.o: gssapi/%.c

clean:
	rm -rf kerbclient gssapi/*.o *.a

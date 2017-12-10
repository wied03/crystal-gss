# TODO: Use a src style shard layout
# TODO: Tests
# TODO: Figure out how to make this a "binary library" or at least supply the necessary build flags when used in an app

CC=gcc
# Pass in DEBUG=true as an environment variable to compile Crystal binary w/ debug info
ifeq ($(DEBUG), true)
	DEBUG_FLAGS=-d
endif
UNAME_S := $(shell uname -s)
CRYSTAL_LINK_FLAGS=-L$(PWD)/gssapi
ifeq ($(UNAME_S),Linux)
	# On Linux, Crystal's GC lib tries to find the com_err lib but probably due to no indirect linking, it doesn't
	# find a symbol, which is present in com_err
	# If we add com_err (dependent) after gc (requester), then it finds it
	CRYSTAL_LINK_FLAGS=-L$(PWD)/gssapi -lgc -lcom_err
endif
ifeq ($(UNAME_S),Darwin)
	export PKG_CONFIG_PATH=/usr/local/opt/krb5/lib/pkgconfig
endif
CFLAGS=-I. `pkg-config --cflags krb5-gssapi`

ifeq ($(CRYSTAL_LINK_FLAGS),)
	$(error Unsupported OS)
endif

kerbclient: Main.cr gssapi/*.cr gssapi/libgss_extern_variable_fetcher.a
	crystal build $(DEBUG_FLAGS) --link-flags "$(CRYSTAL_LINK_FLAGS)" Main.cr -o kerbclient

gssapi/libgss_extern_variable_fetcher.a: gssapi/gss_extern_variable_fetcher.o
	ar rcs gssapi/libgss_extern_variable_fetcher.a gssapi/gss_extern_variable_fetcher.o

gssapi/%.o: gssapi/%.c

clean:
	rm -rf kerbclient gssapi/*.o gssapi/*.a

# TODO: Use a src style shard layout
# TODO: Tests

# Pass in DEBUG=true as an environment variable to compile Crystal binary w/ debug info
ifeq ($(DEBUG), true)
	DEBUG_FLAGS=-d
endif
UNAME_S := $(shell uname -s)
CRYSTAL_LINK_FLAGS=
ifeq ($(UNAME_S),Darwin)
	export PKG_CONFIG_PATH=/usr/local/opt/krb5/lib/pkgconfig
endif

kerbclient: Main.cr gssapi/*.cr
	crystal build $(DEBUG_FLAGS) Main.cr -o kerbclient

clean:
	rm -rf kerbclient

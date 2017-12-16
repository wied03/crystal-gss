# TODO: Use a src style shard layout
# TODO: Tests
# TODO: Figure out how to make this a "binary library" or at least supply the necessary build flags when used in an app

# Pass in DEBUG=true as an environment variable to compile Crystal binary w/ debug info
ifeq ($(DEBUG), true)
	DEBUG_FLAGS=-d
endif
UNAME_S := $(shell uname -s)
CRYSTAL_LINK_FLAGS=
ifeq ($(UNAME_S),Linux)
	# On Linux, Crystal's GC lib tries to find the com_err lib but probably due to no indirect linking, it doesn't
	# find a symbol, which is present in com_err
	# If we add com_err (dependent) after gc (requester), then it finds it
	CRYSTAL_LINK_FLAGS=-lgc -lcom_err
endif
ifeq ($(UNAME_S),Darwin)
	export PKG_CONFIG_PATH=/usr/local/opt/krb5/lib/pkgconfig
endif

ifneq ($(CRYSTAL_LINK_FLAGS),)
	CRYSTAL_LINK_FLAGS = --link-flags "$(CRYSTAL_LINK_FLAGS)"
endif

kerbclient: Main.cr gssapi/*.cr
	crystal build $(DEBUG_FLAGS) $(CRYSTAL_LINK_FLAGS) Main.cr -o kerbclient

clean:
	rm -rf kerbclient

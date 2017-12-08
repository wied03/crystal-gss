kerbclient: Main.cr krbwrapper.cr
	mkdir -p bin && PKG_CONFIG_PATH=/usr/local/opt/heimdal/lib/pkgconfig crystal build Main.cr -o bin/kerbclient

test: test.c

clean:
	rm -rf bin

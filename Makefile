kerbclient: Main.cr krbwrapper.cr
	PKG_CONFIG_PATH=/usr/local/opt/heimdal/lib/pkgconfig crystal build Main.cr -o kerbclient

clean:
	rm kerbclient

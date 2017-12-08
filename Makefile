CC=gcc
CFLAGS=-I. `PKG_CONFIG_PATH=/usr/local/opt/heimdal/lib/pkgconfig pkg-config --cflags heimdal-gssapi`
LIBS=`PKG_CONFIG_PATH=/usr/local/opt/heimdal/lib/pkgconfig pkg-config --libs heimdal-gssapi`

kerbclient: Main.cr krbwrapper.cr libbwwrapper.dylib
	PKG_CONFIG_PATH=/usr/local/opt/heimdal/lib/pkgconfig crystal build --link-flags -L/Users/brady/code/Crystal/kerberos -d Main.cr -o kerbclient

libbwwrapper.dylib: wrapper.o
	gcc wrapper.o $(LIBS) -dynamiclib -o libbwwrapper.dylib

wrapper.o: wrapper.c

clean:
	rm -rf kerbclient *.o *.dylib

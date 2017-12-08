CC=gcc
PKG_CONFIG_PATH_HEIMDAL=/usr/local/opt/heimdal/lib/pkgconfig
CFLAGS=-I. `PKG_CONFIG_PATH=$(PKG_CONFIG_PATH_HEIMDAL) pkg-config --cflags heimdal-gssapi`
LIBS=`PKG_CONFIG_PATH=$(PKG_CONFIG_PATH_HEIMDAL) pkg-config --libs heimdal-gssapi`

# Need to be able to find libbwwrapper.dylib
kerbclient: Main.cr gsslib.cr libbwwrapper.dylib
	PKG_CONFIG_PATH=$(PKG_CONFIG_PATH_HEIMDAL) crystal build --link-flags -L$(PWD) -d Main.cr -o kerbclient

libbwwrapper.dylib: wrapper.o
	gcc wrapper.o $(LIBS) -dynamiclib -o libbwwrapper.dylib

wrapper.o: wrapper.c

clean:
	rm -rf kerbclient *.o *.dylib

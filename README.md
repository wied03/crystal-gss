# crystal-gss
Doodling w Crystal

Beginnings/rough first cut at a GSSAPI wrapper in Crystal that uses the Heimdal GSSAPI C library

# Compiling/using

Expects Heimdal to be installed at a Homebrew style location with a pkgconfig in `/usr/local/opt/heimdal/lib/pkgconfig`

After you `brew install crystal-lang heimdal`, then just run `make` from this directory and that will produce the executable.

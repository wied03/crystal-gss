kerbclient: Main.cr bin
	crystal build Main.cr -o bin/kerbclient

bin:
	mkdir -p bin

clean:
	rm -rf bin

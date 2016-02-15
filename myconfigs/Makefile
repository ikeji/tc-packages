all: myconfigs.tcz

myconfigs.tcz:
	docker run -t -i --rm -v `pwd`:/work tatsushid/tinycore:6.4-x86 /work/build.sh

clean:
	rm -f myconfigs.tcz

distclean: clean

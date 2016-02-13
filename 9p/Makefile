all: 9p.tcz

9p.tcz:
	chmod 777 . optional
	docker run -t -i --rm -v `pwd`:/work tatsushid/tinycore:6.4-x86 /work/build.sh

clean:
	rm -f 9p.tcz

distclean: clean
	rm -f \
		linux-3.16.6-patched.txz \
		config-3.16.6-tinycore \
		optional/*.tcz \
		optional/*.md5.txt \
		optional/*.dep

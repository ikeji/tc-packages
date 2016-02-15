all: b43.tcz

b43.tcz:
	chmod 777 . optional
	docker run -t -i --rm -v `pwd`:/work tatsushid/tinycore:6.4-x86 /work/build.sh

clean:
	rm -f b43.tcz

distclean: clean
	rm -f \
		broadcom-wl-5.100.138.tar.bz2 \
		optional/*.tcz \
		optional/*.md5.txt \
		optional/*.dep

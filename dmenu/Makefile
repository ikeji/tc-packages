all: dmenu.tcz

dmenu.tcz:
	chmod 777 . optional
	docker run -t -i --rm -v `pwd`:/work tatsushid/tinycore:6.4-x86 /work/build.sh

clean:
	rm -f dmenu.tcz

distclean: clean
	rm -f \
		dmenu-6.1.tar.gz \
		optional/*.tcz \
		optional/*.md5.txt \
		optional/*.dep

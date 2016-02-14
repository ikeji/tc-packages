all: RictyDiminished.tcz

RictyDiminished.tcz:
	chmod 777 optional
	docker run -t -i --rm -v `pwd`:/work tatsushid/tinycore:6.4-x86 /work/build.sh

clean:
	rm -f RictyDiminished.tcz

distclean: clean
	rm -f \
		5.0.1.tar.gz \
		optional/*.tcz \
		optional/*.md5.txt \
		optional/*.dep

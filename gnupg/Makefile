all: zsh.tcz

zsh.tcz:
	chmod 777 . optional
	docker run -t -i --rm -v `pwd`:/work tatsushid/tinycore:6.4-x86 /work/build.sh

clean:
	rm -f zsh.tcz

distclean: clean
	rm -f \
		zsh-5.2.tar.gz \
		optional/*.tcz \
		optional/*.md5.txt \
		optional/*.dep

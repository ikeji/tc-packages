all: vim74.tcz

vim74.tcz:
	chmod 777 . optional
	docker run -t -i --rm -v `pwd`:/work tatsushid/tinycore:6.4-x86 /work/build.sh

clean:
	rm -f vim74.tcz

distclean: clean
	rm -f \
		vim-7.4.tar.bz2 \
		optional/*.tcz \
		optional/*.md5.txt \
		optional/*.dep

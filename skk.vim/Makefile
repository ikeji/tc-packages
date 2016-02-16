all: skk.vim.tcz

skk.vim.tcz:
	chmod 777 . optional
	docker run -t -i --rm -v `pwd`:/work tatsushid/tinycore:6.4-x86 /work/build.sh

clean:
	rm -f skk.vim.tcz

distclean: clean
	rm -f \
		optional/*.tcz \
		optional/*.md5.txt \
		optional/*.dep

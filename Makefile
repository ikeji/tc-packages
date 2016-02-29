PKGS=dwm.tcz st.tcz RictyDiminished.tcz dmenu.tcz myconfigs.tcz skk.vim.tcz
DEPS=dwm.tcz.dep

all: index.html all.tar.gz

index.html: $(PKGS)
	echo "<html>" > $@
	echo "<a href=\"all.tar.gz\">all.tar.gz</a><br/>" > $@
	for i in $+; do \
	  echo "<a href=\"$$i\">$$i</a><br/>" >> $@; \
	done
	for i in $(DEPS); do \
	  echo "<a href=\"$$i\">$$i</a><br/>" >> $@; \
	done
	echo "</html>" >> $@

all.tar.gz: $(PKGS) $(DEPS)
	tar zcvf $@ $+

%.tcz:
	make -C $* $@
	cp $*/$@ .
	cp $*/$@ .

clean:
	rm -rf index.html $(PKGS)

PKGS=9p.tcz dwm.tcz st.tcz vim74.tcz
DEPS=vim74.tcz.dep

all: index.html

index.html: $(PKGS)
	echo "<html>" > $@
	for i in $+; do \
	  echo "<a href=\"$$i\">$$i</a><br/>" >> $@; \
	done
	for i in $(DEPS); do \
	  echo "<a href=\"$$i\">$$i</a><br/>" >> $@; \
	done
	echo "</html>" >> $@

%.tcz:
	make -C $* $@
	cp $*/$@ .
	cp $*/$@ .

clean:
	rm -rf index.html $(PKGS)

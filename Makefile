PKGS=9p.tcz dwm.tcz st.tcz

all: index.html

index.html: $(PKGS)
	echo "<html>" > $@
	for i in $+; do \
	  echo "<a href=\"$$i\">$$i</a><br/>" >> $@; \
	done
	echo "</html>" >> $@

%.tcz:
	make -C $* $@
	cp $*/$@ .

clean:
	rm -rf index.html $(PKGS)

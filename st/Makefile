all: st.tcz

st.tcz:
	chmod 777 . optional
	docker run -t -i --rm -v `pwd`:/work tatsushid/tinycore:6.4-x86 /work/build.sh

clean:
	rm -f st.tcz

distclean: clean
	rm -f \
		st-0.6.tar.gz \
		optional/*.tcz \
		optional/*.md5.txt \
		optional/*.dep

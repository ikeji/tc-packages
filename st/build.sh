#!/bin/sh
cd `dirname $0`

cp optional/* /tmp/tce/optional

LIBS='compiletc make Xorg-7.7-dev ncurses-utils'
tce-load -w $LIBS
tce-load -i -c $LIBS

cp /tmp/tce/optional/* optional/

PKG=st-0.6

if [ ! -f $PKG.tar.gz ]; then
  wget http://dl.suckless.org/st/$PKG.tar.gz
fi
md5sum -c pkg.md5
if [ $? -eq 1 ]; then
  echo 'checksum error'
  exit
fi

rm -rf $PKG

tar xvf $PKG.tar.gz
cd $PKG
make
make DESTDIR=/tmp/st install
TERMINFO=/tmp/st/usr/local/share/terminfo tic -s st.info

cd ..
rm -r /tmp/st/usr/local/share/man

mksquashfs /tmp/st st.tcz

rm -rf $PKG

echo done

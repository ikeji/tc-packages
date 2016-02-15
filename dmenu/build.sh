#!/bin/sh
cd `dirname $0`

cp optional/* /tmp/tce/optional

LIBS='compiletc make Xorg-7.7-dev'
tce-load -w $LIBS
tce-load -i -c $LIBS

cp /tmp/tce/optional/* optional/

PKG=dmenu-4.6

if [ ! -f $PKG.tar.gz ]; then
  wget http://dl.suckless.org/tools/$PKG.tar.gz
fi
md5sum -c pkg.md5
if [ $? -eq 1 ]; then
  echo 'checksum error'
  exit
fi

cd /tmp

rm -rf $PKG

tar xvf `dirname $0`/$PKG.tar.gz
cd $PKG
patch -p1 < `dirname $0`/dmenu.patch
make
make DESTDIR=/tmp/dmenu install

cd ..

rm -r /tmp/dmenu/usr/local/share

cd `dirname $0`

mksquashfs /tmp/dmenu dmenu.tcz

echo done

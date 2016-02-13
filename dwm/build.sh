#!/bin/sh
cd `dirname $0`

cp optional/* /tmp/tce/optional

LIBS='compiletc make libX11-dev Xorg-7.7-dev'
tce-load -w $LIBS
tce-load -i -c $LIBS

cp /tmp/tce/optional/* optional/

PKG=dwm-6.1

if [ ! -f $PKG.tar.gz ]; then
  wget http://dl.suckless.org/dwm/$PKG.tar.gz
fi
md5sum -c pkg.md5
if [ $? -eq 1 ]; then
  echo 'checksum error'
  exit
fi

rm -rf $PKG

tar xvf $PKG.tar.gz
cd $PKG
patch -p1 < ../dwm.patch
cp ../config.h .
make
make DESTDIR=/tmp/dwm install

cd ..

rm -r /tmp/dwm/usr/local/share
mkdir -p /tmp/dwm/usr/local/tce.installed
cp tce-installed.dwm /tmp/dwm/usr/local/tce.installed/dwm

mksquashfs /tmp/dwm dwm.tcz

rm -rf $PKG

echo done

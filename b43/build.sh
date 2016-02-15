#!/bin/sh
cd `dirname $0`

cp optional/* /tmp/tce/optional

LIBS='b43-fwcutter'
tce-load -w $LIBS
tce-load -i -c $LIBS

cp /tmp/tce/optional/* optional/

PKG=broadcom-wl-5.100.138

if [ ! -f $PKG.tar.bz2 ]; then
  wget http://www.lwfinger.com/b43-firmware/broadcom-wl-5.100.138.tar.bz2
fi
md5sum -c pkg.md5
if [ $? -eq 1 ]; then
  echo 'checksum error'
  exit
fi

cd /tmp

rm -rf $PKG

tar xvf `dirname $0`/$PKG.tar.bz2

mkdir -p /tmp/b43/usr/local/lib/firmware

b43-fwcutter -w /tmp/b43/usr/local/lib/firmware $PKG/linux/wl_apsta.o

cd `dirname $0`

mksquashfs /tmp/b43 b43.tcz

echo done

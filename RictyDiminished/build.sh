#!/bin/sh
cd `dirname $0`

cp optional/* /tmp/tce/optional

LIBS='openssl'
tce-load -w $LIBS
tce-load -i -c $LIBS

cp /tmp/tce/optional/* optional/

PKG=4.0.1

if [ ! -f $PKG.tar.gz ]; then
  wget https://github.com/yascentur/RictyDiminished/archive/$PKG.tar.gz
fi
md5sum -c pkg.md5
if [ $? -eq 1 ]; then
  echo 'checksum error'
  exit
fi

cd /tmp
rm -rf $PKG

tar xvf `dirname $0`/$PKG.tar.gz
cd RictyDiminished-$PKG

mkdir -p /tmp/RictyDiminished/usr/local/share/fonts/RictyDiminished
cp *.ttf /tmp/RictyDiminished/usr/local/share/fonts/RictyDiminished

cd `dirname $0`

mksquashfs /tmp/RictyDiminished RictyDiminished.tcz

echo done

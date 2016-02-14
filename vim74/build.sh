#!/bin/sh
cd `dirname $0`

cp optional/* /tmp/tce/optional

LIBS='compiletc make Xorg-7.7-dev gtk2-dev'
tce-load -w $LIBS
tce-load -i -c $LIBS

cp /tmp/tce/optional/* optional/

PKG=vim-7.4

if [ ! -f $PKG.tar.bz2 ]; then
  wget ftp://ftp.vim.org/pub/vim/unix/$PKG.tar.bz2
fi
md5sum -c pkg.md5
if [ $? -eq 1 ]; then
  echo 'checksum error'
  exit
fi

cd /tmp

rm -rf $PKG

tar xvf `dirname $0`/$PKG.tar.bz2
cd vim74

./configure \
  --with-x \
  --enable-multibyte \
  --enable-xim \
  --prefix=/usr/local \
  --enable-gui

make
./src/vim --version
make DESTDIR=/tmp/vim74-tcz install

cd `dirname $0`

rm -r /tmp/vim74-tcz/usr/local/share/vim/vim74/tutor
rm -r /tmp/vim74-tcz/usr/local/share/man
mksquashfs /tmp/vim74-tcz vim74.tcz

echo done

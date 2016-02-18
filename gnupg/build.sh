#!/bin/sh
cd `dirname $0`

cp optional/* /tmp/tce/optional

LIBS='compiletc make openssl ncurses-dev libgpg-error-dev libgcrypt-dev libassuan-dev libksba-dev'
tce-load -w $LIBS
tce-load -i -c $LIBS

cp /tmp/tce/optional/* optional/

PKG=gnupg-2.0.29

if [ ! -f $PKG.tar.bz2 ]; then
  wget https://www.gnupg.org/ftp/gcrypt/gnupg/gnupg-2.0.29.tar.bz2
  wget ftp://ftp.gnu.org/gnu/pth/pth-2.0.7.tar.gz
fi
md5sum -c pkg.md5
if [ $? -eq 1 ]; then
  echo 'checksum error'
  exit
fi

cd /tmp

rm -rf pth-2.0.7

tar xvf `dirname $0`/pth-2.0.7.tar.gz

cd pth-2.0.7

./configure
make
mkdir -p /tmp/gnupg
make DESTDIR=/tmp/gnupg install
sudo make install

cd ..

rm -rf $PKG

tar xvf `dirname $0`/$PKG.tar.bz2

cd $PKG
./configure

make

mkdir -p /tmp/gnupg
make DESTDIR=/tmp/gnupg install

cd `dirname $0`

rm -r /tmp/gnupg/usr/local/include
rm -r /tmp/gnupg/usr/local/share/doc
rm -r /tmp/gnupg/usr/local/share/info
rm -r /tmp/gnupg/usr/local/share/aclocal
rm -r /tmp/gnupg/usr/local/share/man
rm -r /tmp/gnupg/usr/local/man
rm -r /tmp/gnupg/usr/local/lib/libpth.la
rm -r /tmp/gnupg/usr/local/lib/libpth.a

mksquashfs /tmp/gnupg gnupg.tcz

echo done

#!/bin/sh
cd `dirname $0`

cp optional/* /tmp/tce/optional

LIBS='compiletc make openssl ncurses-dev libgpg-error-dev libgcrypt-dev libassuan-dev libksba-dev libusb-dev perl5'
tce-load -w $LIBS
tce-load -i -c $LIBS

cp /tmp/tce/optional/* optional/

PKG=gnupg-2.0.29

if [ ! -f $PKG.tar.bz2 ]; then
  wget https://www.gnupg.org/ftp/gcrypt/gnupg/gnupg-2.0.29.tar.bz2
  wget ftp://ftp.gnu.org/gnu/pth/pth-2.0.7.tar.gz
  wget http://ftp.internat.freebsd.org/pub/FreeBSD/distfiles/ccid-1.4.21.tar.bz2
  wget http://ftp.internat.freebsd.org/pub/FreeBSD/distfiles/pcsc-lite-1.8.15.tar.bz2
fi
md5sum -c pkg.md5
if [ $? -eq 1 ]; then
  echo 'checksum error'
  exit
fi

cd /tmp

rm -rf pcsc-lite-1.8.15

tar xvf `dirname $0`/pcsc-lite-1.8.15.tar.bz2

cd pcsc-lite-1.8.15

./configure
mkdir -p /tmp/gnupg
sudo make install
make DESTDIR=/tmp/gnupg install

sh
cd /tmp
rm -rf ccid-1.4.21

tar xvf `dirname $0`/ccid-1.4.21.tar.bz2

cd ccid-1.4.21

./configure
mkdir -p /tmp/gnupg
sudo make install
make DESTDIR=/tmp/gnupg install

sh
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

rm gnupg.tcz
mksquashfs /tmp/gnupg gnupg.tcz

echo done

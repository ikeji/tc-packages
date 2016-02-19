#!/bin/sh
cd `dirname $0`

if [ ! -f linux-3.16.6-patched.txz ]; then
  wget http://tinycorelinux.net/6.x/x86/release/src/kernel/linux-3.16.6-patched.txz
fi
if [ ! -f config-3.16.6-tinycore ]; then
  wget http://tinycorelinux.net/6.x/x86/release/src/kernel/config-3.16.6-tinycore
fi
md5sum -c pkg.md5
if [ $? -eq 1 ]; then
  echo 'checksum error'
  exit
fi

cp optional/* /tmp/tce/optional

LIBS='compiletc make ncurses-dev'
tce-load -w $LIBS
tce-load -i -c $LIBS

cp /tmp/tce/optional/* optional/

cd /tmp

rm -r linux-3.16.6
tar xvf `dirname $0` linux-3.16.6-patched.txz
cd linux-3.16.6
cp `dirname $0`/config-3.16.6-tinycore .config
cat <<EOL >> .config
CONFIG_NET_9P=m
CONFIG_NET_9P_VIRTIO=m
CONFIG_9P_FS=m
# CONFIG_NET_9P_DEBUG is not set
# CONFIG_9P_FS_POSIX_ACL is not set
# CONFIG_9P_FS_SECURITY is not set
EOL

make oldconfig
make fs/9p/9p.ko
make net/9p/9pnet.ko
make net/9p/9pnet_virtio.ko

cd ..

rm -r 9p
mkdir -p 9p/lib/modules/3.16.6-tinycore/kernel/fs/9p
mkdir -p 9p/lib/modules/3.16.6-tinycore/kernel/net/9p

cp linux-3.16.6/fs/9p/9p.ko 9p/lib/modules/3.16.6-tinycore/kernel/fs/9p/9p.ko
cp linux-3.16.6/net/9p/9pnet.ko 9p/lib/modules/3.16.6-tinycore/kernel/net/9p/9pnet.ko
cp linux-3.16.6/net/9p/9pnet_virtio.ko 9p/lib/modules/3.16.6-tinycore/kernel/net/9p/9pnet_virtio.ko

mkdir -p 9p/usr/local/tce.installed
cat <<EOL > 9p/usr/local/tce.installed/9p
#!/bin/sh
echo kernel/fs/fs/9p/9p.ko: kernel/fs/net/9p/9pnet.ko >> /lib/modules/3.16.6-tinycore/modules.dep
echo kernel/fs/net/9p/9pnet.ko: kernel/fs/net/9p/9pnet.ko >> /lib/modules/3.16.6-tinycore/modules.dep
echo kernel/fs/net/9p/9pnet_virtio.ko: >> /lib/modules/3.16.6-tinycore/modules.dep

modprobe 9pnet_virtio
modprobe 9p
EOL
chmod 755 9p/usr/local/tce.installed/9p

cd `dirname $0`

rm -r 9p.tcz
mksquashfs /tmp/9p 9p.tcz

echo done

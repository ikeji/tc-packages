tce-load -ic libusb.tcz
tce-load -ic libksba.tcz
tce-load -ic gtk2.tcz
tce-load -ic gdbm.tcz
tce-load -ic libassuan.tcz
tce-load -ic ncurses.tcz

cd build
for f in `ls *.tcz`
do
  tce-load -ic $f
done


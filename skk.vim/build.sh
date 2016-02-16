#!/bin/sh
cd `dirname $0`

cp optional/* /tmp/tce/optional

LIBS='git'
tce-load -w $LIBS
tce-load -i -c $LIBS

cp /tmp/tce/optional/* optional/

cd /tmp

rm -rf eskk.vim

git clone --depth 1 https://github.com/tyru/eskk.vim

mkdir -p skk.vim/usr/local/share/vim/vim74
cp -r eskk.vim/autoload skk.vim/usr/local/share/vim/vim74
cp -r eskk.vim/doc skk.vim/usr/local/share/vim/vim74
cp -r eskk.vim/plugin skk.vim/usr/local/share/vim/vim74

wget http://openlab.jp/skk/skk/dic/SKK-JISYO.L
mkdir -p skk.vim/usr/local/share/skk/
cp SKK-JISYO.L skk.vim/usr/local/share/skk/

cd `dirname $0`

mksquashfs /tmp/skk.vim skk.vim.tcz

echo done

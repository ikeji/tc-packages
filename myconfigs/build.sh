#!/bin/sh
cd `dirname $0`

mksquashfs src myconfigs.tcz

echo done

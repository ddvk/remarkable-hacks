#!/bin/sh
set -e
binary_name=xochitl
patch_name=patch_01

function cleanup(){
    rm -fr .cache/remarkable/xochitl/qmlcache/*
}
wget -N "https://github.com/ddvk/remarkable-hacks/raw/master/patches/$patch_name" || exit 1

echo "do: cleanup enter before exiting"
#make sure we keep the original
if [ ! -f $binary_name.backup ]; then
    cp /usr/bin/$binary_name $binary_name.backup
fi
cp $binary_name.backup $binary_name

bspatch $binary_name $binary_name.patched $patch_name
chmod +x xochitl.patched
#clear the cache
systemctl stop xochitl
cleanup
./xochitl.patched
cleanup

echo "do: cleanup enter"
## if this worked it's probably safe to replace the original
## cp xochitl.patched /usr/bin/xochitl 
## or change the systemd unit

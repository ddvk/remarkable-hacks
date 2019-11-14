#!/bin/sh
set -e
binary_name=xochitl
patch_name=${1:-patch_01}

trap onexit INT
function onexit(){
    cleanup
    cat <<-EOF "If everything worked, you may replace the binary to make it permanent with the following:
    cp $binary_name.patched /usr/bin/$binary_name
	EOF
    exit 0
}
function cleanup(){
    echo "cleaning up"
    rm /tmp/*crash* 2> /dev/null || true
    rm -fr .cache/remarkable/xochitl/qmlcache/*
}

if [ ! $(</etc/version) -eq "20190904134033" ]; then
	echo "Wrong version, works only on 1.8.1.1"
	exit 1
fi


wget "https://github.com/ddvk/remarkable-hacks/raw/master/patches/$patch_name" -O $patch_name || exit 1

#make sure we keep the original
if [ ! -f $binary_name.backup ]; then
    cp /usr/bin/$binary_name $binary_name.backup
fi
cp $binary_name.backup $binary_name

bspatch $binary_name $binary_name.patched $patch_name
chmod +x xochitl.patched
#clear the cache
systemctl stop xochitl
#it goes into  and endless reboot due to qml mismatch
systemctl stop remarkable-fail
 
cleanup
./xochitl.patched || echo "It crashed?"
cleanup

## if this worked it's probably safe to replace the original
## cp xochitl.patched /usr/bin/xochitl 
## or change the systemd unit

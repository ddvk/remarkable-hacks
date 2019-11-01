#!/bin/sh
wget https://github.com/ddvk/remarkable-hacks/raw/master/tools/bspatch
wget https://github.com/ddvk/remarkable-hacks/raw/master/patches/patch1
cp /usr/bin/xochitl .
chmod +x bspatch
./bspatch xochitl xochitl.patched patch1
chmod +x xochitl.patched

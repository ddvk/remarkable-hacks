#!/bin/sh
wget https://github.com/ddvk/remarkable-hacks/raw/master/patches/patch1
cp /usr/bin/xochitl .
bspatch xochitl xochitl.patched patch1
chmod +x xochitl.patched

#!/usr/bin/env python3
import os,sys

def binpatch(filename, offset, hexbytes):
    patch = bytes.fromhex(hexbytes)

    with open(file,'rb+') as out:
        out.seek(offset)
        out.write(patch)

if __name__ == "__main__":
        if len(sys.argv) < 3:
                print("Usage: file offset hexbytes")
                sys.exit(1)
        file = sys.argv[1]
        offset = int(sys.argv[2],16)-0x10000
        hexbytes = sys.argv[3]
        binpatch(file, offset, hexbytes)
        print(f"patched: {offset}")


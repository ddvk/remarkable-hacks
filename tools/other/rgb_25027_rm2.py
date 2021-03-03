#!/usr/bin/env python3
## rgb patch for xochitl (could work on future versions)
import os,sys,mmap

def binpatch(filename, offset, hexbytes):
    patch = bytes.fromhex(hexbytes)

    with open(file,'rb+') as out:
        out.seek(offset)
        out.write(patch)

diffs = [('01 c0 a0 13 14 c0 8d e5 0d 30 a0 03 04 c0 a0 03 08 c0 a0 13 10 c0 8d e5 18 30 a0 13',
          '03 c0 a0 13 14 c0 8d e5 0d 30 a0 03 04 c0 a0 03 00 c0 a0 13 10 c0 8d e5 04 30 a0 13')]

if __name__ == "__main__":
        if len(sys.argv) < 1:
                sys.stderr.write("Usage:  xochitl")
                sys.exit(1)
        file = sys.argv[1]
        with open(file,'rb+') as f:
            m = mmap.mmap(f.fileno(), 0)
            indexes = []
            idx = 0
            for s,r in diffs:
                m.seek(0)
                idx += 1
                bytes_to_find = bytes.fromhex(s)
                bytes_to_write = bytes.fromhex(r)
                i = m.find(bytes_to_find)
                if i < 0:
                    sys.stderr.write(f'pattern at index: {idx} not found\n')
                    sys.stderr.write(s)
                    sys.exit(1)
                indexes.append((i, bytes_to_write))
            for i, r in indexes:
                m.seek(i)
                m.write(r)


#!/usr/bin/env python3
## rgb patch for xochitl (could work on future versions)
import sys,mmap


diffs = [('01 30 a0 13 02 30 a0 03 1c 30 8d e5 08 30 a0 13 04 30 a0 03 18 30 8d e5 18 30 a0 13',
          '03 30 a0 13 02 30 a0 03 1c 30 8d e5 00 30 a0 13 04 30 a0 03 18 30 8d e5 04 30 a0 13')]

if __name__ == "__main__":
        if len(sys.argv) < 2:
                sys.stderr.write("Usage:  xochitl\n")
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
                    sys.stderr.write("\n")
                    sys.exit(1)
                indexes.append((i, bytes_to_write))
            for i, r in indexes:
                m.seek(i)
                m.write(r)


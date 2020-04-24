file=$1
# patches 2113 to render color pdfs
./binpatch.py $file 176470 "00C0A0E3"
./binpatch.py $file 176400 "0320A0E3"
./binpatch.py $file 176270 "0430A0E3"

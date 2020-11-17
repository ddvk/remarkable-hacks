file=$1
# patches 24130_rm2 to render color pdfs
./binpatch.py $file 243d8c "00c0a013"
./binpatch.py $file 243d94 "0430a013"
./binpatch.py $file 243d7c "03c0a013"


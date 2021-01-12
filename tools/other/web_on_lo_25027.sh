# for reMarkable 2
# changes the web server listen interface to lo (to make it accessible over the network via ssh)
$file=$1
./binpatch.py $file 0813fc "0210a0e3"
./binpatch.py $file 08149c "a30000ea"
./binpatch.py $file 3a3538 "6c6f0000"

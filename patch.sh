set -e
binary_name=xochitl

function checkspace(){
    available=$(df / | tail -n1 | awk '{print $4}');
    let available=$available/1024
    if [ $available -lt 3 ];then
      echo "Less than 3MB free, ${available}MB"
      return 1;
    fi;
}

checkspace || (echo "Trying to free space..."; journalctl --vacuum-time=1m)
checkspace || (echo "Aborting..."; exit 10)
echo "Disk space seems to be enough."

trap onexit INT

function onexit(){
    cleanup
    auto_install

    exit 0
}
function cleanup(){
    echo "Cleaning up..."
    rm /tmp/*crash* 2> /dev/null || true
    rm -fr .cache/remarkable/xochitl/qmlcache/*
}

function rollback(){
    systemctl stop xochitl
    cleanup
    cp $backup_file /usr/bin/xochitl
    systemctl start xochitl
    exit 0
}

function auto_install(){
    echo -n "If everything worked, do you want to make it permanent [N/y]? "
    read yn
    case $yn in 
        [Yy]* ) 
            echo "Making it permanent, DON'T DELETE $backup_file"
            mv $binary_name.patched /usr/bin/$binary_name
            echo "Starting the UI..."
            systemctl start xochitl
            return 0
            ;;
        * )
            echo "Use the xochitl.patched binary if you change your mind / provide it if it segfaulted."
            echo "Starting the original..."
            systemctl start xochitl
            ;;
    esac
    return 1
}

case $(</etc/version) in
    "20200320131825" )
        patch_name=${1:-patch_06}
        version="2113"
        expectedhash="c8661fbd74a049134509dc22da415bb651d7feac"
        echo "Version 2.1.1.3 - $patch_name"
        ;;
    "20191204111121" )
        patch_name=${1:-patch_224}
        version="2020"
        expectedhash="don't remember"
        echo "Version 2.0.2.0"
        ;;
        
    "20190904134033" )
        patch_name=${1:-patch_07}
        version="1811"
        expectedhash="don't remember"
        echo "Version 1.8.1.1"
        ;;
    * )
        echo "Unsupported version"
        exit 1
        ;;
esac


backup_file="${binary_name}.${version}"

if [ $patch_name == "rollback" ]; then
    rollback
    exit 0
fi

if [ -z "$SKIP_DOWNLOAD" ]; then
    wget "https://github.com/ddvk/remarkable-hacks/raw/master/patches/$version/$patch_name" -O $patch_name || exit 1
fi

#make sure we keep the original, which is needed for additional patching or rollback
if [ ! -f $backup_file ]; then
    cp /usr/bin/$binary_name $backup_file
fi

hash=$(sha1sum $backup_file | cut -c 1-40)
if [ "$expectedhash" != "$hash" ]; then
    echo "The backup $backup_file is not the original file (was it replaced/ deleted?), cowardly aborting..."
    exit 1
fi


cp $backup_file $binary_name

bspatch $binary_name $binary_name.patched $patch_name
chmod +x xochitl.patched

systemctl stop xochitl
#just to be sure, it goes into and endless reboot due to qml mismatch
systemctl stop remarkable-fail
 
cleanup
echo "Trying to start the patched version..."
echo "You can play around, press CTRL-C when done."
QT_LOGGING_RULES=*=false ./xochitl.patched  || echo "It crashed?"
cleanup

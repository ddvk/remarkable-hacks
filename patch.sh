set -e
binary_name=xochitl
workdir=/home/rmhacks
patched="$workdir/$binary_name.patched"

if [ ! -d $workdir ]; then
    mkdir -p $workdir
    # migrate stuff and clean old patches
    mv /home/root/xochitl.* $workdir 2> /dev/null || true
    rm /home/root/patch_* 2> /dev/null || true
fi;

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
    rm -fr /home/root/.cache/remarkable/xochitl/qmlcache/*
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
            echo "Making it permanent, DON'T DELETE $backup_file !!!"
            mv $patched /usr/bin/$binary_name
            echo "Starting the UI..."
            systemctl start xochitl
            return 0
            ;;
        * )
            echo "Use the $patched binary if you change your mind / provide it if it segfaulted."
            echo "Starting the original..."
            systemctl start xochitl
            ;;
    esac
    return 1
}

currentVersion="$(</etc/version)"
case $currentVersion in
    "20201127104105" )
        patch_name=${1:-patch_17.1.01}
        version="25027_rm1"
        expectedhash="4296b9c6d7a66aadd12e1cf61a13b7b19504673d"
        echo "rM1 Version 2.5.0.27 - $patch_name"
        ;;
    "20201028164335" )
        patch_name=${1:-patch_16.1.06}
        version="24130_rm1"
        expectedhash="336529ce6e7ef9d6fadd30872708556ca8711f0b"
        echo "rM1 Version 2.4.1.30 - $patch_name"
        ;;
    "20201028163830" )
        patch_name=${1:-patch_16.2.03}
        version="24130_rm2"
        expectedhash="c88d155b7ca8c770240b2c00048968f8445f8115"
        echo "rM2 Version 2.4.1.30 - $patch_name"
        ;;
    "20201016123042" )
        patch_name=${1:-patch_15.2.01}
        version="24027_rm2"
        expectedhash="797f58ed93d2e22e7d77fcd9de6c6eb5d49a3a7f"
        echo "rM2 Version 2.4.0.27 - $patch_name"
        ;;
    "20201016123325" )
        patch_name=${1:-patch_15.1.02}
        version="24027_rm1"
        expectedhash="891e06535c0ae742eeaa3b9a20e9ff03d0f659d3"
        echo "rM1 Version 2.4.0.27 - $patch_name"
        ;;
    "20200914085553" | "20200914090635" )
        patch_name=${1:-patch_14.01}
        version="23127"
        expectedhash="596b02f401fb0ceb6a73df470fbab418b305cdbc"
        echo "rM2 Version 2.3.1.27 - $patch_name"
        ;;
    "20200904144143" )
        patch_name=${1:-patch_13.07}
        version="23023"
        expectedhash="7eb1ed8b75b1b282fd4ecf30ef19118d3a41fcc7"
        echo "rM2 Version 2.3.0.23 - $patch_name"
        ;;
    "20200709160645" )
        patch_name=${1:-patch_12.11}
        version="23016"
        expectedhash="005b05ef64f079aaf377d373cb7e2889a2aa774a"
        echo "rM1 Version 2.3.0.16 - $patch_name"
        ;;
    "20200805214933" )
        patch_name=${1:-patch_11.01}
        version="22182"
        expectedhash="c7d965972a5a6d2bf8503b1b09b52a89c422505b"
        echo "rM2 Version 2.2.1.82 - $patch_name"
        ;;
    "20200528081414" )
        patch_name=${1:-patch_10.10}
        version="22048"
        expectedhash="7e92c177df685972a699db6c4a7a918296447f74"
        echo "Version 2.2.0.48 - $patch_name"
        ;;
    "20200320131825" )
        patch_name=${1:-patch_09}
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
        echo "The version the device is running is not supported, yet. $currentVersion"
        exit 1
        ;;
esac


backup_file="$workdir/$binary_name.$version"

if [ $patch_name == "rollback" ]; then
    rollback
    exit 0
fi

if [ -z "$SKIP_DOWNLOAD" ]; then
    wget "https://github.com/ddvk/remarkable-hacks/raw/master/patches/$version/$patch_name" -O "$workdir/$patch_name" || exit 1
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


bspatch $backup_file $patched $workdir/$patch_name
chmod +x $patched

systemctl stop xochitl
#just to be sure, it goes into and endless reboot due to qml mismatch
systemctl stop remarkable-fail
 
cleanup
echo ""
echo "**********************************************"
echo "Trying to start the patched version..."
echo -e "\e[1mYou can play around, press \e[5m\e[31mCTRL-C \e[39m\e[25mwhen done!\e[0m"
echo "**********************************************"
echo ""
QT_LOGGING_RULES=*=false $patched -plugin evdevlamy  || echo "Did it crash?"
cleanup

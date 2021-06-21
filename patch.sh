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
    part=$1
    needed=$2
    available=$(df $part | tail -n1 | awk '{print $4}');
    let available=$available/1024
    if [ $available -lt $needed ];then
      echo "Less than ${needed}MB free, ${available}MB"
      return 1;
    fi;
}

checkspace / 3 || (echo "Trying to free space..."; journalctl --vacuum-time=1m)
checkspace / 3 || (echo "Aborting..."; exit 10)
checkspace /home 10 || (echo "Not enough space on /home"; exit 10)

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

function purge(){
    if [ ! -f "$backup_file" ]; then
        echo "The backup file is missing"
        exit 1
    fi

    hash=$(sha1sum "$backup_file" | cut -c 1-40)

    if [ "$expectedhash" != "$hash" ]; then
        echo "The backup $backup_file is not the original file (was it replaced/ deleted? / wrong hash), cowardly aborting..."
        exit 1
    fi

    systemctl stop xochitl
    cleanup
    cp "$backup_file" /usr/bin/xochitl
    systemctl start xochitl
    echo -n "Remove all traces [Y/n]? "
    read yn
    case $yn in 
        [Nn]* )
            ;;
            * ) 
            rm -fr "$workdir"
            ;;
    esac
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
    "20210611153600" )
        patch_name=${1:-patch_23.2.02}
        version="28098_rm2"
        expectedhash="02a851bc33231fcd253eee781eb127e3c942da69"
        echo "rM2 Version 2.8.0.98 - $patch_name"
        ;;
    "20210611154039" )
        patch_name=${1:-patch_23.1.02}
        version="28098_rm1"
        expectedhash="b688b4afbd5c13347bada20f26b9108d82658f9a"
        echo "rM1 Version 2.8.0.98 - $patch_name"
        ;;
    "20210511153632" )
        patch_name=${1:-patch_22.2.01}
        version="27153_rm2"
        expectedhash="f0846772da9b810aecc2a307ba5dae21c072674a"
        echo "rM2 Version 2.7.1.53 - $patch_name"
        ;;
    "20210504114631" )
        patch_name=${1:-patch_21.2.05}
        version="27051_rm2"
        expectedhash="f0846772da9b810aecc2a307ba5dae21c072674a"
        echo "rM2 Version 2.7.0.51 - $patch_name"
        ;;
    "20210504114855" )
        patch_name=${1:-patch_21.1.04}
        version="27051_rm1"
        expectedhash="123877bb7dd6133f4540e03d3912b1d4c4d76050"
        echo "rM Version 2.7.0.51 - $patch_name"
        ;;
    "20210322075357" )
        patch_name=${1:-patch_20.2.03}
        version="26275_rm2"
        expectedhash="7b314d6fb03c8789396f0ed43a4b27a18c649d2d"
        echo "rM2 Version 2.6.2.75 - $patch_name"
        ;;
    "20210322075617" )
        patch_name=${1:-patch_20.1.03}
        version="26275_rm1"
        expectedhash="50a44683ac1b8ce524e55e10f57b699e7c4ca409"
        echo "rM Version 2.6.2.75 - $patch_name"
        ;;
    "20210311194323" )
        patch_name=${1:-patch_19.2.02}
        version="26171_rm2"
        expectedhash="fc434bf45f1ff927af799ddccc7b2b0449f516f7"
        echo "rM2 Version 2.6.1.71 - $patch_name"
        ;;

    "20210311193614" )
        patch_name=${1:-patch_19.1.02}
        version="26171_rm1"
        expectedhash="2d31db3e7f1a7b98a493cc5a1351fe303f849cd3"
        echo "rM1 Version 2.6.1.71 - $patch_name"
        ;;

    "20201216142449" )
        patch_name=${1:-patch_18.2.01}
        version="25145_rm2"
        expectedhash="c5337f952554ae40f0c97d81cf1c4a126c9cc593"
        echo "rM2 Version 2.5.1.45 - $patch_name"
        ;;
    "20201127104549" )
        patch_name=${1:-patch_17.2.07}
        version="25027_rm2"
        expectedhash="0ed1af968a31e816513d15321bd02b9625ccb073"
        echo "rM2 Version 2.5.0.27 - $patch_name"
        ;;
    "20201127104105" )
        patch_name=${1:-patch_17.1.10}
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

if [ $patch_name == "purge" ]; then
    purge
    exit 0
fi

if [ -z "$SKIP_DOWNLOAD" ]; then
    wget "https://github.com/ddvk/remarkable-hacks/raw/master/patches/$version/$patch_name" -O "$workdir/$patch_name" || exit 1
fi

#make sure we keep the original, which is needed for additional patching or purge
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
systemctl reset-failed xochitl
#just to be sure, it goes into and endless reboot due to qml mismatch
systemctl stop remarkable-fail
 
# there can be only one (accessing the fb)
systemctl stop rm2fb || true
killall remarkable-shutdown || true

# oxide / remux / prevent multiple xochitl instances
killall xochitl || true


cleanup
echo ""
echo "**********************************************"
echo "Trying to start the patched version..."
echo -e "\e[1mYou can play around, press \e[5m\e[31mCTRL-C \e[39m\e[25mwhen done!\e[0m"
echo "**********************************************"
echo ""
QT_LOGGING_RULES=*=false $patched -plugin evdevlamy  || echo "Did it crash?"
cleanup

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
    if [ -z "$1" ]; then
        echo -n "If everything worked, do you want to make it permanent [N/y]? "
        read yn
    else
        yn=$1
    fi
    case $yn in 
        [Yy]* ) 
            echo "Making it permanent, DON'T DELETE $backup_file !!!"
            mv $patched /usr/bin/$binary_name
            echo "IMPORTANT: Do not forget to disable 'Automatic updates' on your reMarkable to avoid losing the hack unintentionally."
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
    "20220615075543" )
        patch_name=${1:-patch_34.1.01}
        version="2140861_rm1"
        expectedhash="a3da3cc4d393917703bcdc2ed3c280ebcc192e0f"
        echo "rM1 Version 2.14.0.861 - $patch_name"
        ;;
    "20220615074909" )
        patch_name=${1:-patch_34.2.01}
        version="2140861_rm2"
        expectedhash="6376fb20bdf6952bb7b75838c0bda1c80f0e9191"
        echo "rM2 Version 2.14.0.861 - $patch_name"
        ;;
    "20220519120030" )
        patch_name=${1:-patch_33.2.01}
        version="2130758_rm2"
        expectedhash="c77016e4608ccab1b1e619a6ef2769a205312025"
        echo "rM2 Version 2.13.0.758 - $patch_name"
        ;;
    "20220330140034" )
        patch_name=${1:-patch_32.1.03}
        version="2123606_rm1"
        expectedhash="e6693c76ad588c7a223cf5be5a280214495a68e0"
        echo "rM1 Version 2.12.3.606 - $patch_name"
        ;;
    "20220330134519" )
        patch_name=${1:-patch_32.2.02}
        version="2123606_rm2"
        expectedhash="b7d8f0ca786117cdf715e3f7b08b1eac3aed907a"
        echo "rM2 Version 2.12.3.606 - $patch_name"
        ;;
    "20220303120824" )
        patch_name=${1:-patch_31.2.01}
        version="2122573_rm2"
        expectedhash="7105e311df4df7f4ccde457ce574da63f49d3a4e"
        echo "rM2 Version 2.12.2.573 - $patch_name"
        ;;
    "20220303122245" )
        patch_name=${1:-patch_31.1.01}
        version="2122573_rm1"
        expectedhash="00b5095022a48e48cdbe435b8afff0e3dc736b96"
        echo "rM1 Version 2.12.2.573 - $patch_name"
        ;;
    "20220202133838" )
        patch_name=${1:-patch_30.2.07}
        version="2121527_rm2"
        expectedhash="8728cf8a2677a1b458f8e1ed665f8c1358568f7f"
        echo "rM2 Version 2.12.1.527 - $patch_name"
        ;;
    "20220202133055" )
        patch_name=${1:-patch_30.1.08}
        version="2121527_rm1"
        expectedhash="c542ee591b45cb18599dc852cc0d3ce82ec86b56"
        echo "rM1 Version 2.12.1.527 - $patch_name"
        ;;
    "20211208075454" )
        patch_name=${1:-patch_29.2.02}
        version="2110442_rm2"
        expectedhash="ad88de508a3c7da7f1ff6a9d394806c5d987026d"
        echo "rM2 Version 2.11.0.442 - $patch_name"
        ;;
    "20211208080907" )
        patch_name=${1:-patch_29.1.02}
        version="2110442_rm1"
        expectedhash="1f72eb42b0745d40196cb7fece6a8fee55f958c0"
        echo "rM1 Version 2.11.0.442 - $patch_name"
        ;;
    "20211102142308" )
        patch_name=${1:-patch_28.1.02}
        version="2103379_rm1"
        expectedhash="1978c56c0bf9a53e74fb05b7212381543adb709e"
        echo "rM1 Version 2.10.3.379 - $patch_name"
        ;;
    "20211102143141" )
        patch_name=${1:-patch_28.2.02}
        version="2103379_rm2"
        expectedhash="8510d6f4380b6155d630baecaccccfb0147263d0"
        echo "rM2 Version 2.10.3.379 - $patch_name"
        ;;
    "20211014151303" )
        patch_name=${1:-patch_27.2.05}
        version="2102356_rm2"
        expectedhash="2cc077e0bc5eca53664d4692197d54b477fa02ba"
        echo "rM2 Version 2.10.2.356 - $patch_name"
        ;;
    "20211014150444" )
        patch_name=${1:-patch_27.1.03}
        version="2102356_rm1"
        expectedhash="a76509107656c03e866ec169ad317da9111f71be"
        echo "rM1 Version 2.10.2.356 - $patch_name"
        ;;
    "20210929140057" )
        patch_name=${1:-patch_26.2.02}
        version="2101332_rm2"
        expectedhash="44ed43a128c821988519c3ea92c4516f011edd7e"
        echo "rM2 Version 2.10.1.332 - $patch_name"
        ;;
    "20210923144714" )
        patch_name=${1:-patch_25.2.01}
        version="2100324_rm2"
        expectedhash="0990b599d412a1c6368985d872383b29b47ffab6"
        echo "rM2 Version 2.10.0.324 - $patch_name"
        ;;
    "20210923152158" )
        patch_name=${1:-patch_25.1.03}
        version="2100324_rm1"
        expectedhash="635917603b0d9349ddf5f6ead818701a42979945"
        echo "rM1 Version 2.10.0.324 - $patch_name"
        ;;
    "20210812195523" )
        patch_name=${1:-patch_24.2.04}
        version="291217_rm2"
        expectedhash="ab37e201e819e4212fb4e2ce92cd747614499fbb"
        echo "rM2 Version 2.9.1.217 - $patch_name"
        ;;
    "20210820111232" )
        patch_name=${1:-patch_24.1.02}
        version="291236_rm1"
        expectedhash="e5d3ce51e81a6e23bac0c66549b809e6dd4e35a0"
        echo "rM1 Version 2.9.1.236 - $patch_name"
        ;;
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
    # save this file locally for offline uninstall
    wget "https://github.com/ddvk/remarkable-hacks/raw/master/patch.sh" -O "$workdir/patch.sh" || exit 1
    chmod +x "$workdir/patch.sh"
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

if [ -z "$MAKE_PERM" ]; then

   cleanup
   echo ""
   echo "**********************************************"
   echo "Trying to start the patched version..."
   echo -e "\e[1mYou can play around, press \e[5m\e[31mCTRL-C \e[39m\e[25mwhen done!\e[0m"
   echo "**********************************************"
   echo ""
   QT_LOGGING_RULES=*=false $patched -plugin evdevlamy  || echo "Did it crash?"
   cleanup
else
   auto_install "y"
   cleanup
   exit
fi

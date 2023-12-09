#!/bin/sh
# USE AT YOUR OWN RISK
# Backup your files first
# a simple script to switch the xochitls folders per user
# Usage: ./setuser.sh user1
# if the folder does not exists it will be created

if [ -z "$1" ]; then
    echo "Provide username as param"
    exit 1
fi

function linkfolder() {
    loc=$2
    newhome=/home/$1
    origin=/home/root/$2
    if [ -L $origin ]; then
        echo "Link exists for $origin"
        if [ ! -d $newhome/$loc ]; then
            echo "Creating folder $newhome/$loc"
            mkdir -p $newhome/$loc
        fi
        echo "Linking $newhome/$loc to $origin"
        ln -sf $newhome/$loc /home/root/
    elif [ -d $origin ]; then
        if [ -d $newhome/$loc ]; then
            echo "Default $origin not a link, and folder for user $1 exists, delete it first"
            exit 1
        else
            echo "Moving $loc and creating link..."
            mkdir -p $newhome
            mv $origin $newhome
            ln -sf $newhome/$loc /home/root/
        fi
    fi
}

linkfolder $1 .config
linkfolder $1 .local

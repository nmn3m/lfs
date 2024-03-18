#!/bin/bash

# we use export as we run things in different subshell
export LFS=/mnt/lfs
export LFS_TGT=$(uname -m)-lfs-linux-gnu


# add the name /dev/sda  using sudo dmesg to know the name of usb
############################## please add the name of usb
export LFS_DISK=/dev/sdb
##########################

# if nothing is mount in this point please do this 
if ! grep -q "$LFS" /proc/mounts; then
    source setupdisk.sh "$LFS_DISK"
    mount "${LFS_DISK}2" "$LFS"
    # change owner to lfs user so he can create directory with out sudo 
    sudo chown -v $USER "$LFS"
fi

# for linux from scratch system 
mkdir -pv $LFS/tools # for cross compilers
mkdir -pv $LFS/sources # for tarballs

# for the normal FSH(file system hirarchy) 
mkdir -pv $LFS/boot
mkdir -pv $LFS/etc
mkdir -pv $LFS/bin
mkdir -pv $LFS/lib
mkdir -pv $LFS/sbin
mkdir -pv $LFS/usr
mkdir -pv $LFS/var

# check if the system is 64 make dir for lib64 
case $(uname -m) in
    x86_64) mkdir -pv $LFS/lib64 ;;
esac

# copy all files to flash disk
cp -rf *.sh  chapter* packages.csv "$LFS/sources"
cd "$LFS/sources"
# there is no folder bin inside folder tool 
# add this to path of the programs
export PATH="$LFS/tools/bin:$PATH"


source download.sh

# source packageinstall.sh 5 binutils

#binutils
for package in gcc linux-api-headers glibc libstc++; do
    source packageinstall.sh 5 $package
done
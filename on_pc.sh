#!/bin/bash

if [${1%/*} = "/dev"]
then
    if [echo `expr length ${1#/*/}` -gt 3]
    then
        SDX1="${1}p1"
        SDX2="${1}p2"
    else
        SDX1="${1}1"
        SDX2="${1}2"
    fi
    
    echo "o
    p
    n



    +200M
    t
    c
    n




    p
    w" | fdisk ${1}

    cd /tmp

    mkfs.vfat $SDX1
    mkfs.ext4 $SDX2

    mkdir boot
    mkdir root

    mount $SDX1 boot
    mount $SDX2 root

    wget http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-armv7-latest.tar.gz

    bsdtar -xpf ArchLinuxARM-rpi-armv7-latest.tar.gz -C root
    sync

    mv root/boot/* boot
    sync


    echo "mediapi" >> root/etc/hostname

    # Network
    echo "[Match]" >> "root/etc/systemd/network/20-wired.network"
    echo "Name=eth0" >> "root/etc/systemd/network/20-wired.network"
    echo "[Network]" >> "root/etc/systemd/network/20-wired.network"
    echo "Address=192.168.50.113/24" >> "root/etc/systemd/network/20-wired.network"
    echo "Gateway=192.168.50.1" >> "root/etc/systemd/network/20-wired.network"
    echo "DNS=192.168.50.113" >> "root/etc/systemd/network/20-wired.network"

    wget https://raw.githubusercontent.com/dudnikgg/archarm-install/main/on_pi.sh

    umount "${1}*"

    echo "Good luck this time!"
else
    echo "no /dev/X device"
fi

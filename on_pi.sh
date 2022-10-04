#!/bin/bash

# Language/location options
echo "KEYMAP=de-latin1" >> /etc/console.conf
echo "LANG=de_DE.UTF-8" >> /etc/locale.conf
locale-gen
timedatectl set-timezone Europe/Berlin

# pacman config
pacman-key --init
pacman-key --populate archlinuxarm
echo "SigLevel = Required DatabaseOptional" >> /etc/pacman.conf
echo "LocalFileSigLevel = Optional" >> /etc/pacman.conf
echo "Server = https://eu.mirror.archlinuxarm.org" >> /etc/pacman.d/mirrorlist
echo "Server = https://de5.mirror.archlinuxarm.org" >> /etc/pacman.d/mirrorlist
echo "Server = https://de3.mirror.archlinuxarm.org" >> /etc/pacman.d/mirrorlist

# Boot config
if grep -Fxq "/boot/config.txt" "dtoverlay=vc4-kms-v3d"
then
    echo "dtoverlay=vc4-kms-v3d exists in /boot/config.txt"
else
     "dtoverlay=vc4-kms-v3d" >> /boot/config.txt
fi

if grep -Fxq "/boot/config.txt" "disable_overscan=1"
then
    echo "disable_overscan exists in /boot/config.txt"
else
     "disable_overscan=1" >> /boot/config.txt
fi

pacman -Syu
pacman -S accountsservice zsh neovim firefox chromium htop sudo 

usermod -aG video,tty,audio,sudo alarm

echo "%sudo   ALL=(ALL:ALL) ALL" >> /etc/sudoers.d/10-group-sudo

echo "allowed_users=anybody" > /etc/X11/Xwrapper.config
echo "needs_root_rights=yes" >> /etc/X11/Xwrapper.config

echo "xset s off" >> /etc/X11/xinit/xinitrc
echo "xset -dpms" >> /etc/X11/xinit/xinitrc
echo "xset s noblank" >> /etc/X11/xinit/xinitrc

cp /etc/X11/xinit/xinitrc /home/alarm/.xinitrc
chown alarm:alarm /home/alarm/.xinitrc

nvim /home/alarm/.xinitrc


su - alarm "chsh -s /bin/zsh"

reboot

  




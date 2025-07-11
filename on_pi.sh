#!/bin/bash

# Language/location options
echo "KEYMAP=en" >> /etc/console.conf
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
locale-gen
timedatectl set-timezone Europe/Kyiv

# pacman config
pacman-key --init --noconfirm
pacman-key --populate archlinuxarm --noconfirm
echo "SigLevel = Required DatabaseOptional" >> /etc/pacman.conf
echo "LocalFileSigLevel = Optional" >> /etc/pacman.conf
echo "Server = https://repo.hyron.dev/archlinux/\$repo/os/\$arch" >> /etc/pacman.d/mirrorlist
echo "Server = https://mirror.hostiko.network/archlinux/\$repo/os/\$arch" >> /etc/pacman.d/mirrorlist
echo "Server = http://mirrors.reitarovskyi.tech/archlinux/\$repo/os/\$arch" >> /etc/pacman.d/mirrorlist

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

pacman -Syu --noconfirm
pacman -S --noconfirm accountsservice zsh neovim curl fzf btop sudo git base-devel
pacman -S --needed  --noconfirm
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

echo "maybe enter password for alarm"
su - alarm "chsh -s /bin/zsh"

cd /tmp
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si

reboot

  




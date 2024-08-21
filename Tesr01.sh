#! /bin/bash
useradd Install 
su Install
cd /home/$USERNAME
git clone https://aur.archlinux.org/yay.git 
cd yay
makepgk -si 
exit 1
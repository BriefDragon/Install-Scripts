#! /bin/bash
#            /$$                                               /$$     
#           | $$                                              | $$    
#   /$$$$$$$| $$$$$$$           /$$$$$$   /$$$$$$   /$$$$$$  /$$$$$$   
#  /$$_____/| $$__  $$ /$$$$$$ /$$__  $$ /$$__  $$ /$$__  $$|_  $$_/   
# | $$      | $$  \ $$|______/| $$  \__/| $$  \ $$| $$  \ $$  | $$     
# | $$      | $$  | $$        | $$      | $$  | $$| $$  | $$  | $$ /$$ 
# |  $$$$$$$| $$  | $$        | $$      |  $$$$$$/|  $$$$$$/  |  $$$$/ 
#  \_______/|__/  |__/        |__/       \______/  \______/    \___/   
#                                                                     
#
#-----------------------------------------------------------------------------------------------------------------------------------------
cat /root/own-installer/art-UserInputs.txt
#configuration 1
echo "Nun sind wir im zweiten teil der Instalation. Jetzt kommen sehr viele Fragen. Notier dir am besten die Antworten irgendwo. Das wird jetzt eine Text-Bombe, sorry"
echo "Wer Windows Dual Booten will, muss nach der Installation os-prober muss den sogenannten Root-Nutzer verwenden mit ’su -’ und mit ’pacman -S os-prober’ os-prober installieren und dann ’grub-mkconfig -o /boot/grub/grub.cfg’ ausführen und kann danach zum User mit ’su BENUTERNAME’ zurückkehren. (Die ’ nicht mitschreiben, danke.)" 
read -p "Was soll der Hostname fuer das Geraet werden?" HOSTNAME
read -p "Welches Standarttastaturlayout? QWERTZ=de-latin1 QWERTY=us " TASTATURLAYOUT
read -p "Soll ein User erstellt werden? (y/N) (Groß ist der Standart-Wert)" CHOISEUSER
    if [ "$CHOISEUSER"==y ]; then #|| "$CHOISEUSER"==Y || "$CHOISEUSER"==yes || "$CHOISEUSER"==Yes ||]; then
        read -p "Wie soll er Heissen?: " USERNAME
        read -p "Was soll sein Passwort werden?: " USERPW
        read -p "Bitte Bestätigen: " USERPW2
            #if ["$USERPW" != "USERPW2"]; then 
                #echo "Die Passwörter stimmen nicht Ueberein. Bitte Script mit neustarten. ((1.) cd /root/own-installer (2.) sh chroot-teil.sh)"
                #exit 1
            #fi
        useradd -m -G wheel -s /bin/bash $USERNAME
        chpasswd <<<""$USERNAME":"$USERPW""
        echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers
    fi
read -p "Wie soll das Root-Passwort lauten? (Root ist das eqivalent zum Windows Admin nur mit noch mehr rechten wegen Konsole und so.): " ROOTPW
    read -p "Bitte Bestätigen" ROOTPW2
        #if [ "$ROOTPW" != "$ROOTPW2" ]; then 
            #echo "Die Passwörter stimmen nicht Ueberein. Bitte Script mit neustarten. ((1.) cd /root/own-installer (2.) sh chroot-teil.sh)"
            #exit 1
        #fi
read -p "Welchen Texteditor willst du haben? (enter package name): " TEXT
    pacman -Sy "$TEXT"
read -p "Wisst du einen Minimalen Install?(y/N) (Ohne DE(KDE Plasma) or WM(Hyprland)): " MINIMAL
    if [ "$MINIMAL" == y ]; then #|| "$MINIMAL" == Y || "$MINIMAL" == yes || "$MINIMAL" == Yes ||]; then
        cat /root/own-instraller/art-config1.txt
        read -p "Welches Land bist du Ansässig? (Deutschland=de ; USA/Kanada=us ; (Japan=jp)WIP): " LC
        if [ "$LC" == de ]; then
            echo de_DE.UTF-8 UTF-8 >> /etc/locale.gen
            locale-gen
            echo de_DE.UTF-8 >> /etc/locale.conf
            echo KEYMAP="$TASTATURLAYOUT" >> /etc/vconsole.conf
        fi
        if [ "$LC" == us ]; then
            echo en_US.UTF-8 UTF-8 >> /etc/locale.gen
            locale-gen
            echo en_US.UTF-8 >> /etc/locale.conf
        fi
        #if [ "$LC" == jp ]; then
            #echo ja_JP.UTF-8 UTF-8 >> /etc/locale.gen
            #pacman -Sy adobe-source-han-serif-jp-fonts 
            #echo LANG=ja_JP.UTF-8 >> /etc/locale.conf
            #pacman -S ibus ibus-anthy
        #fi 
        locale-gen
        chpasswd <<<"root:$ROOTPW"  
        grub-install 
        grub-mkconfig -o /boot/grub/grub.cfg
        echo "Die Installation ist fertig. Du kannst jetzt neustarten."
        exit 1
    fi
read -p "Nutzt du NVDIA? (y/N): " NVIDIA
read -p "Nutzt du AMD oder Intel?: " CPUHERSTELLER
read -p "WM(Hyprland) oder DE(KDE Plasma)?: " WMDE
read -p "Welches Land bist du Ansässig? (Deutschland=de ; USA/Kanada=us ; Japan=jp)" LC
#config 
cat /root/own-installer/art-config1.txt
if [ "$LC" == de ]; then
    echo de_DE.UTF-8 UTF-8 >> /etc/locale.gen
    locale-gen
    echo de_DE.UTF-8 >> /etc/locale.conf
    echo KEYMAP="$TASTATURLAYOUT" >> /etc/vconsole.conf
    cp /root/own-installer/mirrorlist /etc/pacman.d/mirrorlist 
fi
if [ "$LC" == us ]; then
    echo en_US.UTF-8 UTF-8 >> /etc/locale.gen
    locale-gen
    echo en_US.UTF.8 >> /etc/locale.conf
    echo KEYMAP="$TASTATURLAYOUT" >> /etc/vconsole.conf
fi
#if [ "$LC" == jp ]; then
    #echo ja_JP.UTF-8 UTF-8 >> /etc/locale.gen
    #WIP because i dont know, how to do the Japanese KEyboard layout thing.
chpasswd <<< "root:"$ROOTPW""
#"Treiber"
pacman -S --noconfirm bluez bluez-utils blueman
if [ "$NVIDIA" == y ]; then #|| "$NVIDIA" == yes || "$NVIDIA" == Y || "$NVIDIA" == Yes || ]; then +
    pacman -S --noconfirm nvidia nvidia-utils 
    #libva-nvidia-driver egl-wayland
    #cp /root/own-installer/mkinitcpio.conf /etc/mkinitcpio.conf
    #echo options nvidia_drm modeset=1 dbdev=1 >> /etc/modprobe.d/nvidia.conf
    #mkinitcpio -P
fi
if [ "$CPUHERSTELLER" == Intel ]; then
    pacman -S --noconfirm intel-ucode
fi
if [ "$CPUHERSTELLER" == AMD ]; then 
    pacman -S --noconfirm amd-ucode
fi
#Programme
cat /root/own-Installer/art-programs.txt
if [ "$WMDE" == WM ]; then
    pacman -S --noconfirm wayland hyprland pipewire firefox libreoffice discover nemo wofi xcursor-vanilla-dmz kitty
    #cp /root/own-installer/dotinstaller.sh /root/home/$USERNAME
fi
if [ "$WMDE" == DE ]; then 
    pacman -S --noconfirm sddm plasma firefox libreoffice konsole dolphin system-config-printer cups cups-pdf
    systemctl enable sddm
    systemctl enable cups
fi
#Last Config 
cat /root/own-Installer/art-lastconfig.txt
if [  ]
modprobe btubs
systemctl enable bluetooth.service
systemctl enable NetworkManager
grub-install 
grub-mkconfig -o /boot/grub/grub.cfg
#ende 
cat /root/own-installer/art-end.txt
echo "Die Installation ist fertig und du kannst mit ’reboot’ neustarten. Wenn du Hyprland ausgewählt hast, kannst du die Installation der dotfiles nach dem reboot durch 1. ’sh dotinstaller.sh’ starten. (Anmerkung: Work in progress)"
rm /root/own-installer
exit 1

#! /bin/bash
echo "                                                                                                        "
echo "                                                                                                        "
echo "  /$$$$$$                      /$$             /$$$$$$                       /$$               /$$ /$$"
echo "  /$$__  $$                    | $$            |_  $$_/                      | $$              | $$| $$"
echo " | $$  \ $$  /$$$$$$   /$$$$$$$| $$$$$$$         | $$   /$$$$$$$   /$$$$$$$ /$$$$$$    /$$$$$$ | $$| $$"
echo " | $$$$$$$$ /$$__  $$ /$$_____/| $$__  $$        | $$  | $$__  $$ /$$_____/|_  $$_/   |____  $$| $$| $$"
echo " | $$__  $$| $$  \__/| $$      | $$  \ $$        | $$  | $$  \ $$|  $$$$$$   | $$      /$$$$$$$| $$| $$"
echo " | $$  | $$| $$      | $$      | $$  | $$        | $$  | $$  | $$ \____  $$  | $$ /$$ /$$__  $$| $$| $$"
echo " | $$  | $$| $$      |  $$$$$$$| $$  | $$       /$$$$$$| $$  | $$ /$$$$$$$/  |  $$$$/|  $$$$$$$| $$| $$"
echo " |__/  |__/|__/       \_______/|__/  |__/      |______/|__/  |__/|_______/    \___/   \_______/|__/|__/"  
cat /run/archiso/bootmnt/own-installer/art-input.txt
echo 
#Partitionenbeginn jetzt
lsblk
read -p "Bitte gebe deine Root-Partition ein wie im folgenden Beispiel (z.b. /dev/sda3). Das Kannst du mit der liste über dir herrauslesen. Sei dir bitte sicher, dass es richtig ist und notier dir auch ruhig die anderen Partitionen." Haupt
    mkfs.ext4 "$Haupt"
    mount "$Haupt" /mnt 
# Swap 
read -p "Bitte Swap-partition in dem Schemata von eben eingeben." Tausch
    mkswap "$Tausch"
    swapon "$Tausch"
# Boot
read -p "Bitte jetzt als letztes die Boot Partition auch im selben Schema." Start
    mkfs.fat -F 32 "$Start"
    mkdir -p /mnt/boot/efi
    mount "$Start" /mnt/boot/efi
#ende der Partitionen ding 
#Programme 
cat /run/archiso/bootmnt/own-installer/art-programs.txt 
pacstrap -K /mnt base linux linux-firmware grub efibootmgr nano networkmanager neofetch sof-firmware base-devel git sudo 
genfstab /mnt > /mnt/etc/fstab
cp -r /run/archiso/bootmnt/own-installer /mnt/root
arch-chroot /mnt /bin/bash /root/own-installer/chroot-teil.sh
#ende dieses Teils 

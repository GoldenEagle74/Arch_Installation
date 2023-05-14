#! /bin/bash
setfont cyr-sun16
read -p "Введите название пк: " answer
echo $answer > /etc/hostname
cat /script/local.txt | sed "s/имя-хоста/$answer/g" > /etc/hosts
sleep 5
read -p "Введите свой регион: " region
read -p "Введите свой город: " city
ln -sf /usr/share/zoneinfo/$region/$city /etc/localtime
hwclock --systohc
echo "Установка часового пояса завершена"
sleep 5
cat /etc/locale.gen | sed "s/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g" > /script/locale.gen
cat /script/locale.gen > /etc/locale.gen
cat /etc/locale.gen | sed "s/#ru_RU.UTF-8 UTF-8/ru_RU.UTF-8 UTF-8/g" > /script/locale.gen
cat /script/locale.gen > /etc/locale.gen
locale-gen 1> /dev/null
echo "Установка локали завершена"
sleep 5
echo "LANG=ru_RU.UTF-8" > /etc/locale.conf
echo "FONT=cyr-sun16" > /etc/vconsole.conf
echo "Введите пароль суперпользователя: "
passwd
pacman -S --noconfirm grub efibootmgr
grub-install 1> /dev/null
echo "Установка GRUB завершена"
sleep 5
grub-mkconfig -o /boot/grub/grub.cfg 1> /dev/null
echo "Настройка GRUB заершена"
read -p "Введите имя пользователя: " user
useradd -m -g users -G wheel -s /bin/bash $user
echo "Введите пароль для пользователя: "
passwd $user
echo "Расскоментируйте строку # %wheel ALL=(ALL:ALL) ALL"
sleep 10
EDITOR=nano visudo
pacman -Syu --noconfirm
pacman -S --noconfirm util-linux mesa xorg xorg-server xorg-apps xorg-xinit bash-completion plasma sddm konsole dolphin packagekit-qt5 discover python-pyqt5 firewalld ethtool inetutils usbutils ntfs-3g
systemctl disable dhcpcd 1> /dev/null
systemctl enable NetworkManager 1> /dev/null
systemctl enable sddm 1> /dev/null
systemctl enable firewalld.service 1> /dev/null
echo "Установка завершена"
sleep 5

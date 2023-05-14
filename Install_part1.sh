#! /bin/bash
setfont cyr-sun16
echo "Инициализация переменных..."
echo "root=" > root.txt
fdisk -l | grep root | cut -d ' ' -f 1 >> root.txt
cat root.txt | tr -d '\r\n' > root2.txt
export $(cat root2.txt | xargs -L 1)
echo "1/3"
sleep 5
echo "home=" > home.txt
fdisk -l | grep home | cut -d ' ' -f 1 >> home.txt
cat home.txt | tr -d '\r\n' > home2.txt
export $(cat home2.txt | xargs -L 1)
echo "2/3"
sleep 5
echo "EFI=" > efi.txt
fdisk -l | grep EFI | cut -d ' ' -f 1 >> efi.txt
cat efi.txt | tr -d '\r\n' > efi2.txt
export $(cat efi2.txt | xargs -L 1)
echo "Иницализация окончена"
sleep 5
echo "Форматирование раздела подкачки..."
fdisk -l | grep swap | cut -d ' ' -f 1 | xargs mkswap 1> /dev/null
sleep 15
echo "Инициализация раздела swap..."
fdisk -l | grep swap | cut -d ' ' -f 1 | xargs swapon 1> /dev/null
sleep 5
echo "Форматирование раздела Linux root system x86-64 в ext4..."
mkfs.ext4 $root 1> /dev/null
sleep 15
echo "Форматирование раздела Linux home в ext4..."
mkfs.ext4 $home 1> /dev/null
sleep 15
echo "Форматирование раздела Efi system в Fat32..."
mkfs.fat -F 32 $EFI 1> /dev/null
sleep 15
echo "Монтирование разделов..."
mount $root /mnt
mkdir /mnt/boot
mkdir /mnt/boot/efi
mkdir /mnt/home
mount $home /mnt/home
mount $EFI /mnt/boot/efi
echo "Инициализация устройств окончена"
sleep 5
echo "Установка ядра..."
sleep 5
pacstrap /mnt base base-devel linux linux-firmware sudo nano dhcpcd networkmanager
sleep 15
echo "Установка ядра завершена"
sleep 5
echo "Создание файла fstab..."
genfstab -U /mnt >> /mnt/etc/fstab
sleep 5
mkdir /mnt/script
cp -r /script/script/* /mnt/script/
echo "Смена окружения..."
arch-chroot /mnt

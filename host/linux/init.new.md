1. Установить ОС
	1. debian
		- sda1 - 512 MiB - efi
		- sda2 - 14.3 GiB - root (btrfs)
		- sda3 - ? - srv (btrfs)
		- sda4 - 4 GiB - swap (raid)
	2. armbian
2. Изменить разделы
	1. debian
		1. Преобразовать efi в raid1
		   `sdf`
		   `saf`
		2. Переделать массив swap
		3. Поправить fstab
		4. ``
		5. 
		6. Поправить fstab
	2. armbian
3. Создать тома btrfs

```
wget \
  --header "Accept: application/vnd.github.v3.raw" \
  https://api.github.com/repos/jarsXk/homelab/contents/host/linux/init-common.sh
bash init-common.sh

```
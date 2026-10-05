1. sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=7 /dev/sda3
2. sudo nano /etc/crypttab: `luks-<UUID> UUID=<UUID> none discard,tpm2-device=auto,x-initrd.attach
3. sudo rpm-ostree initramfs --enable
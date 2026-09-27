1. sudo pacman -S tpm2-tools tpm2-tss
2. sudo systemd-cryptenroll --tpm2-device=auto /dev/sda2
3. sudo systemd-cryptenroll --tpm2-device=auto /dev/sda3
4. sudo nano /etc/crypttab: `luks-<UUID> UUID=<UUID> none tpm2-device=auto,x-initrd.attach`
5. sudo dracut -f
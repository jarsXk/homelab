1. sudo apt install cryptsetup-initramfs systemd-cryptsetup tpm2-tools dracut dracut-core
2. sudo nano /etc/dracut.conf.d/10-crypt-tpm.conf
   ```
   hostonly="yes" 
   add_dracutmodules+=" systemd crypt " 
   add_drivers+=" tpm_tis tpm_crb " 
   install_items+=" /etc/crypttab "
   ```
3. <для proxmox>
   sudo nano /etc/dracut.conf.d/20-gpu.conf
   ```
   add_drivers+=" bochs "
   ```
4. sudo systemd-cryptenroll --tpm2-device=auto /dev/sda3
   sudo systemd-cryptenroll --tpm2-device=auto /dev/sda4
5. sudo nano /etc/crypttab
   ```
   sda3_crypt UUID=<UUID> none luks,discard,tpm2-device=auto,x-initrd.attach
   sda4_crypt UUID=<UUID> none luks,discard,tpm2-device=auto,x-initrd.attach
   ```
   <убрать swap>
6. sudo dracut --regenerate-all --force
#!/bin/sh

apt install -y unzip
wget https://github.com/clach04/automount-usb/archive/refs/heads/mine.zip
unzip ./mine.zip

cd ./automount-usb-mine
./CONFIGURE.sh
cd ..
rm /etc/systemd/system/usb-mount@.service
wget \
  --header "Accept: application/vnd.github.v3.raw" \
  -O /etc/systemd/system/usb-mount@.service \
  https://api.github.com/repos/jarsXk/homelab/contents/host/linux/manual/usbmount/usb-mount@.service

mv /usr/local/bin/usb-mount.sh /usr/local/sbin/
mv ./automount-usb-mine /usr/local/sbin/usbmount
cp /etc/systemd/system/usb-mount@.service /usr/local/sbin/usbmount/
rm ./mine.zip

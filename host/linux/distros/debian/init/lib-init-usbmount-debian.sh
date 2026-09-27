
# Install usbmount
if [ $PHYSICAL = yes ]; then
  CUR_FOLDER=$(pwd)
  run_command "wget -O /root/mine.zip https://github.com/clach04/automount-usb/archive/refs/heads/mine.zip" "Error installing usbmount"
  run_command "cd /root" "Error installing usbmount"
  run_command "unzip /root/mine.zip" "Error installing usbmount"
  run_command "cd /root/automount-usb-mine" "Error installing usbmount"
  run_command "bash /root/automount-usb-mine/CONFIGURE.sh" "Error installing usbmount"
  run_command "cd $CUR_FOLDER" "Error installing usbmount"
  run_command "rm /etc/systemd/system/usb-mount@.service" "Error installing usbmount"
  run_command "wget -O /etc/systemd/system/usb-mount@.service ${INIT_REPO}/host/linux/init/download/usbmount/usb-mount@.service" "Error installing usbmount"
  run_command "mv /usr/local/bin/usb-mount.sh /usr/local/sbin/" "Error installing usbmount"
  run_command "mv /root/automount-usb-mine /usr/local/sbin/usbmount" "Error installing usbmount"
  run_command "cp /etc/systemd/system/usb-mount@.service /usr/local/sbin/usbmount/" "Error installing usbmount"
  run_command "rm /root/mine.zip" "Error installing usbmount"
fi

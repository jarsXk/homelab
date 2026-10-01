1. enable backports
   ```
   echo "deb http://deb.debian.org/debian trixie-backports main contrib non-free non-free-firmware" | sudo tee /etc/apt/sources.list.d/backports.list
   
   sudo apt update
   ```
2. install backports
   ```
   sudo apt -t trixie-backports install \
      hyprland \
      hyprland-guiutils \
      xdg-desktop-portal-hyprland \
      pipewire \
      wireplumber \
      pipewire-pulse \
      blueman
   ```
3. install trixie
   ```
   sudo apt install \
      xdg-desktop-portal-gtk \
      xwayland \
      polkitd \
      wl-clipboard \
      grim \
      slurp \
      brightnessctl \
      foot
   ```
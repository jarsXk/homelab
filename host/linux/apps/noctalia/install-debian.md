1. noctalia repo
   ```
   wget https://pkg.noctalia.dev/deb/nickh-archive-keyring.deb 
   sudo dpkg -i nickh-archive-keyring.deb
   sudo wget -O /etc/apt/sources.list.d/noctalia-trixie.sources \ https://pkg.noctalia.dev/deb/noctalia-trixie.sources
   
   sudo apt update
   ```
2. install backports
   ```
   sudo apt -t trixie-backports install \
      libwlroots-0.20
   ```
3. install noctalia
   ```
   sudo apt install \
      noctalia \
      noctalia-greeter
   ```
# msttcore-fonts
Packaging and installer scripts for Microsoft TrueType Core Fonts (Arial, Times New Roman, Verdana, etc.) on Linux.

## License
Scripts are released under the MIT License.  
Microsoft Core Fonts are distributed under the [Microsoft EULA](https://sources.debian.org/src/ttf-mscorefonts-installer/latest/EULA/) and are not included in this repository.

## Quick Commands (RPM-package)

### Build
```bash
git clone https://github.com/isboston/msttcore-fonts.git
cd msttcore-fonts
bash build.sh rpm
```
### Install
```bash
dnf -y install dist/rpmbuild/RPMS/noarch/msttcore-fonts-installer-2.6-1.noarch.rpm
```
### Check
```bash
dnf -y install epel-release
dnf -y install cabextract fontconfig
fc-list | egrep -i 'arial|verdana|times new roman' | head
ls -l /usr/share/fonts/msttcore | head
```
### Remove
```bash
dnf -y remove msttcore-fonts-installer || true
rm -rf /usr/share/fonts/msttcore || true
fc-cache -f || true
```

## Quick Commands (DEB-package)

### Install build dependencies
```bash
sudo apt-get update
sudo apt-get install -y build-essential debhelper cabextract fontconfig
```

### Build
```bash
git clone https://github.com/isboston/msttcore-fonts.git
cd msttcore-fonts
bash build.sh deb
ls -1 dist/debbuild/ttf-mscorefonts-installer_*_all.deb
```
### Install
```bash
sudo apt install ./dist/debbuild/ttf-mscorefonts-installer_*_all.deb
```
### Check
```bash
# should show Arial / Verdana / Times New Roman from msttcorefonts
fc-list | egrep -i 'arial|verdana|times new roman' | head
# verify that ClearType fonts are registered in fontconfig
fc-list | egrep -i 'calibri|cambria|candara|consolas|constantia|corbel'
```
### Remove
```bash
sudo apt remove -y ttf-mscorefonts-installer || true
sudo rm -rf /usr/share/fonts/truetype/msttcorefonts || true
sudo fc-cache -f || true
```

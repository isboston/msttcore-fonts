# msttcore-fonts
Packaging and installer scripts for Microsoft TrueType Core Fonts (Arial, Times New Roman, Verdana, etc.) on Linux.

## License
Scripts are released under the MIT License.  
Microsoft Core Fonts are distributed under the [Microsoft EULA](https://sources.debian.org/src/ttf-mscorefonts-installer/latest/EULA/) and are not included in this repository.

## Quick Commands (Build)

### Build
```bash
git clone https://github.com/isboston/msttcore-fonts.git -b feature/rpm
cd msttcore-fonts
bash tools/build.sh
```
### Install
```bash
dnf -y install dist/rpmbuild/RPMS/noarch/msttcore-fonts-installer-2.6-1.noarch.rpm
```
### Check
```bash
fc-list | egrep -i 'arial|verdana|times new roman' | head
ls -l /usr/share/fonts/msttcore | head
```
### Remove
```bash
dnf -y remove msttcore-fonts-installer || true
rm -rf /usr/share/fonts/msttcore || true
fc-cache -f || true
```


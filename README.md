# msttcore-fonts
Packaging and installer scripts for Microsoft TrueType Core Fonts (Arial, Times New Roman, Verdana, Calibri, Cambria, Candara, Consolas, Constantia, Corbel, etc.) on Linux.

Builds:

- **DEB** package: `ttf-mscorefonts-installer`
- **RPM** package: `msttcore-fonts-installer`

## License
Scripts are released under the MIT License.
Microsoft Core Fonts are distributed under the [Microsoft EULA](https://sources.debian.org/src/ttf-mscorefonts-installer/latest/EULA/) and are not included in this repository.

## Build (on Ubuntu 24.04)

All examples below assume build is done on **Ubuntu 24.04**.

Install build dependencies:

```bash
sudo apt-get update
sudo apt-get install -y build-essential debhelper cabextract fontconfig rpm
```

Clone and build both packages:

```bash
git clone https://github.com/isboston/msttcore-fonts.git
cd msttcore-fonts
```
build both RPM and DEB
```bash
bash build.sh rpm deb
```
Resulting artifacts:

- **RPM** package: `dist/rpmbuild/RPMS/noarch/msttcore-fonts-installer-2.6-1.noarch.rpm`
- **DEB** package: `dist/debbuild/ttf-mscorefonts-installer_3.8.1_all.deb`

## Install & Test (DEB package: Debian/Ubuntu)
On a Debian/Ubuntu system (can be the same builder host or another one), install:
```bash
sudo apt-get update
sudo apt-get install -y fontconfig  # for fc-list
sudo apt install ./dist/debbuild/ttf-mscorefonts-installer_3.8.1_all.deb
```

Verify that both classic core fonts and ClearType fonts are registered:
```bash
fc-list | egrep -i 'arial|verdana|times new roman|calibri|cambria|candara|consolas|constantia|corbel' | head
```

## Install & Test (RPM package: RHEL/CentOS/Rocky/Alma)

Copy the built RPM to the target RHEL-like system, for example:

```bash
scp dist/rpmbuild/RPMS/noarch/msttcore-fonts-installer-2.6-1.noarch.rpm root@server:/root/
```

Install runtime dependencies and the package:
```bash
sudo dnf install -y epel-release
sudo dnf install -y fontconfig cabextract
```
```bash
sudo dnf install -y ./msttcore-fonts-installer-2.6-1.noarch.rpm
```

Check that fonts are available:
```bash
fc-list | egrep -i 'arial|verdana|times new roman|calibri|cambria|candara|consolas|constantia|corbel' | head
```

## Cleanup / Removal

### Debian / Ubuntu (DEB)

```bash
sudo apt remove -y ttf-mscorefonts-installer || true
sudo rm -rf /usr/share/fonts/truetype/msttcorefonts || true
sudo fc-cache -f || true
```

### RHEL / CentOS / Rocky / Alma (RPM)

```bash
sudo dnf remove -y msttcore-fonts-installer || true
sudo rm -rf /usr/share/fonts/msttcore || true
sudo fc-cache -f || true
```

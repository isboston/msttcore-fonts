# msttcore-fonts
Packaging and installer scripts for Microsoft TrueType Core Fonts  
(Arial, Verdana, Calibri, Cambria, Candara, Consolas, Constantia, Corbel, etc.) on Linux.

Builds packages:

- **DEB** `ttf-mscorefonts-installer`
- **RPM** `msttcore-fonts-installer`

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
bash build.sh rpm deb
```

Resulting artifacts:

- **DEB** `dist/debbuild/ttf-mscorefonts-installer_3.8.1_all.deb`
- **RPM** `dist/rpmbuild/RPMS/noarch/msttcore-fonts-installer-2.6-1.noarch.rpm`

## Install and test (DEB: Debian/Ubuntu)

```bash
sudo apt-get update
sudo apt-get install -y fontconfig
sudo apt install ./dist/debbuild/ttf-mscorefonts-installer_3.8.1_all.deb
```

Check that fonts are available:
```bash
fc-list | egrep -i 'arial|verdana|calibri|cambria|candara|consolas|constantia|corbel' | head
```

## Install and test (RPM: RHEL/CentOS)

Copy the built RPM to the target RHEL-like system, for example:

```bash
scp dist/rpmbuild/RPMS/noarch/msttcore-fonts-installer-2.6-1.noarch.rpm root@server:/root/
```

Install dependencies and the package:
```bash
sudo dnf install -y epel-release
sudo dnf install -y fontconfig cabextract
sudo dnf install -y ./msttcore-fonts-installer-2.6-1.noarch.rpm
```

Check that fonts are available:
```bash
fc-list | egrep -i 'arial|verdana|calibri|cambria|candara|consolas|constantia|corbel' | head
```

## Cleanup

Debian/Ubuntu (DEB)
```bash
sudo apt remove -y ttf-mscorefonts-installer || true
sudo rm -rf /usr/share/fonts/truetype/msttcorefonts || true
sudo fc-cache -f || true
```

RHEL/CentOS (RPM)
```bash
sudo dnf remove -y msttcore-fonts-installer || true
sudo rm -rf /usr/share/fonts/msttcore || true
sudo fc-cache -f || true
```

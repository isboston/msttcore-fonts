#!/usr/bin/env bash
set -e
PKG_NAME=msttcore-fonts-installer
PKG_VER=2.6
PKG_REL=1
TOPDIR="$(pwd)/dist/rpmbuild"
SOURCES="$TOPDIR/SOURCES"
SPECS="$TOPDIR/SPECS"
SPEC_SRC="$(pwd)/SPECS/msttcore-fonts-installer-2.6-1.spec"
TARBALL="$SOURCES/${PKG_NAME}-${PKG_VER}.tar.gz"

mkdir -p "$SOURCES" "$SPECS"

if command -v dnf >/dev/null 2>&1; then
  dnf -y install epel-release || true
  dnf -y install rpm-build curl cabextract fontconfig gzip tar || true
elif command -v yum >/dev/null 2>&1; then
  yum -y install epel-release || true
  yum -y install rpm-build curl cabextract fontconfig gzip tar || true
fi

curl -fL -o "$TARBALL" "https://downloads.sourceforge.net/project/mscorefonts2/sources/${PKG_NAME}-${PKG_VER}.tar.gz"

cp -f "$(pwd)/SPECS/refresh-msttcore-fonts.sh" "$SOURCES/refresh-msttcore-fonts.sh"

cp -f "$SPEC_SRC" "$SPECS/"
rpmbuild -ba "$SPECS/$(basename "$SPEC_SRC")" --define "_topdir $TOPDIR"

find "$TOPDIR/RPMS" -type f -name "${PKG_NAME}-${PKG_VER}-${PKG_REL}.noarch.rpm" -print -quit


#!/usr/bin/env bash

set -e

PKG_NAME="msttcore-fonts-installer"
PKG_VER="2.6"
PKG_REL="1"
SRC_DIR_NAME="${PKG_NAME}-${PKG_VER}"
TOPDIR="$(pwd)/dist/rpmbuild"
SOURCES_DIR="${TOPDIR}/SOURCES"
SPECS_DIR="${TOPDIR}/SPECS"
SPEC_SRC_PATH="$(pwd)/SPECS/msttcore-fonts-installer-2.6-1.spec"
TARBALL="${SOURCES_DIR}/${PKG_NAME}-${PKG_VER}.tar.gz"

mkdir -p "${SOURCES_DIR}" "${SPECS_DIR}"

if command -v dnf >/dev/null 2>&1; then
  dnf -y install epel-release || true
  dnf -y install rpm-build curl fontconfig cabextract gzip tar || true
elif command -v yum >/dev/null 2>&1; then
  yum -y install epel-release || true
  yum -y install rpm-build curl fontconfig cabextract gzip tar || true
fi

tree_root="${SOURCES_DIR}/${SRC_DIR_NAME}"
libdir="${tree_root}/usr/lib/msttcore-fonts-installer"
docdir="${tree_root}/usr/share/doc/msttcore-fonts-installer"
mkdir -p "${libdir}" "${docdir}"

curl -L -o "${libdir}/refresh-msttcore-fonts.sh" "https://sourceforge.net/projects/mscorefonts2/files/scripts/refresh-msttcore-fonts.sh/download"
curl -L -o "${libdir}/cabfiles.sha256sums" "https://sourceforge.net/projects/mscorefonts2/files/scripts/cabfiles.sha256sums/download"
curl -L -o "${docdir}/READ_ME!" "https://sourceforge.net/projects/mscorefonts2/files/README.md/download"

if ! head -n1 "${libdir}/refresh-msttcore-fonts.sh" | grep -q '^#!'; then
  sed -i '1i#!/bin/sh' "${libdir}/refresh-msttcore-fonts.sh"
fi
chmod 0755 "${libdir}/refresh-msttcore-fonts.sh"
chmod 0644 "${libdir}/cabfiles.sha256sums" "${docdir}/READ_ME!"

tar -C "${SOURCES_DIR}" -czf "${TARBALL}" "${SRC_DIR_NAME}"
cp -f "${SPEC_SRC_PATH}" "${SPECS_DIR}/"
rpmbuild -ba "${SPECS_DIR}/$(basename "${SPEC_SRC_PATH}")" --define "_topdir ${TOPDIR}"

find "${TOPDIR}/RPMS" -type f -name "${PKG_NAME}-${PKG_VER}-${PKG_REL}.noarch.rpm" -print -quit


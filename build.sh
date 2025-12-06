#!/usr/bin/env bash
set -e

PKG_NAME=msttcore-fonts-installer
PKG_VER=2.6
PKG_REL=1

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
DIST_DIR="$ROOT_DIR/dist"

usage() {
  cat <<EOF
Usage: $0 [deb] [rpm]

Examples:
  $0 deb          # build DEB only
  $0 rpm          # build RPM only
  $0 rpm deb      # build both
EOF
  exit 1
}

build_rpm() {
  echo "=== Building RPM package ==="

  local TOPDIR="$DIST_DIR/rpmbuild"
  local SOURCES="$TOPDIR/SOURCES"
  local SPECS="$TOPDIR/SPECS"
  local SPEC_SRC="$ROOT_DIR/rpm/msttcore-fonts-installer-2.6-1.spec"
  local TARBALL="$SOURCES/${PKG_NAME}-${PKG_VER}.tar.gz"

  mkdir -p "$SOURCES" "$SPECS"

  if command -v dnf >/dev/null 2>&1; then
    dnf -y install epel-release || true
    dnf -y install rpm-build curl cabextract fontconfig gzip tar || true
  elif command -v yum >/dev/null 2>&1; then
    yum -y install epel-release || true
    yum -y install rpm-build curl cabextract fontconfig gzip tar || true
  fi

  curl -fL -o "$TARBALL" "https://downloads.sourceforge.net/project/mscorefonts2/sources/${PKG_NAME}-${PKG_VER}.tar.gz"

  cp -f "$ROOT_DIR/rpm/refresh-msttcore-fonts.sh" "$SOURCES/refresh-msttcore-fonts.sh"
  cp -f "$SPEC_SRC" "$SPECS/"

  rpmbuild -ba "$SPECS/$(basename "$SPEC_SRC")" --define "_topdir $TOPDIR"

  echo
  echo "RPM built:"
  find "$TOPDIR/RPMS" -type f -name "${PKG_NAME}-${PKG_VER}-${PKG_REL}.noarch.rpm" -print
}

build_deb() {
  echo "=== Building DEB package ==="

  if command -v apt-get >/dev/null 2>&1; then
    apt-get update
    apt-get install -y build-essential debhelper cabextract fontconfig
  fi

  local BUILDROOT="$DIST_DIR/debbuild/src"

  rm -rf "$BUILDROOT"
  mkdir -p "$BUILDROOT"

  cp -a "$ROOT_DIR/deb/debian" "$BUILDROOT/debian"
  cp -a "$ROOT_DIR/deb/update-ms-fonts" "$BUILDROOT/update-ms-fonts"
  cp -a "$ROOT_DIR/deb/cabfiles.sha256sums" "$BUILDROOT/cabfiles.sha256sums"

  mkdir -p "$BUILDROOT/tools"
  cp -a "$ROOT_DIR/deb/tools/cleartype-fonts.sh" "$BUILDROOT/tools/cleartype-fonts.sh"

  (
    cd "$BUILDROOT"
    dpkg-buildpackage -us -uc
  )

  echo
  echo "DEB packages built:"
  ls -1 "$DIST_DIR"/debbuild/*.deb
}

if [ "$#" -eq 0 ]; then
  usage
fi

mkdir -p "$DIST_DIR"

DO_DEB=0
DO_RPM=0

for arg in "$@"; do
  case "$arg" in
    deb) DO_DEB=1 ;;
    rpm) DO_RPM=1 ;;
    *) usage ;;
  esac
done

[ "$DO_RPM" -eq 1 ] && build_rpm
[ "$DO_DEB" -eq 1 ] && build_deb


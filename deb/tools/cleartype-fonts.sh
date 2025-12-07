#!/bin/sh
# Install ClearType fonts from PowerPointViewer.exe
# (Calibri, Cambria, Candara, Consolas, Constantia, Corbel)

set -e

FONTDIR=/usr/share/fonts/truetype/msttcorefonts
DOC_DIR=/usr/share/doc/ttf-mscorefonts-installer
TMPDIR=$(mktemp -d /tmp/mstt-cleartype.XXXXXX)

cleanup() {
    rm -rf "$TMPDIR"
}
trap cleanup EXIT

mkdir -p "$FONTDIR" "$DOC_DIR"
cd "$TMPDIR"

BASE_URL="https://downloads.sourceforge.net/mscorefonts2"
PPT_EXE="$TMPDIR/PowerPointViewer.exe"

echo "Downloading PowerPointViewer.exe..." >&2

if command -v wget >/dev/null 2>&1; then
    wget -O "$PPT_EXE" "$BASE_URL/PowerPointViewer.exe"
elif command -v curl >/dev/null 2>&1; then
    curl -L -o "$PPT_EXE" "$BASE_URL/PowerPointViewer.exe"
else
    echo "Neither wget nor curl is available" >&2
    exit 1
fi

echo "Extracting ClearType fonts..." >&2

# EULA
cabextract -q -F 'eula.txt' "$PPT_EXE" || true
if [ -f eula.txt ]; then
    mv eula.txt "$DOC_DIR/EULA-cleartype.txt"
    gzip -f "$DOC_DIR/EULA-cleartype.txt" || true
fi

# CAB with ttf files
cabextract -q -F 'ppviewer.cab' "$PPT_EXE"
[ -f ppviewer.cab ] || { echo "ppviewer.cab not found"; exit 1; }

cabextract -q -F '*.ttf' --directory="$FONTDIR" ppviewer.cab

if command -v fc-cache >/dev/null 2>&1; then
    echo "Updating font cache..." >&2
    fc-cache -f "$FONTDIR" || true
fi

echo "ClearType fonts installed." >&2
exit 0


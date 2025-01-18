#!/usr/bin/env bash

set -e

VERSION=1.0.1
ARCHIVE="ghostty-${VERSION}.tar.gz"
VENDOR="vendor.tar.zst"
DIR="ghostty-${VERSION}"
URL="https://release.files.ghostty.org/${VERSION}/${ARCHIVE}"

mkdir -p tmp

if [ ! -d "tmp/${DIR}" ]
then
    cd tmp
    curl --output "${ARCHIVE}" "${URL}"
    tar -xf "${ARCHIVE}"
    cd ..
fi

# Fetch the dependencies and remove any large files/directories we don't need.
cd "tmp/${DIR}"
ZIG_GLOBAL_CACHE_DIR=vendor ./nix/build-support/fetch-zig-cache.sh
rm -rf vendor/p/*/{test,Test,screenshots,result,doc}
rm -f "${VENDOR}"
tar --create vendor | zstd -12 -o "${VENDOR}"
mv "${VENDOR}" "../${VENDOR}"
cd ../../

echo "      - type: archive"
echo "        url: ${URL}"
echo "        sha256: $(sha256sum "tmp/${ARCHIVE}" | cut -d ' ' -f 1)"
echo "        dest: ghostty"
echo "      - type: archive"
echo "        url: https://github.com/yorickpeterse/ghostty-flatpak/releases/download/${VERSION}/${VENDOR}"
echo "        sha256: $(sha256sum "tmp/${VENDOR}" | cut -d ' ' -f 1)"
echo "        dest: ghostty/vendor"

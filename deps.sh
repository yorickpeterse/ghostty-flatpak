#!/usr/bin/env bash

set -e

VERSION=1.0.0
ARCHIVE=ghostty-source.tar.gz

wget "https://release.files.ghostty.org/${VERSION}/${ARCHIVE}"
tar -xf "${ARCHIVE}"
rm "${ARCHIVE}"
cd ghostty-source

# Fetch the dependencies and remove any large files/directories we don't need.
ZIG_GLOBAL_CACHE_DIR=vendor ./nix/build-support/fetch-zig-cache.sh
rm -rf vendor/p/*/{test,Test,screenshots,result,doc}
tar -cf vendor.tar.gz vendor
mv vendor.tar.gz ../data/vendor.tar.gz

# Ghostty Flatpak

This repository contains a manifest and a few tools for building the
[Ghostty](https://github.com/ghostty-org/ghostty/) Flatpak package.

The Flatpak produced at this stage isn't super useful due to [this
issue](https://github.com/ghostty-org/ghostty/discussions/3616), but at least it
builds.

## Performing a release

1. Bump the version in `deps.sh`
1. Run `bash deps.sh`, copy the output to the manifest (overwriting the old data)
1. Push to GitHub
1. Create a new [GitHub
   release](https://github.com/yorickpeterse/ghostty-flatpak/releases/new)
   matching the new Ghostty version
1. Upload `tmp/vendor.tar.zst` as a release artifact
1. Publish the release

This process requires the following tools:

- bash
- curl
- sha256sum
- tar
- zig
- zstd

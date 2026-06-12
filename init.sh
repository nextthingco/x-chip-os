#!/bin/bash -ex

MIRROR=http://deb.debian.org/debian/

# Recommends are dropped for the headless flavor to trim the rootfs (smaller
# UBIFS fits the size-capped NAND flashers). gui keeps them on -- XFCE/desktop
# meta-packages pull in needed pieces via Recommends. init.sh is run from inside
# the flavor dir (`cd headless && bash ../init.sh`), so the dir name is the flavor.
case "$(basename "$PWD")" in
    headless) APT_RECOMMENDS=false ;;
    *)        APT_RECOMMENDS=true  ;;
esac

# --debootstrap-options "--include=ca-certificates": the CHIP kernel repo
# (config/archives) is HTTPS (GitHub Pages) and live-build contacts it while
# still in the fresh minbase chroot, before the package list installs
# ca-certificates. Without a CA bundle apt can't reach github.io, drops the
# repo, and the build dies with "Unable to locate package linux-image-chip".
# Pulling it into the bootstrap makes the CA bundle exist before that fetch.
lb config \
    --mode debian \
    --system normal \
    --architectures armhf \
    --distribution "trixie" \
    --archive-areas "main non-free-firmware" \
    --apt-recommends "$APT_RECOMMENDS" \
    --linux-packages none \
    --binary-images tar \
    --chroot-filesystem none \
    --firmware-chroot false \
    --firmware-binary false \
    --memtest none \
    --apt-indices false \
    --mirror-bootstrap "$MIRROR" \
    --mirror-chroot "$MIRROR" \
    --mirror-binary "$MIRROR" \
    --debootstrap-options "--include=ca-certificates"

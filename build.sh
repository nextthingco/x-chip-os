#!/bin/bash -ex

# Build one flavor's rootfs with live-build and drop the tarball at the repo
# root. Runs inside the armv7 container (see Makefile); needs root.
#   ./build.sh [flavor]      (default: headless)

FLAVOR=${1:-headless}
HERE=$(cd "$(dirname "$0")" && pwd)
cd "$HERE/$FLAVOR"

mkdir -p .build
touch .build/config

# Full pipeline. With --binary-images tar --chroot-filesystem none (set in
# init.sh), the binary stage just relocates the finished chroot into ./binary
# and the rest of the binary stage no-ops.
lb build

# binary/ is the rootfs tree. Repack it at the tar root (binary_tar's own
# tarball is prefixed with binary/, which the flasher doesn't want).
OUT="$HERE/$FLAVOR-rootfs.tar.gz"
tar -C binary -zcf "$OUT" .
[ -n "${HOST_UID:-}" ] && chown "$HOST_UID:$HOST_GID" "$OUT" || true

echo ">> wrote $OUT"

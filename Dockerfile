# armv7 (armhf) build container: live-build runs natively here, so the rootfs
# is bootstrapped without qemu foreign-bootstrap. Pull as linux/arm/v7 (the
# Makefile passes --platform; the host needs binfmt/qemu registered to run it).
FROM debian:trixie

RUN apt-get update && apt-get install -y --no-install-recommends \
        live-build \
        debootstrap \
        apt-utils \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

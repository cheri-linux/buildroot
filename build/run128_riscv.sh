#!/bin/sh -xe

BUILDROOT=${1:-.}

QEMUC=$BUILDROOT/host/cheri/bin/qemu-system-riscv64cheri
IMAGE=$BUILDROOT/images/Image
BBL=$BUILDROOT/images/bbl
ROOTFS=$BUILDROOT/images/rootfs.ext2
INITRAMFS=$BUILDROOT/images/rootfs.cpio

$QEMUC \
   -M virt \
   -nographic \
   -m 2048 \
   -bios $BBL \
   -kernel $IMAGE \
   -append "root=/dev/vda ro norandmaps" \
   -drive file=$ROOTFS,format=raw,id=hd0 \
   -device virtio-blk-device,drive=hd0 \
   -netdev user,id=net0,ipv6=off,hostfwd=tcp::7777-:22,hostfwd=tcp::7778-:2222 \
   -device virtio-net-device,netdev=net0 \
   -s

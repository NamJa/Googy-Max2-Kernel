#!/bin/bash

if [ -e boot.img ]; then
	rm boot.img
fi

if [ -e boot.img.pre ]; then
	rm boot.img.pre
fi

if [ -e compile.log ]; then
	rm compile.log
fi

if [ -e ramdisk.cpio.lzma ]; then
	rm ramdisk.cpio.lzma
fi

# Set Default Path
KERNEL_PATH=$PWD

TOOLCHAIN_PATH="/opt/android-toolchain-eabi-4.8-1312/bin/"
TOOLCHAIN="$TOOLCHAIN_PATH/arm-linux-androideabi-"

echo "Cleaning latest build"
make ARCH=arm CROSS_COMPILE=$TOOLCHAIN -j`grep 'processor' /proc/cpuinfo | wc -l` mrproper

# Cleaning old kernel and modules
find -name '*.ko' -exec rm -rf {} \;
rm -rf $KERNEL_PATH/arch/arm/boot/zImage
rm -rf $KERNEL_PATH/release/

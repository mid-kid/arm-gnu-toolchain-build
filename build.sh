#!/bin/sh
set -e
. ./env

mkdir -p build && cd build
if [ ! -d src ]; then
    mkdir -p src && cd src
    git clone -b $devtools_ver ../../src/gnu-devtools-for-arm
    tar xvf ../../src/arm-gnu-toolchain-src-snapshot-$ver.tar.xz
    cd ..
fi
ln -svf src/gnu-devtools-for-arm/build-gnu-toolchain.sh

# Release toolchain commands grabbed from gnu-devtools-for-arm/README.md
NPROC="${NPROC:-$(nproc)}"

if [ "$1" != aarch64 ]; then
    ./build-gnu-toolchain.sh --target=arm-none-eabi --aprofile  --rmprofile -- --release --package --enable-newlib-nano --enable-gdb-with-python=yes "-j$NPROC"
else
    ./build-gnu-toolchain.sh --target=aarch64-none-elf -- --release --package --enable-gdb-with-python=yes "-j$NPROC"
fi

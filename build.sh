#!/bin/sh
set -e
. ./env

build="$(./abe/config.guess)"

mkdir -p build && cd build
../abe/configure \
    --with-local-snapshots="$PWD/../snapshots"
../abe/abe.sh --manifest ../snapshots/arm-gnu-toolchain-arm-none-eabi-abe-manifest.txt \
    --release "$ver" \
    --disable update \
    --disable make_docs \
    --build all
rm -rf builds/hosttools "builds/$build"
cd ..

mkdir -p build_newlib && cd build_newlib
../abe/configure \
    --with-local-snapshots="$PWD/../snapshots"
../abe/abe.sh --manifest ../snapshots/arm-gnu-toolchain-arm-none-eabi-nano-abe-manifest.txt \
    --release "$ver" \
    --disable update \
    --disable make_docs \
    --build all
rm -rf builds/hosttools "builds/$build"
cd ..

./snapshots/copy_nano_libraries.sh "$build"
rm -rf build_newlib

mkdir -p build_aarch64 && cd build_aarch64
../abe/configure \
    --with-local-snapshots="$PWD/../snapshots"
../abe/abe.sh --manifest ../snapshots/arm-gnu-toolchain-aarch64-none-elf-abe-manifest.txt \
    --release "$ver" \
    --disable update \
    --disable make_docs \
    --build all
rm -rf builds/hosttools "builds/$build"
cd ..

# Strip
ARCH=arm-none-eabi ./strip.sh "build/builds/destdir/$build"
ARCH=aarch64-none-elf ./strip.sh "build_aarch64/builds/destdir/$build"

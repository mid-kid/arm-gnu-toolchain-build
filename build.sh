#!/bin/sh
set -e
. ./env

mkdir -p build && cd build
../abe/configure \
    --with-local-snapshots="$PWD/../snapshots"
../abe/abe.sh --manifest ../snapshots/arm-gnu-toolchain-arm-none-eabi-abe-manifest.txt \
    --release "$ver" \
    --disable update \
    --disable make_docs \
    --build all
cd ..

mkdir -p build_newlib && cd build_newlib
../abe/configure \
    --with-local-snapshots="$PWD/../snapshots"
../abe/abe.sh --manifest ../snapshots/arm-gnu-toolchain-arm-none-eabi-nano-abe-manifest.txt \
    --release "$ver" \
    --disable update \
    --disable make_docs \
    --build all
cd ..

./src/copy_nano_libraries.sh

mkdir -p build_aarch64 && cd build_aarch64
../abe/configure \
    --with-local-snapshots="$PWD/../snapshots"
../abe/abe.sh --manifest ../snapshots/arm-gnu-toolchain-aarch64-none-elf-abe-manifest.txt \
    --release "$ver" \
    --disable update \
    --disable make_docs \
    --build all
cd ..

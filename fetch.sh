#!/bin/sh
set -e
. ./env

if [ ! -d abe ]; then
    git clone https://git.linaro.org/toolchain/abe.git
    cd abe
    git checkout "master@{$abe_date}"
    cd ..
fi

dl() {
    file="${1##*/}"
    [ -f "$file" ] || wget "$1"
}

mkdir -p src && cd src
dl https://developer.arm.com/-/media/Files/downloads/gnu/$ver/manifest/arm-gnu-toolchain-arm-none-eabi-abe-manifest.txt
dl https://developer.arm.com/-/media/Files/downloads/gnu/$ver/manifest/arm-gnu-toolchain-arm-none-eabi-nano-abe-manifest.txt
dl https://developer.arm.com/-/media/Files/downloads/gnu/$ver/manifest/arm-gnu-toolchain-aarch64-none-elf-abe-manifest.txt
dl https://developer.arm.com/-/media/Files/downloads/gnu/$ver/manifest/copy_nano_libraries.sh
dl https://developer.arm.com/-/media/Files/downloads/gnu/$ver/srcrel/arm-gnu-toolchain-src-snapshot-$ver.tar.xz

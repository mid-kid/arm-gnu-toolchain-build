#!/bin/sh
set -e
. ./env

mkdir -p src && cd src

if [ ! -d gnu-devtools-for-arm ]; then
    git clone https://gitlab.arm.com/tooling/gnu-devtools-for-arm
fi

dl() {
    file="${1##*/}"
    [ -f "$file" ] || wget "$1"
}

#dl https://developer.arm.com/-/media/Files/downloads/gnu/$ver/srcrel/arm-gnu-toolchain-src-snapshot-$ver.tar.xz
dl https://gitlab.arm.com/api/v4/projects/tooling%2Fgnu-toolchains-for-arm/packages/generic/gnu-toolchain/$ver/arm-gnu-toolchain-src-snapshot-$ver.tar.xz

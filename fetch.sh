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

dl https://developer.arm.com/-/media/Files/downloads/gnu/$ver/srcrel/arm-gnu-toolchain-src-snapshot-$ver.tar.xz

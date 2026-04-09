#!/bin/sh
set -eu
. ./env

mkdir -p build && cd build
if [ ! -d src ]; then
    mkdir -p src && cd src
    git clone -b $devtools_ver ../../src/gnu-devtools-for-arm
    echo "Extracting arm-gnu-toolchain-src-snapshot-$ver.tar.xz..."
    tar xf ../../src/arm-gnu-toolchain-src-snapshot-$ver.tar.xz
    cd ..
fi
ln -svf src/gnu-devtools-for-arm/build-gnu-toolchain.sh

# Release toolchain commands grabbed from gnu-devtools-for-arm/README.md
NPROC="${NPROC:-$(nproc)}"

# Downgrade compiler flags that break the build
mkdir -p bin
for x in $(uname -m)-none-linux-gnu-gcc gcc; do
    command -v "$x" > /dev/null || continue
    echo '#!/bin/sh' > "bin/$x"
    echo 'exec '"'$(command -v "$x")'"' -std=gnu17 "$@"' >> "bin/$x"
    chmod +x "bin/$x"
done
export PATH="$PWD/bin:$PATH"

case "${1:-arm}" in
    arm)
        ./build-gnu-toolchain.sh --target=arm-none-eabi --aprofile  --rmprofile -- --release --package --enable-newlib-nano --enable-gdb-with-python=yes "-j$NPROC"
        ;;

    aarch64)
        ./build-gnu-toolchain.sh --target=aarch64-none-elf -- --release --package --enable-gdb-with-python=yes "-j$NPROC"
        ;;
esac

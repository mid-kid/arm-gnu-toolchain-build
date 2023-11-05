#!/bin/sh
set -e
. ./env

binutils_revision="$(. ./src/arm-gnu-toolchain-arm-none-eabi-abe-manifest.txt && echo "$binutils_revision")"
gdb_revision="$(. ./src/arm-gnu-toolchain-arm-none-eabi-abe-manifest.txt && echo "$gdb_revision")"

rm -rf snapshots
mkdir -p snapshots && cd snapshots
tar xf ../src/arm-gnu-toolchain-src-snapshot-$ver.tar.xz

do_tar() {
    touch "$2.tar.xz"
    md5sum "$2.tar.xz" > "$2.tar.xz.asc"
    touch "$1-$2-extract.stamp"
}
do_git() {
    mkdir -p "$2.git"
    git -C "$1" init -q
    GIT_AUTHOR_NAME=_ GIT_AUTHOR_EMAIL=_ \
    GIT_COMMITTER_NAME=_ GIT_COMMITTER_EMAIL=_ \
    git -C "$1" commit -q -m "" --allow-empty --allow-empty-message
    ln -sf "$1" "$2.git~_rev_$3"
}

do_tar gmp gmp
do_tar mpfr mpfr
do_tar mpc mpc
do_tar expat libexpat
do_tar libiconv libiconv
do_tar gcc gcc
do_tar newlib newlib-cygwin
do_git binutils-gdb binutils-gdb "$binutils_revision"
do_git binutils-gdb--gdb binutils-gdb "$gdb_revision"
ln -sf arm-gnu-toolchain-src-snapshot-*/ gcc

# Patch out unused components from manifests
for x in \
        arm-gnu-toolchain-arm-none-eabi-abe-manifest.txt \
        arm-gnu-toolchain-arm-none-eabi-nano-abe-manifest.txt \
        arm-gnu-toolchain-aarch64-none-elf-abe-manifest.txt; do
    sed -e '/^dejagnu_/d' -e '/^#.*\<dejagnu\>/d' \
        -e '/^python_/d' -e '/^#.*\<python\>/d' \
        "../src/$x" > "$x"
done

# Patch copy_nano_libraries.sh for different architectures
sed -e '/^host="/chost="$1"' ../src/copy_nano_libraries.sh > copy_nano_libraries.sh
chmod +x copy_nano_libraries.sh

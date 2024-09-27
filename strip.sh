#!/bin/sh
set -eu

ARCH="${ARCH:-arm-none-eabi}"

cd "$1"

# Remove useless files
rm -vf lib/*.a lib/*.la lib64/*.a lib64/*.la
rm -rvf lib/pkgconfig lib64/pkgconfig
rm -rvf lib/bfd-plugins/*.a lib64/bfd-plugins/*.a
rm -rvf include

strip -v --strip-all --remove-section=.comment bin/* "$ARCH"/bin/* || true
find libexec -type f -print0 | xargs -0 -r strip -v --strip-all --remove-section=.comment || true
find lib lib64 -name '*.so*' -print0 | xargs -0 -r strip -v --strip-unneeded --remove-section=.comment || true

find "lib/gcc/$ARCH" "$ARCH/lib" -type f \( -name '*.a' -o -name '*.o' \) -print0 | xargs -0 -L1 -r -t "./bin/$ARCH-strip" --strip-debug --remove-section=.comment || true
